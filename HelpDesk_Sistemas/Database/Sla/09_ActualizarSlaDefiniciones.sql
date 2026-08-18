-- ============================================================
-- Motor de SLA — 09: Definiciones de SLA separadas por Tipo_Requerimiento
--
-- Reemplaza las 8 definiciones "comodín" (Id_Tipo_Req = NULL, aplicaban a
-- los 4 tipos por igual) por definiciones explícitas:
--   - Respuesta:  Consulta, Soporte, Implementación, Mejora (cada uno con
--                 sus propios tiempos).
--   - Resolución: SOLO Consulta y Soporte. Implementación/Mejora no reciben
--                 ninguna fila de Resolución a propósito — sp_SLA_IniciarParaTicket
--                 (sin cambios) simplemente no encuentra definición que matchee
--                 y no crea esa parte del SLA para ellos.
-- Las 8 definiciones viejas se desactivan (Activo = 0), no se borran, para
-- conservar el historial de qué SLA aplicaba a los tickets ya cerrados.
-- AJUSTAR los minutos a los tiempos reales de negocio.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

UPDATE SLA_Definicion SET Activo = 0 WHERE Usu_Creacion = 'seed_sla';
GO

DECLARE @IdCalendario INT = (SELECT TOP 1 Id FROM Calendario_Laboral WHERE Activo = 1);

DECLARE @IdConsulta INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Consulta');
DECLARE @IdSoporte  INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Soporte');
DECLARE @IdImpl     INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Implementación');
DECLARE @IdMejora   INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Mejora');

DECLARE @PBaja    INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Baja');
DECLARE @PMedia   INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Media');
DECLARE @PAlta    INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Alta');
DECLARE @PUrgente INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Urgente');

-- --------------------------------------------------------------
-- SOPORTE (incidentes reales) — tiempos agresivos, igual que antes
-- --------------------------------------------------------------
INSERT INTO SLA_Definicion (Nombre, Tipo_SLA, Id_Tipo_Req, Id_Prioridad, Id_Calendario, Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Usu_Creacion) VALUES
    ('Soporte - Respuesta - Urgente',  'Respuesta',  @IdSoporte, @PUrgente, @IdCalendario, 15,   80, 0, 'seed_sla_v2'),
    ('Soporte - Respuesta - Alta',     'Respuesta',  @IdSoporte, @PAlta,    @IdCalendario, 30,   80, 0, 'seed_sla_v2'),
    ('Soporte - Respuesta - Media',    'Respuesta',  @IdSoporte, @PMedia,   @IdCalendario, 120,  80, 0, 'seed_sla_v2'),
    ('Soporte - Respuesta - Baja',     'Respuesta',  @IdSoporte, @PBaja,    @IdCalendario, 240,  80, 0, 'seed_sla_v2'),
    ('Soporte - Resolución - Urgente', 'Resolucion', @IdSoporte, @PUrgente, @IdCalendario, 240,  80, 1, 'seed_sla_v2'),
    ('Soporte - Resolución - Alta',    'Resolucion', @IdSoporte, @PAlta,    @IdCalendario, 480,  80, 1, 'seed_sla_v2'),
    ('Soporte - Resolución - Media',   'Resolucion', @IdSoporte, @PMedia,   @IdCalendario, 1440, 80, 1, 'seed_sla_v2'),
    ('Soporte - Resolución - Baja',    'Resolucion', @IdSoporte, @PBaja,    @IdCalendario, 2880, 80, 1, 'seed_sla_v2');

-- --------------------------------------------------------------
-- CONSULTA (preguntas/dudas, tope de prioridad Media) — tiempos más relajados.
-- Se definen igual las 4 prioridades por si el ticket se escala manualmente.
-- --------------------------------------------------------------
INSERT INTO SLA_Definicion (Nombre, Tipo_SLA, Id_Tipo_Req, Id_Prioridad, Id_Calendario, Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Usu_Creacion) VALUES
    ('Consulta - Respuesta - Urgente',  'Respuesta',  @IdConsulta, @PUrgente, @IdCalendario, 30,   80, 0, 'seed_sla_v2'),
    ('Consulta - Respuesta - Alta',     'Respuesta',  @IdConsulta, @PAlta,    @IdCalendario, 60,   80, 0, 'seed_sla_v2'),
    ('Consulta - Respuesta - Media',    'Respuesta',  @IdConsulta, @PMedia,   @IdCalendario, 240,  80, 0, 'seed_sla_v2'),
    ('Consulta - Respuesta - Baja',     'Respuesta',  @IdConsulta, @PBaja,    @IdCalendario, 480,  80, 0, 'seed_sla_v2'),
    ('Consulta - Resolución - Urgente', 'Resolucion', @IdConsulta, @PUrgente, @IdCalendario, 480,  80, 1, 'seed_sla_v2'),
    ('Consulta - Resolución - Alta',    'Resolucion', @IdConsulta, @PAlta,    @IdCalendario, 960,  80, 1, 'seed_sla_v2'),
    ('Consulta - Resolución - Media',   'Resolucion', @IdConsulta, @PMedia,   @IdCalendario, 2880, 80, 1, 'seed_sla_v2'),
    ('Consulta - Resolución - Baja',    'Resolucion', @IdConsulta, @PBaja,    @IdCalendario, 4320, 80, 1, 'seed_sla_v2');

-- --------------------------------------------------------------
-- IMPLEMENTACIÓN / MEJORA — solo Respuesta (tiempo para tomar el
-- requerimiento para levantamiento). Sin Resolución a propósito.
-- --------------------------------------------------------------
INSERT INTO SLA_Definicion (Nombre, Tipo_SLA, Id_Tipo_Req, Id_Prioridad, Id_Calendario, Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Usu_Creacion) VALUES
    ('Implementación - Respuesta - Urgente', 'Respuesta', @IdImpl, @PUrgente, @IdCalendario, 240,  80, 0, 'seed_sla_v2'),
    ('Implementación - Respuesta - Alta',    'Respuesta', @IdImpl, @PAlta,    @IdCalendario, 480,  80, 0, 'seed_sla_v2'),
    ('Implementación - Respuesta - Media',   'Respuesta', @IdImpl, @PMedia,   @IdCalendario, 960,  80, 0, 'seed_sla_v2'),
    ('Implementación - Respuesta - Baja',    'Respuesta', @IdImpl, @PBaja,    @IdCalendario, 1440, 80, 0, 'seed_sla_v2'),
    ('Mejora - Respuesta - Urgente',         'Respuesta', @IdMejora, @PUrgente, @IdCalendario, 240,  80, 0, 'seed_sla_v2'),
    ('Mejora - Respuesta - Alta',            'Respuesta', @IdMejora, @PAlta,    @IdCalendario, 480,  80, 0, 'seed_sla_v2'),
    ('Mejora - Respuesta - Media',           'Respuesta', @IdMejora, @PMedia,   @IdCalendario, 960,  80, 0, 'seed_sla_v2'),
    ('Mejora - Respuesta - Baja',            'Respuesta', @IdMejora, @PBaja,    @IdCalendario, 1440, 80, 0, 'seed_sla_v2');
GO
