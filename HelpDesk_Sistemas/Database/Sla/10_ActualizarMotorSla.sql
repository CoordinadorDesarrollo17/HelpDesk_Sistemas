-- ============================================================
-- Motor de SLA — 10: sp_SLA_IniciarParaTicket ahora resincroniza al
-- reasignar prioridad.
--
-- Motivo: con la matriz de prioridad, TicketsRepository.AsignarPrioridad ya
-- no bloquea la corrección manual de prioridad en un ticket Pendiente (antes
-- solo se podía corregir si no estaba "forzada" por Afecta_Funcionamiento).
-- Sin este cambio, si Soporte corrige la prioridad DESPUÉS de creado el
-- ticket, el SLA ya abierto se quedaba con los tiempos de la prioridad vieja
-- (el motor solo creaba el SLA si no existía ninguno, nunca lo actualizaba).
--
-- Ahora: si el Ticket_SLA de ese Tipo_SLA ya existe pero sigue 'EnCurso'
-- (todavía no se tomó/pausó/cerró), se reevalúa la definición que le
-- corresponde y se actualiza en el mismo lugar. Si ya está Pausado,
-- Completado o Cancelado, se deja intacto (es historial real, no se toca).
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE sp_SLA_IniciarParaTicket
    @IdTicket INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdTipoReq INT, @IdCategoria INT, @IdPrioridad INT, @IdSociedad INT;

    SELECT @IdTipoReq = Id_Tipo_Req, @IdCategoria = Id_Categoria, @IdPrioridad = Id_Prioridad, @IdSociedad = Id_Sociedad
    FROM Tickets WHERE Id = @IdTicket;

    IF @IdPrioridad IS NULL RETURN;

    DECLARE @Ahora DATETIME = GETDATE();

    DECLARE @Tipos TABLE (Tipo_SLA VARCHAR(20));
    INSERT INTO @Tipos VALUES ('Respuesta'), ('Resolucion');

    DECLARE @TipoActual VARCHAR(20), @IdDefinicion INT, @IdCalendario INT, @DuracionMinutos INT, @FechaObjetivo DATETIME;
    DECLARE @IdTicketSlaExistente INT, @EtapaExistente VARCHAR(20), @FechaInicioExistente DATETIME;

    WHILE EXISTS (SELECT 1 FROM @Tipos)
    BEGIN
        SELECT TOP 1 @TipoActual = Tipo_SLA FROM @Tipos;
        SET @IdDefinicion = NULL;
        SET @IdTicketSlaExistente = NULL;

        SELECT TOP 1 @IdTicketSlaExistente = ts.Id, @EtapaExistente = ts.Etapa, @FechaInicioExistente = ts.Fecha_Inicio
        FROM Ticket_SLA ts
        INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
        WHERE ts.Id_Ticket = @IdTicket AND d.Tipo_SLA = @TipoActual;

        -- Solo actúa si no existe todavía, o si existe pero sigue EnCurso
        -- (Pausado/Completado/Cancelado son historial real, no se tocan).
        IF @IdTicketSlaExistente IS NULL OR @EtapaExistente = 'EnCurso'
        BEGIN
            SELECT TOP 1 @IdDefinicion = Id, @IdCalendario = Id_Calendario, @DuracionMinutos = Duracion_Minutos
            FROM SLA_Definicion
            WHERE Tipo_SLA = @TipoActual
              AND Activo = 1
              AND (Id_Tipo_Req  IS NULL OR Id_Tipo_Req  = @IdTipoReq)
              AND (Id_Categoria IS NULL OR Id_Categoria = @IdCategoria)
              AND (Id_Prioridad IS NULL OR Id_Prioridad = @IdPrioridad)
              AND (Id_Sociedad  IS NULL OR Id_Sociedad  = @IdSociedad)
            ORDER BY Especificidad DESC, Id;

            IF @IdDefinicion IS NOT NULL
            BEGIN
                SET @FechaObjetivo = dbo.fn_SumarMinutosHabiles(
                    CASE WHEN @IdTicketSlaExistente IS NULL THEN @Ahora ELSE @FechaInicioExistente END,
                    @DuracionMinutos, @IdCalendario
                );

                IF @FechaObjetivo IS NULL
                    THROW 50001, 'El calendario laboral de la definición de SLA no tiene horarios configurados.', 1;

                IF @IdTicketSlaExistente IS NULL
                BEGIN
                    INSERT INTO Ticket_SLA (Id_Ticket, Id_SLA_Definicion, Fecha_Inicio, Fecha_Objetivo, Minutos_Objetivo)
                    VALUES (@IdTicket, @IdDefinicion, @Ahora, @FechaObjetivo, @DuracionMinutos);
                END
                ELSE
                BEGIN
                    UPDATE Ticket_SLA
                    SET Id_SLA_Definicion = @IdDefinicion,
                        Fecha_Objetivo = @FechaObjetivo,
                        Minutos_Objetivo = @DuracionMinutos,
                        Fecha_Modificacion = @Ahora
                    WHERE Id = @IdTicketSlaExistente;
                END
            END
        END

        DELETE FROM @Tipos WHERE Tipo_SLA = @TipoActual;
    END
END
GO
