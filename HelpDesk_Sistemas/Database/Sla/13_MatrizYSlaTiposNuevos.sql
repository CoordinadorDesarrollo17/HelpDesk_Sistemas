-- ============================================================
-- Motor de SLA — 13: Matriz de prioridad y SLA para los tipos de
-- atención nuevos (ver Database/Catalogos/03_TiposAtencionPorArea.sql).
--
-- Copia la matriz Impacto x Urgencia y las definiciones de SLA del
-- tipo viejo equivalente hacia cada tipo nuevo, según su Flujo:
--   - Flujo 'Soporte' (usa Impacto/Urgencia)          -> copia de "Soporte"
--   - Flujo 'ImplementacionMejora', nombre 'Mejoras'   -> copia de "Mejora"
--   - Flujo 'ImplementacionMejora', nombre 'Implementación' -> copia de "Implementación"
-- Mismas duraciones ya calibradas, solo se re-apuntan al Id_Tipo_Req nuevo.
--
-- Idempotente. Ejecutar con UTF-8:
--   sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 13_MatrizYSlaTiposNuevos.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- ============================================================
-- 1) Matriz_Prioridad — para todo tipo nuevo con Usa_Impacto_Urgencia = 1,
--    copiando la matriz 3x3 (Impacto x Urgencia) del viejo "Soporte".
-- ============================================================

DECLARE @IdSoporteViejo INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Soporte' AND Id_Area IS NULL);

INSERT INTO Matriz_Prioridad (Id_Tipo_Req, Id_Impacto, Id_Urgencia, Id_Prioridad)
SELECT tr.Id, mp.Id_Impacto, mp.Id_Urgencia, mp.Id_Prioridad
FROM Tipo_Requerimiento tr
CROSS JOIN Matriz_Prioridad mp
WHERE tr.Activo = 1
  AND tr.Usa_Impacto_Urgencia = 1
  AND tr.Id_Area IS NOT NULL
  AND mp.Id_Tipo_Req = @IdSoporteViejo
  AND NOT EXISTS (
      SELECT 1 FROM Matriz_Prioridad existente
      WHERE existente.Id_Tipo_Req = tr.Id AND existente.Id_Impacto = mp.Id_Impacto AND existente.Id_Urgencia = mp.Id_Urgencia
  );
GO

-- ============================================================
-- 2) SLA_Definicion — 8 filas (4 Respuesta + 4 Resolución, una por
--    Prioridad) por cada tipo nuevo, copiadas del tipo viejo que le
--    corresponde según su Flujo/nombre.
-- ============================================================

DECLARE @Origenes TABLE (NombreViejo VARCHAR(100), NombreNuevo VARCHAR(100));
INSERT INTO @Origenes (NombreViejo, NombreNuevo) VALUES
    ('Soporte', 'Incidente'),
    ('Soporte', 'Solicitud'),
    ('Soporte', 'Consulta/Asesoria'),
    ('Soporte', 'Capacitación'),
    ('Soporte', 'Proyectos TI'),
    ('Soporte', 'Correccion de Datos'),
    ('Soporte', 'Consultas/Asesorias'),
    ('Mejora', 'Mejoras'),
    ('Implementación', 'Implementación');

INSERT INTO SLA_Definicion (Nombre, Tipo_SLA, Id_Tipo_Req, Id_Categoria, Id_Prioridad, Id_Sociedad, Id_Calendario, Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Activo, Usu_Creacion, Fecha_Creacion)
SELECT
    tr.Nombre + ' (' + a.Nombre + ') - ' + sd.Tipo_SLA + ' - ' + p.Nombre,
    sd.Tipo_SLA, tr.Id, sd.Id_Categoria, sd.Id_Prioridad, sd.Id_Sociedad, sd.Id_Calendario,
    sd.Duracion_Minutos, sd.Porcentaje_Advertencia, sd.Reactivable, 1, 'seed', GETDATE()
FROM Tipo_Requerimiento tr
INNER JOIN Area a ON a.Id = tr.Id_Area
INNER JOIN @Origenes o ON o.NombreNuevo = tr.Nombre
INNER JOIN Tipo_Requerimiento trViejo ON trViejo.Nombre = o.NombreViejo AND trViejo.Id_Area IS NULL
INNER JOIN SLA_Definicion sd ON sd.Id_Tipo_Req = trViejo.Id AND sd.Activo = 1
INNER JOIN Prioridad p ON p.Id = sd.Id_Prioridad
WHERE tr.Activo = 1
  AND tr.Id_Area IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM SLA_Definicion existente
      WHERE existente.Id_Tipo_Req = tr.Id AND existente.Tipo_SLA = sd.Tipo_SLA AND existente.Id_Prioridad = sd.Id_Prioridad
  );
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT a.Nombre AS Area, tr.Nombre AS Tipo,
       (SELECT COUNT(*) FROM Matriz_Prioridad mp WHERE mp.Id_Tipo_Req = tr.Id) AS FilasMatriz,
       (SELECT COUNT(*) FROM SLA_Definicion sd WHERE sd.Id_Tipo_Req = tr.Id AND sd.Activo = 1) AS FilasSla
FROM Tipo_Requerimiento tr
INNER JOIN Area a ON a.Id = tr.Id_Area
WHERE tr.Activo = 1
ORDER BY a.Nombre, tr.Nombre;
GO
