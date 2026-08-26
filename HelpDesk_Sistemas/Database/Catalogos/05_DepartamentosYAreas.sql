-- ============================================================
-- Catálogos — 05: Jerarquía Departamento -> Área (área propia del usuario)
--
-- Hoy `Area` cumple dos roles a la vez: (1) las 3 áreas de soporte que
-- enrutan tickets (Es_Area_Sistemas=1) y (2) el "área propia" plana de cada
-- usuario (22 filas genéricas). Este script separa el rol #2 en una
-- jerarquía real Departamento -> Área (catálogo real de la empresa),
-- SIN tocar el rol #1: las 3 áreas de soporte conservan su Id, Nombre y
-- flags — solo se les enlaza un Id_Departamento (a "DEP. DE SISTEMAS").
--
-- Se excluyen del catálogo pegado por el usuario: las 3 filas de Área bajo
-- "DEP. DE SISTEMAS" (ya existen como las 3 áreas de soporte) y 2 filas
-- huérfanas cuyo departamento no vino en los datos (confirmado con el
-- usuario: se omiten por ahora).
--
-- Idempotente. Ejecutar con UTF-8 (hay tildes/eñes):
--   sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 05_DepartamentosYAreas.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- 1) Tabla Departamento -----------------------------------------------------
IF OBJECT_ID('Departamento', 'U') IS NULL
BEGIN
    CREATE TABLE Departamento (
        Id INT IDENTITY PRIMARY KEY,
        Nombre VARCHAR(150) NOT NULL,
        Prefijo VARCHAR(20) NOT NULL,
        Activo BIT NOT NULL CONSTRAINT DF_Departamento_Activo DEFAULT(1),
        Usu_Creacion VARCHAR(50) NULL,
        Fecha_Creacion DATETIME NOT NULL CONSTRAINT DF_Departamento_FechaCreacion DEFAULT(GETDATE())
    );
END
GO

-- 2) Area.Id_Departamento ----------------------------------------------------
IF COL_LENGTH('Area', 'Id_Departamento') IS NULL
BEGIN
    ALTER TABLE Area ADD Id_Departamento INT NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Area_Departamento')
BEGIN
    ALTER TABLE Area ADD CONSTRAINT FK_Area_Departamento FOREIGN KEY (Id_Departamento) REFERENCES Departamento(Id);
END
GO

-- 3) Seed de Departamentos (12: 10 reales de la empresa + Sistemas) --------
DECLARE @Departamentos TABLE (Nombre VARCHAR(150), Prefijo VARCHAR(20));
INSERT INTO @Departamentos (Nombre, Prefijo) VALUES
    ('DEP. DE SISTEMAS',              'MANAGER'),
    ('DEP. DE COMPRAS',               'COMPRAS'),
    ('DEP. DE RECURSOS HUMANOS',      'RRHH'),
    ('DEP. DE DIRECCION TECNICA',     'DIRTEC'),
    ('DEP. COMERCIAL',                'COMERCIAL'),
    ('DEP. DE OPERACIONES',           'OPERAC'),
    ('DEP. DE FINANZAS Y CONTABILIDA','FINANZAS'),
    ('DEP. DE MANTENIMIENTO',         'MANT'),
    ('DEP. DE GERENCIA GENERAL',      'GERENCIA'),
    ('DEP. ADMINISTRATIVO',           'ADMIN'),
    ('GASTOS GENERALES',              'GASTOSG'),
    ('GASTOS VARIOS',                 'GASTOSV');

INSERT INTO Departamento (Nombre, Prefijo, Usu_Creacion)
SELECT nuevo.Nombre, nuevo.Prefijo, 'Migracion05'
FROM @Departamentos nuevo
WHERE NOT EXISTS (SELECT 1 FROM Departamento existente WHERE existente.Nombre = nuevo.Nombre);
GO

-- 4) Enlazar las 3 áreas de soporte a "DEP. DE SISTEMAS" (sin renombrarlas) -
UPDATE a
SET a.Id_Departamento = d.Id
FROM Area a
INNER JOIN Departamento d ON d.Nombre = 'DEP. DE SISTEMAS'
WHERE a.Es_Area_Sistemas = 1;
GO

-- 5) Desactivar las áreas genéricas viejas (planas, sin departamento) -------
-- Solo afecta filas que todavía no tienen Id_Departamento: en una segunda
-- corrida ya no encuentra nada que desactivar (idempotente).
UPDATE Area
SET Activo = 0
WHERE Es_Area_Sistemas = 0 AND Id_Departamento IS NULL AND Activo = 1;
GO

