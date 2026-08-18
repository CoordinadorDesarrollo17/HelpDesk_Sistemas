-- ============================================================
-- Motor de SLA — 00: Rollback
-- Deshace por completo lo agregado por 01..06, en orden inverso de
-- dependencias. Úsalo si algo no calza y quieres volver al estado
-- anterior sin rastros del motor de SLA.
-- ============================================================

IF OBJECT_ID('sp_SLA_ActualizarEstados', 'P') IS NOT NULL DROP PROCEDURE sp_SLA_ActualizarEstados;
IF OBJECT_ID('sp_SLA_Reactivar', 'P')         IS NOT NULL DROP PROCEDURE sp_SLA_Reactivar;
IF OBJECT_ID('sp_SLA_Reanudar', 'P')          IS NOT NULL DROP PROCEDURE sp_SLA_Reanudar;
IF OBJECT_ID('sp_SLA_Pausar', 'P')            IS NOT NULL DROP PROCEDURE sp_SLA_Pausar;
IF OBJECT_ID('sp_SLA_DetenerPorEstado', 'P')  IS NOT NULL DROP PROCEDURE sp_SLA_DetenerPorEstado;
IF OBJECT_ID('sp_SLA_IniciarParaTicket', 'P') IS NOT NULL DROP PROCEDURE sp_SLA_IniciarParaTicket;
GO

IF OBJECT_ID('fn_SumarMinutosHabiles', 'FN')  IS NOT NULL DROP FUNCTION fn_SumarMinutosHabiles;
IF OBJECT_ID('fn_MinutosHabilesEntre', 'FN')  IS NOT NULL DROP FUNCTION fn_MinutosHabilesEntre;
GO

IF OBJECT_ID('Ticket_SLA', 'U')      IS NOT NULL DROP TABLE Ticket_SLA;
IF OBJECT_ID('SLA_Definicion', 'U')  IS NOT NULL DROP TABLE SLA_Definicion;
GO

IF OBJECT_ID('Calendario_Feriado', 'U') IS NOT NULL DROP TABLE Calendario_Feriado;
IF OBJECT_ID('Calendario_Horario', 'U') IS NOT NULL DROP TABLE Calendario_Horario;
IF OBJECT_ID('Calendario_Laboral', 'U') IS NOT NULL DROP TABLE Calendario_Laboral;
GO
