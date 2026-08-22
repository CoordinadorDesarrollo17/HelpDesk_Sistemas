-- ============================================================
-- Catálogos — 03: Tipos de atención por área + categorías + Sistema
--
-- Reemplaza el catálogo global de Tipo_Requerimiento (Soporte /
-- Implementación / Mejora, sin distinción por área) por "tipos de
-- atención" específicos por área, según la taxonomía real de Cobefar
-- (fuente: "Tipos de atencion sistemas.xlsx"). Soporte Sistemas y
-- Soporte Desarrollo comparten la misma lista de 6 tipos, pero cada
-- uno como fila separada — igual que ya pasa con Categoria hoy.
--
-- Idempotente: se puede volver a ejecutar sin duplicar nada.
--
-- IMPORTANTE: ejecutar con codificación UTF-8, si no las tildes se
-- guardan mal:
--   sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 03_TiposAtencionPorArea.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- ============================================================
-- 1) Columnas nuevas
-- ============================================================

IF COL_LENGTH('Tipo_Requerimiento', 'Id_Area') IS NULL
    ALTER TABLE Tipo_Requerimiento ADD Id_Area INT NULL;
GO

-- 'Soporte' (flujo corto: Pendiente->En revisión->En atención->...->Cerrado) o
-- 'ImplementacionMejora' (flujo largo: Pendiente->Levantamiento->Desarrollo->
-- Pruebas->Pase a producción->Cierre). Reemplaza el viejo chequeo por nombre
-- ("TipoRequerimiento == 'Soporte'") que decidía esto antes.
IF COL_LENGTH('Tipo_Requerimiento', 'Flujo') IS NULL
    ALTER TABLE Tipo_Requerimiento ADD Flujo VARCHAR(20) NOT NULL CONSTRAINT DF_TipoReq_Flujo DEFAULT('Soporte');
GO

-- Si este tipo calcula la prioridad automática vía Impacto x Urgencia (antes
-- atado a Requiere_Categoria, que ahora es true para todos los tipos nuevos).
IF COL_LENGTH('Tipo_Requerimiento', 'Usa_Impacto_Urgencia') IS NULL
    ALTER TABLE Tipo_Requerimiento ADD Usa_Impacto_Urgencia BIT NOT NULL CONSTRAINT DF_TipoReq_UsaImpUrg DEFAULT(0);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_TipoReq_Area')
    ALTER TABLE Tipo_Requerimiento ADD CONSTRAINT FK_TipoReq_Area FOREIGN KEY (Id_Area) REFERENCES Area(Id);
GO

-- Nombre tenía UNIQUE global — bloquea que "Incidente"/"Mejoras"/etc. existan
-- como filas separadas para Soporte Sistemas y Soporte Desarrollo (mismo
-- patrón que ya usa Categoria: una fila por área aunque el nombre se repita).
-- Se reemplaza por UNIQUE(Nombre, Id_Area); SQL Server no cuenta como
-- duplicados dos NULL en Id_Area, así que las filas viejas desactivadas
-- (Soporte/Implementación/Mejora, sin Id_Area) no chocan entre sí.
IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('Tipo_Requerimiento') AND name = 'UQ__Tipo_Req__75E3EFCF4C4B7EF7')
    ALTER TABLE Tipo_Requerimiento DROP CONSTRAINT [UQ__Tipo_Req__75E3EFCF4C4B7EF7];
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('Tipo_Requerimiento') AND name = 'UQ_TipoReq_Nombre_Area')
    CREATE UNIQUE INDEX UQ_TipoReq_Nombre_Area ON Tipo_Requerimiento(Nombre, Id_Area);
GO

-- La categoría ahora depende de Área + Tipo, no solo de Área.
IF COL_LENGTH('Categoria', 'Id_Tipo_Req') IS NULL
    ALTER TABLE Categoria ADD Id_Tipo_Req INT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Categoria_TipoReq')
    ALTER TABLE Categoria ADD CONSTRAINT FK_Categoria_TipoReq FOREIGN KEY (Id_Tipo_Req) REFERENCES Tipo_Requerimiento(Id);
