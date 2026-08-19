-- Faltaban las definiciones de Resolución para Implementación y Mejora: solo
-- existía Resolución para Soporte, así que esos tickets nunca llegaban a medir
-- cumplimiento de resolución, solo de respuesta.
--
-- Duraciones en días hábiles (calendario "Horario Laboral COBEFAR", jornada de
-- 8h): más largas que las de Soporte porque una implementación/mejora es un
-- proyecto, no una incidencia puntual.
--   Urgente: 1 día hábil  = 480 min
--   Alta:    3 días hábiles = 1440 min
--   Media:   7 días hábiles = 3360 min
--   Baja:    15 días hábiles = 7200 min
--
-- Ejecutar con: sqlcmd ... -f 65001 -i 12_ResolucionImplementacionMejora.sql

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

DECLARE @IdCalendario INT = 1; -- Horario Laboral COBEFAR
DECLARE @IdImplementacion INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Implementación');
DECLARE @IdMejora INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Mejora');
DECLARE @IdBaja INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Baja');
DECLARE @IdMedia INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Media');
DECLARE @IdAlta INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Alta');
DECLARE @IdUrgente INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Urgente');

DECLARE @Nuevas TABLE (Nombre VARCHAR(150), IdTipoReq INT, IdPrioridad INT, DuracionMinutos INT);

INSERT INTO @Nuevas (Nombre, IdTipoReq, IdPrioridad, DuracionMinutos) VALUES
    ('Implementación - Resolución - Baja',    @IdImplementacion, @IdBaja,    7200),
    ('Implementación - Resolución - Media',   @IdImplementacion, @IdMedia,   3360),
    ('Implementación - Resolución - Alta',    @IdImplementacion, @IdAlta,    1440),
    ('Implementación - Resolución - Urgente', @IdImplementacion, @IdUrgente,  480),
    ('Mejora - Resolución - Baja',            @IdMejora,          @IdBaja,    7200),
    ('Mejora - Resolución - Media',           @IdMejora,          @IdMedia,   3360),
    ('Mejora - Resolución - Alta',            @IdMejora,          @IdAlta,    1440),
    ('Mejora - Resolución - Urgente',         @IdMejora,          @IdUrgente,  480);

INSERT INTO SLA_Definicion
    (Nombre, Tipo_SLA, Id_Tipo_Req, Id_Categoria, Id_Prioridad, Id_Sociedad, Id_Calendario,
     Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Activo, Usu_Creacion, Fecha_Creacion)
SELECT
    n.Nombre, 'Resolucion', n.IdTipoReq, NULL, n.IdPrioridad, NULL, @IdCalendario,
    n.DuracionMinutos, 80, 1, 1, 'seed', GETDATE()
FROM @Nuevas n
WHERE NOT EXISTS (
    SELECT 1 FROM SLA_Definicion existente
    WHERE existente.Tipo_SLA = 'Resolucion'
      AND existente.Id_Tipo_Req = n.IdTipoReq
      AND existente.Id_Prioridad = n.IdPrioridad
      AND existente.Id_Categoria IS NULL
      AND existente.Id_Sociedad IS NULL
);
GO

SELECT d.Nombre, d.Duracion_Minutos, d.Activo
FROM SLA_Definicion d
INNER JOIN Tipo_Requerimiento tr ON tr.Id = d.Id_Tipo_Req
WHERE d.Tipo_SLA = 'Resolucion' AND tr.Nombre IN ('Implementación', 'Mejora')
ORDER BY tr.Nombre, d.Duracion_Minutos DESC;
GO
