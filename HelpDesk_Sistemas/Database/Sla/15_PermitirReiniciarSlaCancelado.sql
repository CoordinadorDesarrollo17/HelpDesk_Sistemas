-- ============================================================
-- Motor de SLA -- 15: sp_SLA_IniciarParaTicket ignora las filas Canceladas
-- al revisar si ya existe un SLA de ese tipo para el ticket.
--
-- Hasta ahora el guard de duplicados miraba CUALQUIER fila de Ticket_SLA,
-- sin importar su Etapa. Eso estaba bien mientras el proc solo se llamaba
-- una vez por ticket/tipo (creación, o AsignarPrioridad la primera vez).
-- Con TicketsRepository.CorregirImpacto (cancela el SLA abierto y vuelve a
-- llamar a este proc para reabrirlo con la definición correcta cuando el
-- impacto corregido cambia la prioridad), el guard bloqueaba la reapertura
-- porque la fila Cancelada seguía "existiendo". Una fila Cancelada es un
-- SLA anulado -- no debe contar como "ya iniciado".
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE sp_SLA_IniciarParaTicket
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

    WHILE EXISTS (SELECT 1 FROM @Tipos)
    BEGIN
        SELECT TOP 1 @TipoActual = Tipo_SLA FROM @Tipos;
        SET @IdDefinicion = NULL;

        -- Evita duplicar si el motor se llama más de una vez para el mismo ticket/tipo.
        -- Una fila Cancelada no cuenta como "ya iniciado" (ver CorregirImpacto).
        IF NOT EXISTS (
            SELECT 1 FROM Ticket_SLA ts
            INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
            WHERE ts.Id_Ticket = @IdTicket AND d.Tipo_SLA = @TipoActual AND ts.Etapa <> 'Cancelado'
        )
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
                SET @FechaObjetivo = dbo.fn_SumarMinutosHabiles(@Ahora, @DuracionMinutos, @IdCalendario);

                IF @FechaObjetivo IS NULL
                    THROW 50001, 'El calendario laboral de la definición de SLA no tiene horarios configurados.', 1;

                INSERT INTO Ticket_SLA (Id_Ticket, Id_SLA_Definicion, Fecha_Inicio, Fecha_Objetivo, Minutos_Objetivo)
                VALUES (@IdTicket, @IdDefinicion, @Ahora, @FechaObjetivo, @DuracionMinutos);
            END
        END

        DELETE FROM @Tipos WHERE Tipo_SLA = @TipoActual;
    END
END
GO