GO

-- true solo para Soporte Sistemas / Soporte Desarrollo (no Soporte TI).
IF COL_LENGTH('Area', 'Requiere_Sistema') IS NULL
    ALTER TABLE Area ADD Requiere_Sistema BIT NOT NULL CONSTRAINT DF_Area_RequiereSistema DEFAULT(0);
GO

UPDATE Area SET Requiere_Sistema = 1 WHERE Nombre IN ('Soporte Sistemas', 'Soporte Desarrollo');
GO

-- ============================================================
-- 2) Tabla Sistema + columna en Tickets
-- ============================================================

IF OBJECT_ID('Sistema', 'U') IS NULL
BEGIN
    CREATE TABLE Sistema (
        Id     INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(100) NOT NULL,
        Activo BIT NOT NULL CONSTRAINT DF_Sistema_Activo DEFAULT(1)
    );
END
GO

IF COL_LENGTH('Tickets', 'Id_Sistema') IS NULL
    ALTER TABLE Tickets ADD Id_Sistema INT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Tickets_Sistema')
    ALTER TABLE Tickets ADD CONSTRAINT FK_Tickets_Sistema FOREIGN KEY (Id_Sistema) REFERENCES Sistema(Id);
GO

INSERT INTO Sistema (Nombre)
SELECT v.Nombre
FROM (VALUES
    ('SOPHOS'), ('SAP B1'), ('Facturación Electrónica'), ('Página Web'),
    ('Intranet'), ('Extranet'), ('XAMPP')
) AS v(Nombre)
WHERE NOT EXISTS (SELECT 1 FROM Sistema s WHERE s.Nombre = v.Nombre);
GO

-- ============================================================
-- 3) Desactivar el catálogo viejo (no se borra: hay tickets reales
--    referenciándolo por FK).
-- ============================================================

UPDATE Tipo_Requerimiento SET Activo = 0
WHERE Nombre IN ('Soporte', 'Implementación', 'Mejora') AND Activo = 1;
GO

UPDATE Categoria SET Activo = 0
WHERE Id_Area IN (SELECT Id FROM Area WHERE Nombre IN ('Soporte TI', 'Soporte Sistemas', 'Soporte Desarrollo'))
  AND Activo = 1;
GO

-- ============================================================
-- 4) Tipos de atención nuevos
-- ============================================================

DECLARE @Tipos TABLE (Area VARCHAR(50), Nombre VARCHAR(100), Flujo VARCHAR(20), UsaImpUrg BIT, Orden INT);

INSERT INTO @Tipos (Area, Nombre, Flujo, UsaImpUrg, Orden) VALUES
    ('Soporte TI', 'Incidente',           'Soporte', 1, 1),
    ('Soporte TI', 'Solicitud',           'Soporte', 1, 2),
    ('Soporte TI', 'Consulta/Asesoria',   'Soporte', 1, 3),
    ('Soporte TI', 'Capacitación',        'Soporte', 1, 4),
    ('Soporte TI', 'Proyectos TI',        'Soporte', 1, 5),

    ('Soporte Sistemas', 'Incidente',             'Soporte',              1, 1),
    ('Soporte Sistemas', 'Mejoras',               'ImplementacionMejora', 0, 2),
    ('Soporte Sistemas', 'Correccion de Datos',   'Soporte',              1, 3),
    ('Soporte Sistemas', 'Consultas/Asesorias',   'Soporte',              1, 4),
    ('Soporte Sistemas', 'Capacitación',          'Soporte',              1, 5),
    ('Soporte Sistemas', 'Implementación',        'ImplementacionMejora', 0, 6),

    ('Soporte Desarrollo', 'Incidente',           'Soporte',              1, 1),
    ('Soporte Desarrollo', 'Mejoras',             'ImplementacionMejora', 0, 2),
    ('Soporte Desarrollo', 'Correccion de Datos', 'Soporte',              1, 3),
    ('Soporte Desarrollo', 'Consultas/Asesorias', 'Soporte',              1, 4),
    ('Soporte Desarrollo', 'Capacitación',        'Soporte',              1, 5),
    ('Soporte Desarrollo', 'Implementación',      'ImplementacionMejora', 0, 6);

