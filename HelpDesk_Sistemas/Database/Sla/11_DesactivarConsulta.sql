-- ============================================================
-- 11: Se retira "Consulta" como Tipo_Requerimiento — de ahora en
-- adelante solo existen Soporte, Implementación y Mejora.
--
-- Se desactiva (Activo = 0), no se borra: conserva cualquier ticket
-- histórico que ya la tenga y no rompe las FK de SLA_Definicion /
-- Matriz_Prioridad. ObtenerTiposRequerimiento() ya filtra por
-- Activo = 1, así que el combo deja de mostrarla sin tocar código.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

UPDATE Tipo_Requerimiento SET Activo = 0 WHERE Nombre = 'Consulta';

UPDATE SLA_Definicion
SET Activo = 0
WHERE Id_Tipo_Req = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Consulta');
GO