-- 5b) Quitar el UNIQUE de Area.Nombre a secas: nombres de área se repiten
-- legítimamente entre departamentos (y hasta dentro de uno mismo) en el
-- catálogo real -----------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'UQ__Area__75E3EFCFFA7D835F' AND type_desc = 'UNIQUE_CONSTRAINT')
    ALTER TABLE Area DROP CONSTRAINT UQ__Area__75E3EFCFFA7D835F;
GO

-- 6) Seed de las 54 áreas nuevas, ligadas a su Departamento -----------------
DECLARE @Areas TABLE (NombreDepartamento VARCHAR(150), NombreArea VARCHAR(150), Activo BIT);
INSERT INTO @Areas (NombreDepartamento, NombreArea, Activo) VALUES
    ('DEP. DE RECURSOS HUMANOS',       'AREA DE CONTRATACION Y DESARROLLO',            1),
    ('DEP. DE COMPRAS',                'AREA SUB-GERENCIA Y ANALISIS',                 1),
    ('DEP. DE COMPRAS',                'AREA COMPRAS DE EXISTENCIAS',                  1),
    ('DEP. DE COMPRAS',                'AREA DE ADQUISICION Y ABASTECIMIENTO',         1),
    ('DEP. DE RECURSOS HUMANOS',       'AREA DE BIENESTAR SOCIAL',                     1),
    ('DEP. DE RECURSOS HUMANOS',       'AREA DE COMPENSACIONES',                       1),
    ('DEP. DE DIRECCION TECNICA',      'AREA DE CONTROL DE CALIDAD',                   1),
    ('DEP. DE DIRECCION TECNICA',      'AREA DE FARMACOVIGILANCIA',                    1),
    ('DEP. DE COMPRAS',                'AREA DE COMPRAS',                              1),
    ('DEP. DE DIRECCION TECNICA',      'AREA DE REGULACIONES',                         0),
    ('DEP. COMERCIAL',                 'AREA SUB-GERENCIA Y ANALISIS',                 1),
    ('DEP. COMERCIAL',                 'AREA DE VENTAS ESTRATEG.',                     1),
    ('DEP. COMERCIAL',                 'AREA DE VENTAS CALL CENTER',                   0),
    ('DEP. COMERCIAL',                 'AREA DE VENTAS HORIZONTAL',                    1),
    ('DEP. COMERCIAL',                 'AREA DE MARKETING',                            1),
    ('DEP. ADMINISTRATIVO',            'AREA DE ATENCION AL CLIENTE',                  0),
    ('DEP. DE OPERACIONES',            'AREA DESPACHO ALM 1-2',                        0),
    ('DEP. DE OPERACIONES',            'AREA DE RECEPCIÓN Y CONTROL',                  0),
    ('DEP. DE OPERACIONES',            'AREA DE VERIFICACIÓN Y PACKING',               1),
    ('DEP. DE OPERACIONES',            'AREA DE PICKING ALM 08',                       0),
    ('DEP. DE OPERACIONES',            'AREA DE PREPARACIÓN DE PEDIDOS',               1),
    ('DEP. DE OPERACIONES',            'AREA DE RECEPCIÓN Y CONTROL',                  1),
    ('DEP. DE OPERACIONES',            'AREA DE ALMACÉN TERCIARIZADO',                 1),
    ('DEP. DE FINANZAS Y CONTABILIDA', 'AREA DE FACTURACION',                          1),
    ('DEP. DE OPERACIONES',            'AREA DE DISTRIBUCIÓN LOCAL',                   1),
    ('DEP. DE OPERACIONES',            'AREA DE DISTRIBUCIÓN PROVINCIA',               1),
    ('DEP. DE OPERACIONES',            'AREA DE TRANSPORTE',                           1),
    ('DEP. DE FINANZAS Y CONTABILIDA', 'AREA DE FINANZAS',                             1),
    ('DEP. DE FINANZAS Y CONTABILIDA', 'AREA DE CONTABILIDAD',                         1),
    ('DEP. DE FINANZAS Y CONTABILIDA', 'AREA DE TESORERIA',                            1),
    ('DEP. DE MANTENIMIENTO',          'AREA DE SEGURIDAD Y VIGILANCIA',               1),
    ('DEP. DE MANTENIMIENTO',          'AREA DE LIMPIEZA',                             1),
    ('DEP. DE MANTENIMIENTO',          'AREA DE INFRAESTRUCTURA',                      1),
    ('DEP. DE RECURSOS HUMANOS',       'AREA DE SST',                                  1),
    ('DEP. DE DIRECCION TECNICA',      'AREA DE ASEGURAMIENTO DE LA CALIDAD',          1),
    ('DEP. ADMINISTRATIVO',            'AREA BUSINESS INTELLIGENCE',                   1),
    ('DEP. DE RECURSOS HUMANOS',       'AREA DE RECURSOS HUMANOS',                     1),
    ('DEP. DE DIRECCION TECNICA',      'AREA DE DIRECCION TECNICA',                    1),
    ('DEP. COMERCIAL',                 'AREA COMERCIAL',                               1),
    ('DEP. DE OPERACIONES',            'AREA DE OPERACIONES',                          1),
    ('DEP. DE MANTENIMIENTO',          'AREA DE MANTENIMIENTO',                        1),
    ('DEP. ADMINISTRATIVO',            'AREA ADMINISTRATIVA',                          1),
    ('DEP. DE GERENCIA GENERAL',       'AREA GERENCIA GENERAL',                        1),
    ('DEP. DE GERENCIA GENERAL',       'AREA ASESORIA LEGAL Y AUDITOR.',               1),
    ('DEP. DE OPERACIONES',            'AREA SUB GERENCIA Y ANALISIS',                 0),
    ('DEP. ADMINISTRATIVO',            'SUB-AREA ADMINISTRATIVA',                      1),
    ('DEP. DE RECURSOS HUMANOS',       'AREA DE RECLUTAM. Y SELECCION',                1),
    ('GASTOS GENERALES',               'GASTOS GENERALES',                             1),
    ('GASTOS VARIOS',                  'GASTOS VARIOS',                                1),
    ('DEP. COMERCIAL',                 'VENTAS CALL CENTER-LIMA',                      1),
    ('DEP. COMERCIAL',                 'VENTAS CALL CENTER-PROVINCIA',                 1),
    ('DEP. ADMINISTRATIVO',            'AREA DE IMPORTACIONES',                        1),
    ('DEP. DE OPERACIONES',            'AREA DE RECEPCIÓN, ABASTECIMIENTO Y PICKING',  1),
    ('DEP. DE OPERACIONES',            'AREA DE RECEP. ABAST.Y PICKING',               1);

