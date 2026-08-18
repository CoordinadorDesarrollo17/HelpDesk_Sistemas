-- ============================================================
-- Motor de SLA — 05: Stored procedures
--
-- Se enganchan a los puntos de entrada que YA existen en
-- Repositories/TicketsRepository.cs (dentro de los helpers CambiarEstado/
-- TomarGenerico y en CrearTicket/AsignarPrioridad/PausarTicket/
-- ReanudarTicket/DevolverTicket), así que no cambian el flujo visible
-- de tickets ni agregan estados nuevos.
--
-- Estados "fin" por Tipo_SLA (ver Estado.Nombre en la base):
--   Respuesta:  'En revisión' (Consulta/Soporte tomado) | 'Levantamiento' (Impl/Mejora tomado)
--   Resolucion: 'En validación' (solución registrada)   | 'Pase a producción' (pruebas confirmadas)
--   'Anulado' cancela cualquier SLA abierto, sin importar el tipo.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Busca, para 'Respuesta' y 'Resolucion', la definición activa más específica
-- que matchea el ticket (tipo/categoría/prioridad/sociedad) y abre su Ticket_SLA.
-- Requiere que el ticket ya tenga Id_Prioridad asignado (si no, no hace nada:
-- caso Implementación/Mejora antes de AsignarPrioridad).
CREATE PROCEDURE sp_SLA_IniciarParaTicket
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
        IF NOT EXISTS (
            SELECT 1 FROM Ticket_SLA ts
            INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
            WHERE ts.Id_Ticket = @IdTicket AND d.Tipo_SLA = @TipoActual
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

-- Cierra el/los Ticket_SLA abiertos que correspondan al estado destino
-- recién alcanzado (ver mapeo de estados "fin" arriba).
CREATE PROCEDURE sp_SLA_DetenerPorEstado
    @IdTicket INT,
    @EstadoDestino VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Ahora DATETIME = GETDATE();

    IF @EstadoDestino = 'Anulado'
    BEGIN
        UPDATE Ticket_SLA
        SET Etapa = 'Cancelado', Fecha_Modificacion = @Ahora
        WHERE Id_Ticket = @IdTicket AND Etapa IN ('EnCurso', 'Pausado');
        RETURN;
    END

    DECLARE @TipoSlaAFinalizar VARCHAR(20) = CASE
        WHEN @EstadoDestino IN ('En revisión', 'Levantamiento') THEN 'Respuesta'
        WHEN @EstadoDestino IN ('En validación', 'Pase a producción') THEN 'Resolucion'
        ELSE NULL
    END;

    IF @TipoSlaAFinalizar IS NULL RETURN;

    UPDATE ts
    SET Fecha_Fin = @Ahora,
        Etapa = 'Completado',
        Cumplido_A_Tiempo = CASE WHEN @Ahora <= ts.Fecha_Objetivo THEN 1 ELSE 0 END,
        Incumplido = CASE WHEN @Ahora > ts.Fecha_Objetivo THEN 1 ELSE ts.Incumplido END,
        Fecha_Incumplimiento = CASE WHEN @Ahora > ts.Fecha_Objetivo AND ts.Fecha_Incumplimiento IS NULL THEN @Ahora ELSE ts.Fecha_Incumplimiento END,
        Fecha_Modificacion = @Ahora
    FROM Ticket_SLA ts
    INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
    WHERE ts.Id_Ticket = @IdTicket
      AND d.Tipo_SLA = @TipoSlaAFinalizar
      AND ts.Etapa IN ('EnCurso', 'Pausado');
END
GO

-- Pausa el reloj de los SLA en curso del ticket (llamado desde PausarTicket).
CREATE PROCEDURE sp_SLA_Pausar
    @IdTicket INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Ticket_SLA
    SET Etapa = 'Pausado', Fecha_Modificacion = GETDATE()
    WHERE Id_Ticket = @IdTicket AND Etapa = 'EnCurso';
END
GO

-- Reanuda los SLA pausados del ticket (llamado desde ReanudarTicket, después
-- de que Ticket_Pausas ya cerró la pausa con Fecha_Fin = GETDATE()). Suma los
-- minutos hábiles de la pausa recién cerrada y recalcula Fecha_Objetivo.
CREATE PROCEDURE sp_SLA_Reanudar
    @IdTicket INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FechaInicioPausa DATETIME, @FechaFinPausa DATETIME;

    SELECT TOP 1 @FechaInicioPausa = Fecha_Inicio, @FechaFinPausa = Fecha_Fin
    FROM Ticket_Pausas
    WHERE Id_Ticket = @IdTicket AND Fecha_Fin IS NOT NULL
    ORDER BY Fecha_Fin DESC;

    IF @FechaFinPausa IS NULL RETURN;

    DECLARE @Pendientes TABLE (Id INT, Id_Calendario INT, Minutos_Objetivo INT, Minutos_Pausados_Habiles INT, Fecha_Inicio DATETIME);

    INSERT INTO @Pendientes (Id, Id_Calendario, Minutos_Objetivo, Minutos_Pausados_Habiles, Fecha_Inicio)
    SELECT ts.Id, d.Id_Calendario, ts.Minutos_Objetivo, ts.Minutos_Pausados_Habiles, ts.Fecha_Inicio
    FROM Ticket_SLA ts
    INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
    WHERE ts.Id_Ticket = @IdTicket AND ts.Etapa = 'Pausado';

    DECLARE @IdActual INT, @CalActual INT, @ObjActual INT, @PrevPausados INT, @InicioActual DATETIME,
            @MinutosPausaNueva INT, @NuevosPausados INT, @NuevoObjetivo DATETIME;

    WHILE EXISTS (SELECT 1 FROM @Pendientes)
    BEGIN
        SELECT TOP 1 @IdActual = Id, @CalActual = Id_Calendario, @ObjActual = Minutos_Objetivo,
               @PrevPausados = Minutos_Pausados_Habiles, @InicioActual = Fecha_Inicio
        FROM @Pendientes;

        SET @MinutosPausaNueva = dbo.fn_MinutosHabilesEntre(@FechaInicioPausa, @FechaFinPausa, @CalActual);
        SET @NuevosPausados = @PrevPausados + @MinutosPausaNueva;
        SET @NuevoObjetivo = dbo.fn_SumarMinutosHabiles(@InicioActual, @ObjActual + @NuevosPausados, @CalActual);

        UPDATE Ticket_SLA
        SET Etapa = 'EnCurso',
            Minutos_Pausados_Habiles = @NuevosPausados,
            Fecha_Objetivo = ISNULL(@NuevoObjetivo, Fecha_Objetivo),
            Fecha_Modificacion = GETDATE()
        WHERE Id = @IdActual;

        DELETE FROM @Pendientes WHERE Id = @IdActual;
    END
END
GO

-- Reactiva el SLA de Resolución si su definición es Reactivable (llamado
-- desde DevolverTicket: En validación -> En atención). El tiempo que el
-- ticket estuvo "resuelto" (entre el cierre anterior y ahora) se descuenta
-- del reloj igual que una pausa. Si la definición no es reactivable, no
-- hace nada y se conserva el cierre/incumplimiento ya registrado.
CREATE PROCEDURE sp_SLA_Reactivar
    @IdTicket INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Ahora DATETIME = GETDATE();
    DECLARE @IdTicketSla INT, @IdCalendario INT, @FechaFinAnterior DATETIME,
            @MinutosObjetivo INT, @MinutosPausadosPrevios INT, @FechaInicioSla DATETIME;

    SELECT TOP 1
        @IdTicketSla = ts.Id, @IdCalendario = d.Id_Calendario, @FechaFinAnterior = ts.Fecha_Fin,
        @MinutosObjetivo = ts.Minutos_Objetivo, @MinutosPausadosPrevios = ts.Minutos_Pausados_Habiles,
        @FechaInicioSla = ts.Fecha_Inicio
    FROM Ticket_SLA ts
    INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
    WHERE ts.Id_Ticket = @IdTicket
      AND d.Tipo_SLA = 'Resolucion'
      AND d.Reactivable = 1
      AND ts.Etapa = 'Completado'
    ORDER BY ts.Fecha_Fin DESC;

    IF @IdTicketSla IS NULL RETURN;

    DECLARE @MinutosCerrado INT = dbo.fn_MinutosHabilesEntre(@FechaFinAnterior, @Ahora, @IdCalendario);
    DECLARE @NuevosPausados INT = @MinutosPausadosPrevios + @MinutosCerrado;
    DECLARE @NuevoObjetivo DATETIME = dbo.fn_SumarMinutosHabiles(@FechaInicioSla, @MinutosObjetivo + @NuevosPausados, @IdCalendario);

    UPDATE Ticket_SLA
    SET Etapa = 'EnCurso',
        Fecha_Fin = NULL,
        Cumplido_A_Tiempo = NULL,
        Minutos_Pausados_Habiles = @NuevosPausados,
        Fecha_Objetivo = ISNULL(@NuevoObjetivo, Fecha_Objetivo),
        Fecha_Modificacion = @Ahora
    WHERE Id = @IdTicketSla;
END
GO

-- Motor periódico: para cada Ticket_SLA en curso, marca advertencia (umbral
-- Porcentaje_Advertencia) e incumplimiento (100%) según el tiempo real
-- transcurrido. No cambia Etapa (eso lo hace sp_SLA_DetenerPorEstado); solo
-- deja las banderas listas para reportes y para una futura notificación.
-- Se ejecuta cada ~2 min desde Services/SlaEngineBackgroundService.cs.
CREATE PROCEDURE sp_SLA_ActualizarEstados
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Ahora DATETIME = GETDATE();

    DECLARE @Pendientes TABLE (
        Id INT, Id_Calendario INT, Fecha_Inicio DATETIME, Minutos_Objetivo INT,
        Minutos_Pausados_Habiles INT, Porcentaje_Advertencia TINYINT, Fecha_Objetivo DATETIME
    );

    INSERT INTO @Pendientes (Id, Id_Calendario, Fecha_Inicio, Minutos_Objetivo, Minutos_Pausados_Habiles, Porcentaje_Advertencia, Fecha_Objetivo)
    SELECT ts.Id, d.Id_Calendario, ts.Fecha_Inicio, ts.Minutos_Objetivo, ts.Minutos_Pausados_Habiles, d.Porcentaje_Advertencia, ts.Fecha_Objetivo
    FROM Ticket_SLA ts
    INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
    WHERE ts.Etapa = 'EnCurso' AND (ts.Advertencia_Activa = 0 OR ts.Incumplido = 0);

    DECLARE @IdActual INT, @CalActual INT, @InicioActual DATETIME, @ObjActual INT, @PausadosActual INT,
            @PorcActual TINYINT, @ObjetivoActual DATETIME, @UmbralAdvertencia DATETIME;

    WHILE EXISTS (SELECT 1 FROM @Pendientes)
    BEGIN
        SELECT TOP 1 @IdActual = Id, @CalActual = Id_Calendario, @InicioActual = Fecha_Inicio, @ObjActual = Minutos_Objetivo,
               @PausadosActual = Minutos_Pausados_Habiles, @PorcActual = Porcentaje_Advertencia, @ObjetivoActual = Fecha_Objetivo
        FROM @Pendientes;

        SET @UmbralAdvertencia = dbo.fn_SumarMinutosHabiles(@InicioActual, (@ObjActual * @PorcActual) / 100 + @PausadosActual, @CalActual);

        UPDATE Ticket_SLA
        SET Advertencia_Activa = CASE WHEN @Ahora >= @UmbralAdvertencia THEN 1 ELSE Advertencia_Activa END,
            Fecha_Advertencia = CASE WHEN @Ahora >= @UmbralAdvertencia AND Fecha_Advertencia IS NULL THEN @Ahora ELSE Fecha_Advertencia END,
            Incumplido = CASE WHEN @Ahora >= @ObjetivoActual THEN 1 ELSE Incumplido END,
            Fecha_Incumplimiento = CASE WHEN @Ahora >= @ObjetivoActual AND Fecha_Incumplimiento IS NULL THEN @Ahora ELSE Fecha_Incumplimiento END,
            Fecha_Modificacion = @Ahora
        WHERE Id = @IdActual;

        DELETE FROM @Pendientes WHERE Id = @IdActual;
    END
END
GO
