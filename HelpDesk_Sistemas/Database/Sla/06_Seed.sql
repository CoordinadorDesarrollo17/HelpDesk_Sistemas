-- ============================================================
-- Motor de SLA — 06: Datos iniciales (ejemplo)
-- Calendario Lun-Vie 08:00-18:00 y definiciones de SLA por Prioridad,
-- una de Respuesta y una de Resolución por cada prioridad existente.
-- AJUSTAR los minutos/horario reales de negocio antes de usar en producción;
-- esto solo deja el motor operativo con valores razonables por defecto.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

DECLARE @IdCalendario INT;

INSERT INTO Calendario_Laboral (Nombre, Usu_Creacion)
VALUES ('Horario Laboral COBEFAR', 'seed_sla');

SET @IdCalendario = SCOPE_IDENTITY();

-- Lunes(2) a Viernes(6), 08:00 - 18:00
INSERT INTO Calendario_Horario (Id_Calendario, Dia_Semana, Hora_Inicio, Hora_Fin)
VALUES
    (@IdCalendario, 2, '08:00', '18:00'),
    (@IdCalendario, 3, '08:00', '18:00'),
    (@IdCalendario, 4, '08:00', '18:00'),
    (@IdCalendario, 5, '08:00', '18:00'),
    (@IdCalendario, 6, '08:00', '18:00');

-- Feriados de ejemplo (Perú 2026) — ajustar según corresponda.
INSERT INTO Calendario_Feriado (Id_Calendario, Fecha, Descripcion, Usu_Creacion)
VALUES
    (@IdCalendario, '2026-01-01', 'Año Nuevo', 'seed_sla'),
    (@IdCalendario, '2026-05-01', 'Día del Trabajo', 'seed_sla'),
    (@IdCalendario, '2026-07-28', 'Fiestas Patrias', 'seed_sla'),
    (@IdCalendario, '2026-07-29', 'Fiestas Patrias', 'seed_sla'),
    (@IdCalendario, '2026-12-25', 'Navidad', 'seed_sla');

-- --------------------------------------------------------------
-- Definiciones de SLA por Prioridad (aplican a cualquier tipo de
-- requerimiento/categoría/sociedad — Id_Tipo_Req/Id_Categoria/Id_Sociedad
-- quedan en NULL a propósito).
-- --------------------------------------------------------------

INSERT INTO SLA_Definicion (Nombre, Tipo_SLA, Id_Prioridad, Id_Calendario, Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Usu_Creacion)
SELECT 'Respuesta - Urgente',  'Respuesta',  Id, @IdCalendario, 15,   80, 0, 'seed_sla' FROM Prioridad WHERE Nombre = 'Urgente'
UNION ALL
SELECT 'Respuesta - Alta',     'Respuesta',  Id, @IdCalendario, 30,   80, 0, 'seed_sla' FROM Prioridad WHERE Nombre = 'Alta'
UNION ALL
SELECT 'Respuesta - Media',    'Respuesta',  Id, @IdCalendario, 120,  80, 0, 'seed_sla' FROM Prioridad WHERE Nombre = 'Media'
UNION ALL
SELECT 'Respuesta - Baja',     'Respuesta',  Id, @IdCalendario, 240,  80, 0, 'seed_sla' FROM Prioridad WHERE Nombre = 'Baja'
UNION ALL
SELECT 'Resolución - Urgente', 'Resolucion', Id, @IdCalendario, 240,  80, 1, 'seed_sla' FROM Prioridad WHERE Nombre = 'Urgente'
UNION ALL
SELECT 'Resolución - Alta',    'Resolucion', Id, @IdCalendario, 480,  80, 1, 'seed_sla' FROM Prioridad WHERE Nombre = 'Alta'
UNION ALL
SELECT 'Resolución - Media',   'Resolucion', Id, @IdCalendario, 1440, 80, 1, 'seed_sla' FROM Prioridad WHERE Nombre = 'Media'
UNION ALL
SELECT 'Resolución - Baja',    'Resolucion', Id, @IdCalendario, 2880, 80, 1, 'seed_sla' FROM Prioridad WHERE Nombre = 'Baja';
GO