INSERT INTO Area (Nombre, Es_Area_Sistemas, Activo, Usu_Creacion, Requiere_Sistema, Id_Departamento)
SELECT nueva.NombreArea, 0, nueva.Activo, 'Migracion05', 0, d.Id
FROM @Areas nueva
INNER JOIN Departamento d ON d.Nombre = nueva.NombreDepartamento
WHERE NOT EXISTS (
    SELECT 1 FROM Area existente
    WHERE existente.Nombre = nueva.NombreArea AND existente.Id_Departamento = d.Id
);
GO

-- 7) Area.Prefijo queda obsoleto (el prefijo ahora vive en Departamento) ---
DECLARE @constraintName NVARCHAR(200);
SELECT @constraintName = dc.name
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON c.object_id = dc.parent_object_id AND c.column_id = dc.parent_column_id
WHERE dc.parent_object_id = OBJECT_ID('Area') AND c.name = 'Prefijo';

IF @constraintName IS NOT NULL
    EXEC('ALTER TABLE Area DROP CONSTRAINT [' + @constraintName + ']');

IF COL_LENGTH('Area', 'Prefijo') IS NOT NULL
    ALTER TABLE Area DROP COLUMN Prefijo;
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT Id, Nombre, Prefijo, Activo FROM Departamento ORDER BY Nombre;
GO

SELECT d.Nombre AS Departamento, COUNT(*) AS AreasActivas
FROM Area a
INNER JOIN Departamento d ON d.Id = a.Id_Departamento
WHERE a.Activo = 1
GROUP BY d.Nombre
ORDER BY d.Nombre;
GO

SELECT a.Id, a.Nombre, a.Es_Area_Sistemas, d.Nombre AS Departamento, d.Prefijo
FROM Area a
INNER JOIN Departamento d ON d.Id = a.Id_Departamento
WHERE a.Es_Area_Sistemas = 1
ORDER BY a.Id;
GO
