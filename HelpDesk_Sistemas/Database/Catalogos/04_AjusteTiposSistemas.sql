-- ============================================================
-- Catálogos — 04: Ajuste de tipos de atención para Soporte Sistemas
--
-- Corrige 03_TiposAtencionPorArea.sql: Soporte Desarrollo y Soporte
-- Sistemas NO comparten exactamente los mismos 6 tipos. Desarrollo
-- tiene los 6 (Incidente, Mejoras, Correccion de Datos, Consultas/
-- Asesorias, Capacitación, Implementación); Sistemas tiene esos
-- mismos EXCEPTO Incidente y Mejoras (solo 4).
--
-- Se desactivan "Incidente" y "Mejoras" de Soporte Sistemas (y sus
-- categorías) — no se borran, por si ya se referenciaron en algún
-- lado. Verificado antes de aplicar: cero tickets reales los usan.
--
-- Idempotente. Ejecutar con UTF-8:
--   sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 04_AjusteTiposSistemas.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

DECLARE @IdAreaSistemas INT = (SELECT Id FROM Area WHERE Nombre = 'Soporte Sistemas');

UPDATE Tipo_Requerimiento
SET Activo = 0
WHERE Id_Area = @IdAreaSistemas AND Nombre IN ('Incidente', 'Mejoras') AND Activo = 1;

UPDATE Categoria
SET Activo = 0
WHERE Id_Tipo_Req IN (
    SELECT Id FROM Tipo_Requerimiento WHERE Id_Area = @IdAreaSistemas AND Nombre IN ('Incidente', 'Mejoras')
) AND Activo = 1;
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT a.Nombre AS Area, tr.Nombre AS Tipo, tr.Activo
FROM Tipo_Requerimiento tr
INNER JOIN Area a ON a.Id = tr.Id_Area
WHERE a.Nombre IN ('Soporte Sistemas', 'Soporte Desarrollo')
ORDER BY a.Nombre, tr.Nombre;
GO