INSERT INTO Tipo_Requerimiento (Nombre, Requiere_Categoria, Solo_Supervisor, Activo, Id_Area, Flujo, Usa_Impacto_Urgencia)
SELECT t.Nombre, 1, 0, 1, a.Id, t.Flujo, t.UsaImpUrg
FROM @Tipos t
INNER JOIN Area a ON a.Nombre = t.Area
WHERE NOT EXISTS (
    SELECT 1 FROM Tipo_Requerimiento tr WHERE tr.Nombre = t.Nombre AND tr.Id_Area = a.Id AND tr.Activo = 1
);
GO

-- ============================================================
-- 5) Categorías nuevas, ligadas a Área + Tipo
-- ============================================================

-- 5a) Soporte TI — categorías propias, no se comparten con otra área.
DECLARE @CatTI TABLE (Tipo VARCHAR(100), Categoria VARCHAR(200));

INSERT INTO @CatTI (Tipo, Categoria) VALUES
    ('Incidente', 'Error de acceso'),
    ('Incidente', 'Error de impresión'),
    ('Incidente', 'Problema de conectividad'),
    ('Incidente', 'Caída servicio'),
    ('Incidente', 'Problema de equipo'),
    ('Incidente', 'Problema de software'),
    ('Incidente', 'Incidente de seguridad'),
    ('Incidente', 'Otro incidente'),

    ('Solicitud', 'Creación de usuario'),
    ('Solicitud', 'Modificación de usuario'),
    ('Solicitud', 'Baja / bloqueo de usuario'),
    ('Solicitud', 'Solicitud de acceso'),
    ('Solicitud', 'Solicitud de permisos'),
    ('Solicitud', 'Instalación / configuración de aplicaciones o software'),
    ('Solicitud', 'Configuración de equipo'),
    ('Solicitud', 'Configuración de impresora'),
    ('Solicitud', 'Configuración de correo'),
    ('Solicitud', 'Acceso a carpetas'),
    ('Solicitud', 'Carga de información estándar'),
    ('Solicitud', 'Restauración de información'),
    ('Solicitud', 'Mantenimiento preventivo'),

    ('Consulta/Asesoria', 'Consulta funcional básica'),
    ('Consulta/Asesoria', 'Orientación de uso'),
    ('Consulta/Asesoria', 'Consulta de seguridad'),

    ('Capacitación', 'Concientización de seguridad'),
    ('Capacitación', 'Capacitación en ciberseguridad'),
    ('Capacitación', 'Capacitación funcional'),

    ('Proyectos TI', 'Actualización tecnológica'),
    ('Proyectos TI', 'Proyecto de seguridad TI'),
    ('Proyectos TI', 'Proyecto de infraestructura'),
    ('Proyectos TI', 'Implementación de infraestructura'),
    ('Proyectos TI', 'Migración de sistema');

INSERT INTO Categoria (Nombre, Id_Area, Id_Tipo_Req, Activo, Usu_Creacion, Fecha_Creacion)
SELECT c.Categoria, a.Id, tr.Id, 1, 'seed', GETDATE()
FROM @CatTI c
INNER JOIN Area a ON a.Nombre = 'Soporte TI'
INNER JOIN Tipo_Requerimiento tr ON tr.Nombre = c.Tipo AND tr.Id_Area = a.Id AND tr.Activo = 1
WHERE NOT EXISTS (
    SELECT 1 FROM Categoria existente WHERE existente.Id_Tipo_Req = tr.Id AND existente.Nombre = c.Categoria
);
GO

-- 5b) Soporte Sistemas + Soporte Desarrollo — mismas categorías,
--     insertadas para las dos áreas (una fila por área, igual que los tipos).
DECLARE @CatSisDes TABLE (Tipo VARCHAR(100), Categoria VARCHAR(200));

