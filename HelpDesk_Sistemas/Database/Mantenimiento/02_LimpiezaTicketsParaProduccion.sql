-- ============================================================
-- Mantenimiento — 02: Limpieza de tickets de prueba para salir a producción
--
-- A diferencia de 01_LimpiezaPreProduccion.sql (que borraba también los
-- usuarios de prueba dejando solo a Maria Roman), esta vez se piden
-- conservar TODOS los usuarios ya creados — son las cuentas reales del
-- Departamento de Sistemas, no datos de prueba. Solo se borran los
-- Tickets y todo lo que cuelga de ellos (quedaron ~18 tickets de prueba
-- creados mientras se armaba y probaba el API de Power BI).
--
-- NO se toca: Usuarios, Usuario_Sociedad, ni ningún catálogo (Área,
-- Departamento, Sociedad, Rol, Tipo_Requerimiento, Categoria, Sistema,
-- Estado, Prioridad, Impacto, Urgencia, Matriz_Prioridad, SLA_Definicion,
-- Calendario_*) — es configuración real del sistema, no datos de prueba.
--
-- IMPORTANTE: correr con un backup completo hecho justo antes.
--
-- Ejecutar con: sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 02_LimpiezaTicketsParaProduccion.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET NOCOUNT ON;
GO

-- 1) Tickets y todo lo que cuelga de ellos (orden por FK)
DELETE FROM Ticket_SLA;
DELETE FROM Ticket_Historial;
DELETE FROM Ticket_Adjuntos;
DELETE FROM Ticket_Pausas;
DELETE FROM Tickets;

-- 2) Reiniciar los contadores IDENTITY para que arranquen limpios en producción
DBCC CHECKIDENT ('Ticket_SLA', RESEED, 0);
DBCC CHECKIDENT ('Ticket_Historial', RESEED, 0);
DBCC CHECKIDENT ('Ticket_Adjuntos', RESEED, 0);
DBCC CHECKIDENT ('Ticket_Pausas', RESEED, 0);
DBCC CHECKIDENT ('Tickets', RESEED, 0);
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM Tickets) AS Tickets,
    (SELECT COUNT(*) FROM Ticket_Adjuntos) AS Adjuntos,
    (SELECT COUNT(*) FROM Ticket_Historial) AS Historial,
    (SELECT COUNT(*) FROM Ticket_Pausas) AS Pausas,
    (SELECT COUNT(*) FROM Ticket_SLA) AS Sla,
    (SELECT COUNT(*) FROM Usuarios) AS Usuarios;

SELECT Id, Usuario, Nombre, Apellido, Activo FROM Usuarios ORDER BY Id;
GO
