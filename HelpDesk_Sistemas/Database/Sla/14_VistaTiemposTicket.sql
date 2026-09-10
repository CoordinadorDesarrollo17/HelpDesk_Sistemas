-- ============================================================
-- Motor de SLA -- 14: Vista vw_TiemposTicket  (solo reportería / Power BI)
--
-- Descompone el tiempo de cada ticket en sus tres tramos. NO toca el motor
-- de SLA: solo LEE Ticket_SLA + Tickets. Es la "resta" para separar la
-- espera en cola del trabajo real del asesor.
--
--   Cola             = creación del ticket  ->  un asesor lo toma
--   Trabajo asesor   = un asesor lo toma    ->  se resuelve
--   Resolución total = creación del ticket  ->  se resuelve   ( = Cola + Trabajo asesor )
--
--   "lo toma"      = cierre del SLA de Respuesta   (estado 'En revisión' / 'Levantamiento')
--   "se resuelve"  = cierre del SLA de Resolución  (estado 'En validación' / 'Pase a producción')
--
-- Cada tramo viene en dos versiones:
--   *_Habil  -> minutos hábiles: mismo cálculo que el SLA (calendario laboral + feriados)
--   *_Reloj  -> minutos corridos (wall-clock), tiempo real transcurrido
--
-- Tickets sin tomar / sin resolver: los tramos que aún no ocurren quedan NULL.
-- Para el trabajo neto del asesor (sin la espera al usuario), restar en el
-- reporte: MinTrabajoAsesor_Habil - MinPausadosResolucion.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER VIEW vw_TiemposTicket
AS
SELECT
    t.Id                        AS IdTicket,
    t.Codigo_Ticket             AS CodigoTicket,
    est.Nombre                  AS EstadoActual,
    tr.Nombre                   AS TipoRequerimiento,
    pr.Nombre                   AS Prioridad,
    t.Id_Area                   AS IdArea,
    a.Nombre                    AS Area,
    a.Id_Departamento           AS IdDepartamento,
    d.Nombre                    AS Departamento,
    soc.Nombre                  AS Sociedad,
    LTRIM(RTRIM(ISNULL(ua.Nombre, '') + ' ' + ISNULL(ua.Apellido, ''))) AS AsesorAsignado,

    t.Fecha_Creacion            AS FechaCreacion,
    resp.Fecha_Fin              AS FechaToma,
    reso.Fecha_Fin              AS FechaResolucion,

    CAST(CASE WHEN resp.Fecha_Fin IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS TicketTomado,
    CAST(CASE WHEN reso.Fecha_Fin IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS TicketResuelto,

    -- ---- minutos hábiles (igual que el SLA) ----
    CASE WHEN resp.Fecha_Fin IS NULL THEN NULL
         ELSE dbo.fn_MinutosHabilesEntre(t.Fecha_Creacion, resp.Fecha_Fin, resp.Id_Calendario) END AS MinCola_Habil,
    calc.MinTrabajoAsesor_Habil,
    CASE WHEN reso.Fecha_Fin IS NULL THEN NULL
         ELSE dbo.fn_MinutosHabilesEntre(t.Fecha_Creacion, reso.Fecha_Fin, reso.Id_Calendario) END AS MinResolucionTotal_Habil,

    -- ---- minutos corridos (wall-clock) ----
    CASE WHEN resp.Fecha_Fin IS NULL THEN NULL ELSE DATEDIFF(MINUTE, t.Fecha_Creacion, resp.Fecha_Fin) END AS MinCola_Reloj,
    CASE WHEN reso.Fecha_Fin IS NULL OR resp.Fecha_Fin IS NULL THEN NULL ELSE DATEDIFF(MINUTE, resp.Fecha_Fin, reso.Fecha_Fin) END AS MinTrabajoAsesor_Reloj,
    CASE WHEN reso.Fecha_Fin IS NULL THEN NULL ELSE DATEDIFF(MINUTE, t.Fecha_Creacion, reso.Fecha_Fin) END AS MinResolucionTotal_Reloj,

    -- ---- objetivos y cumplimiento (tal como lo registra el motor) ----
    resp.Minutos_Objetivo         AS MinObjetivoRespuesta,
    reso.Minutos_Objetivo         AS MinObjetivoResolucion,
    resp.Cumplido_A_Tiempo        AS RespuestaCumplida,
    reso.Cumplido_A_Tiempo        AS ResolucionCumplida,
    reso.Incumplido               AS ResolucionIncumplida,
    ISNULL(reso.Minutos_Pausados_Habiles, 0) AS MinPausadosResolucion
FROM Tickets t
LEFT JOIN Estado est            ON est.Id = t.Id_Estado
LEFT JOIN Tipo_Requerimiento tr ON tr.Id = t.Id_Tipo_Req
LEFT JOIN Prioridad pr          ON pr.Id = t.Id_Prioridad
LEFT JOIN Area a                ON a.Id = t.Id_Area
LEFT JOIN Departamento d        ON d.Id = a.Id_Departamento
LEFT JOIN Sociedad soc          ON soc.Id = t.Id_Sociedad
LEFT JOIN Usuarios ua           ON ua.Id = t.Id_Usuario_Asignado
OUTER APPLY (
    SELECT TOP 1 ts.Fecha_Fin, ts.Minutos_Objetivo, ts.Cumplido_A_Tiempo, def.Id_Calendario
    FROM Ticket_SLA ts INNER JOIN SLA_Definicion def ON def.Id = ts.Id_SLA_Definicion
    WHERE ts.Id_Ticket = t.Id AND def.Tipo_SLA = 'Respuesta' AND ts.Etapa <> 'Cancelado'
    ORDER BY ts.Fecha_Inicio DESC
) resp
OUTER APPLY (
    SELECT TOP 1 ts.Fecha_Fin, ts.Minutos_Objetivo, ts.Minutos_Pausados_Habiles, ts.Cumplido_A_Tiempo, ts.Incumplido, def.Id_Calendario
    FROM Ticket_SLA ts INNER JOIN SLA_Definicion def ON def.Id = ts.Id_SLA_Definicion
    WHERE ts.Id_Ticket = t.Id AND def.Tipo_SLA = 'Resolucion' AND ts.Etapa <> 'Cancelado'
    ORDER BY ts.Fecha_Inicio DESC
) reso
OUTER APPLY (
    SELECT MinTrabajoAsesor_Habil =
        CASE WHEN reso.Fecha_Fin IS NULL OR resp.Fecha_Fin IS NULL THEN NULL
             ELSE dbo.fn_MinutosHabilesEntre(resp.Fecha_Fin, reso.Fecha_Fin, reso.Id_Calendario) END
) calc;
GO

-- Comprobación rápida
SELECT CodigoTicket, EstadoActual, FechaCreacion, FechaToma, FechaResolucion,
       MinCola_Habil, MinTrabajoAsesor_Habil, MinResolucionTotal_Habil,
       MinCola_Reloj, MinTrabajoAsesor_Reloj, MinResolucionTotal_Reloj
FROM vw_TiemposTicket
ORDER BY IdTicket;
GO