INSERT INTO @CatSisDes (Tipo, Categoria) VALUES
    ('Incidente', 'Error de aplicación / sistema'),
    ('Incidente', 'Error de formulario'),
    ('Incidente', 'Error de proceso'),
    ('Incidente', 'Error de integración'),
    ('Incidente', 'Error de datos generado por código'),
    ('Incidente', 'Problema de rendimiento de aplicación'),

    ('Mejoras', 'Modificación de funcionalidad'),
    ('Mejoras', 'Modificación de formulario'),
    ('Mejoras', 'Modificación de reporte'),
    ('Mejoras', 'Modificación de formato'),
    ('Mejoras', 'Modificación de regla de negocio'),
    ('Mejoras', 'Optimización'),
    ('Mejoras', 'Modificación de integración'),
    ('Mejoras', 'Mejora de experiencia de usuario'),

    ('Correccion de Datos', 'Corrección de registros'),
    ('Correccion de Datos', 'Corrección mediante script'),
    ('Correccion de Datos', 'Corrección masiva de datos'),
    ('Correccion de Datos', 'Carga / actualización de datos'),
    ('Correccion de Datos', 'Migración de datos'),
    ('Correccion de Datos', 'Otro'),

    ('Consultas/Asesorias', 'Consulta funcional'),
    ('Consultas/Asesorias', 'Consulta sobre reporte'),
    ('Consultas/Asesorias', 'Consulta sobre datos'),
    ('Consultas/Asesorias', 'Consulta técnica'),
    ('Consultas/Asesorias', 'Validación de funcionalidad'),
    ('Consultas/Asesorias', 'Orientación de uso'),
    ('Consultas/Asesorias', 'Consulta sobre SAP'),
    ('Consultas/Asesorias', 'Consulta sobre CRM'),

    ('Capacitación', 'Capacitación Sistema Web / Intranet'),
    ('Capacitación', 'Capacitación sobre nueva funcionalidad'),
    ('Capacitación', 'Capacitación SAP'),
    ('Capacitación', 'Capacitación CRM'),

    ('Implementación', 'Implementación de nuevo sistema'),
    ('Implementación', 'Nuevo módulo'),
    ('Implementación', 'Nueva funcionalidad'),
    ('Implementación', 'Nuevo formulario'),
    ('Implementación', 'Nuevo reporte'),
    ('Implementación', 'Nueva aplicación'),
    ('Implementación', 'Nueva integración'),
    ('Implementación', 'Nueva API / Web Service'),
    ('Implementación', 'Automatización');

INSERT INTO Categoria (Nombre, Id_Area, Id_Tipo_Req, Activo, Usu_Creacion, Fecha_Creacion)
SELECT c.Categoria, a.Id, tr.Id, 1, 'seed', GETDATE()
FROM @CatSisDes c
CROSS JOIN Area a
INNER JOIN Tipo_Requerimiento tr ON tr.Nombre = c.Tipo AND tr.Id_Area = a.Id AND tr.Activo = 1
WHERE a.Nombre IN ('Soporte Sistemas', 'Soporte Desarrollo')
  AND NOT EXISTS (
      SELECT 1 FROM Categoria existente WHERE existente.Id_Tipo_Req = tr.Id AND existente.Nombre = c.Categoria
  );
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT a.Nombre AS Area, tr.Nombre AS Tipo, tr.Flujo, tr.Usa_Impacto_Urgencia, COUNT(c.Id) AS Categorias
FROM Tipo_Requerimiento tr
INNER JOIN Area a ON a.Id = tr.Id_Area
LEFT JOIN Categoria c ON c.Id_Tipo_Req = tr.Id AND c.Activo = 1
WHERE tr.Activo = 1
GROUP BY a.Nombre, tr.Nombre, tr.Flujo, tr.Usa_Impacto_Urgencia, tr.Id_Area
ORDER BY a.Nombre, tr.Nombre;
GO
