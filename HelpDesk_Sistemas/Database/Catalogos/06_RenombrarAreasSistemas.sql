-- ============================================================
-- Catálogos — 06: Nombres oficiales de las 3 áreas de Sistemas
--
-- Podrían incorporarse nuevos miembros a Sistemas, así que el
-- departamento y sus 3 áreas deben mostrarse con el nombre oficial real
-- de la empresa (el mismo catálogo pegado en 05), no con el nombre corto
-- interno que se usó hasta ahora. El cambio es sobre el mismo registro
-- (mismo Id, mismos flags Es_Area_Sistemas/Requiere_Sistema): se sigue
-- viendo en toda la parte de tickets (crear, listado, reportes, SLA).
--
-- Idempotente. Ejecutar con UTF-8:
--   sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 06_RenombrarAreasSistemas.sql
-- ============================================================

UPDATE Area SET Nombre = 'SOPORTE TI Y SEGUR. INFORMATICA' WHERE Id = 3 AND Nombre = 'Soporte TI';
UPDATE Area SET Nombre = 'AREA DE SISTEMAS'                WHERE Id = 4 AND Nombre = 'Soporte Sistemas';
UPDATE Area SET Nombre = 'DESARROLLO DE PROYECTOS'         WHERE Id = 5 AND Nombre = 'Soporte Desarrollo';
GO

SELECT Id, Nombre, Es_Area_Sistemas, Requiere_Sistema FROM Area WHERE Es_Area_Sistemas = 1 ORDER BY Id;
GO
