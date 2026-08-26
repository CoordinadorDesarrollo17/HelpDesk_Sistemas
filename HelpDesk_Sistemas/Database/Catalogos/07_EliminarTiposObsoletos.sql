-- ============================================================
-- Catálogos — 07: Elimina definitivamente los tipos de atención obsoletos
--
-- Hasta ahora los tipos retirados se desactivaban (Activo=0) en vez de
-- borrarse, porque había tickets reales referenciándolos. Con la tabla
-- de tickets ya limpia (ver Database/Mantenimiento, limpieza para
-- pruebas desde cero) esos 6 tipos ya no tienen ningún dato real
-- dependiendo de ellos, así que se eliminan por completo:
--
--   1  Consulta               (tipo global viejo, pre-rediseño por área)
--   2  Soporte                (tipo global viejo)
--   3  Implementación         (tipo global viejo)
--   4  Mejora                 (tipo global viejo)
--   16 Incidente (AREA DE SISTEMAS)  -- Sistemas no maneja Incidente
--   17 Mejoras   (AREA DE SISTEMAS)  -- Sistemas no maneja Mejoras
--
-- Verificado antes de aplicar: Tickets, Ticket_SLA y Guias_Anexos no
-- tienen ninguna fila que dependa de estos 6 tipos ni de sus categorías.
--
-- Idempotente (los DELETE simplemente no afectan filas si ya se aplicó).
-- Ejecutar con UTF-8:
--   sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 07_EliminarTiposObsoletos.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

DECLARE @Tipos TABLE (Id INT);
INSERT INTO @Tipos (Id) VALUES (1), (2), (3), (4), (16), (17);

DELETE FROM SLA_Definicion WHERE Id_Tipo_Req IN (SELECT Id FROM @Tipos);
DELETE FROM Matriz_Prioridad WHERE Id_Tipo_Req IN (SELECT Id FROM @Tipos);
DELETE FROM Categoria WHERE Id_Tipo_Req IN (SELECT Id FROM @Tipos);
DELETE FROM Tipo_Requerimiento WHERE Id IN (SELECT Id FROM @Tipos);
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT tr.Id, tr.Nombre, a.Nombre AS Area, tr.Activo
FROM Tipo_Requerimiento tr
LEFT JOIN Area a ON a.Id = tr.Id_Area
ORDER BY tr.Activo, a.Nombre, tr.Nombre;
GO
