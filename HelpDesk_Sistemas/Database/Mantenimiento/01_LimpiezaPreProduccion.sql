-- Limpieza para pasar a producción: borra todos los Tickets y todos los
-- Usuarios de prueba, conservando únicamente a Maria Roman (Id=2, usuario
-- "manager1", Administrador). Los catálogos (Área, Rol, Categoría, Sociedad,
-- SLA_Definicion, Calendario laboral) NO se tocan: son configuración del
-- sistema, no datos de prueba.
--
-- IMPORTANTE: antes de correr esto se hizo un backup completo:
--   BACKUP DATABASE HELPDESK_V1 TO DISK = 'HELPDESK_V1_antes_de_limpieza_20260819.bak'
--
-- Ejecutar con: sqlcmd ... -f 65001 -i 01_LimpiezaPreProduccion.sql

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET NOCOUNT ON;
GO

DECLARE @IdUsuarioConservar INT = 2; -- Maria Roman (manager1)

-- 1) Tickets y todo lo que cuelga de ellos
DELETE FROM Ticket_Adjuntos;
DELETE FROM Ticket_Historial;
DELETE FROM Ticket_Pausas;
DELETE FROM Ticket_SLA;
DELETE FROM Tickets;

-- 2) Usuarios (excepto el que se conserva) y sus sociedades
-- Esto no debería ejecutarse en produccion ya que se tendría que volver a crear los usuarios
DELETE FROM Usuario_Sociedad WHERE Id_Usuario <> @IdUsuarioConservar;
DELETE FROM Usuarios WHERE Id <> @IdUsuarioConservar;

-- 3) Reiniciar los contadores IDENTITY para que arranquen limpios
DBCC CHECKIDENT ('Ticket_Adjuntos', RESEED, 0);
DBCC CHECKIDENT ('Ticket_Historial', RESEED, 0);
DBCC CHECKIDENT ('Ticket_Pausas', RESEED, 0);
DBCC CHECKIDENT ('Ticket_SLA', RESEED, 0);
DBCC CHECKIDENT ('Tickets', RESEED, 0);
DBCC CHECKIDENT ('Usuarios', RESEED, 2);          -- sigue existiendo Id=2
DBCC CHECKIDENT ('Usuario_Sociedad', RESEED, 24); -- sigue existiendo Id=24
GO

SELECT (SELECT COUNT(*) FROM Tickets) AS TicketsRestantes,
       (SELECT COUNT(*) FROM Usuarios) AS UsuariosRestantes;
SELECT Id, Usuario, Nombre, Apellido FROM Usuarios;
GO
