-- ============================================================
-- Motor de SLA — 04: Funciones de calendario laboral
--
-- Convención de Dia_Semana (independiente de la config. SET DATEFIRST de
-- la sesión): 1=Domingo, 2=Lunes, 3=Martes, 4=Miércoles, 5=Jueves,
-- 6=Viernes, 7=Sábado. Se calcula con ((DATEDIFF(DAY,0,@Fecha)+1) % 7) + 1
-- porque el día 0 de SQL Server (1900-01-01) fue lunes.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Minutos hábiles entre dos fechas/horas, según el calendario indicado
-- (excluye fuera de horario y feriados). Recorre día a día; se acota a
-- ~3 años (1100 días) como salvaguarda, suficiente para cualquier SLA real.
CREATE FUNCTION fn_MinutosHabilesEntre
(
    @Inicio         DATETIME,
    @Fin            DATETIME,
    @IdCalendario   INT
)
RETURNS INT
AS
BEGIN
    IF @Fin IS NULL OR @Inicio IS NULL OR @Fin <= @Inicio
        RETURN 0;

    DECLARE @TotalMinutos INT = 0;
    DECLARE @DiaActual DATE = CAST(@Inicio AS DATE);
    DECLARE @DiaFin DATE = CAST(@Fin AS DATE);
    DECLARE @Contador INT = 0;

    WHILE @DiaActual <= @DiaFin AND @Contador < 1100
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM Calendario_Feriado
            WHERE Id_Calendario = @IdCalendario AND Fecha = @DiaActual
        )
        BEGIN
            SELECT @TotalMinutos = @TotalMinutos + ISNULL(SUM(
                DATEDIFF(MINUTE,
                    CASE WHEN CAST(@DiaActual AS DATETIME) + CAST(h.Hora_Inicio AS DATETIME) < @Inicio
                         THEN @Inicio
                         ELSE CAST(@DiaActual AS DATETIME) + CAST(h.Hora_Inicio AS DATETIME) END,
                    CASE WHEN CAST(@DiaActual AS DATETIME) + CAST(h.Hora_Fin AS DATETIME) > @Fin
                         THEN @Fin
                         ELSE CAST(@DiaActual AS DATETIME) + CAST(h.Hora_Fin AS DATETIME) END
                )
            ), 0)
            FROM Calendario_Horario h
            WHERE h.Id_Calendario = @IdCalendario
              AND h.Activo = 1
              AND h.Dia_Semana = ((DATEDIFF(DAY, 0, @DiaActual) + 1) % 7) + 1
              AND CAST(@DiaActual AS DATETIME) + CAST(h.Hora_Inicio AS DATETIME) < @Fin
              AND CAST(@DiaActual AS DATETIME) + CAST(h.Hora_Fin AS DATETIME) > @Inicio;
        END

        SET @DiaActual = DATEADD(DAY, 1, @DiaActual);
        SET @Contador = @Contador + 1;
    END

    RETURN @TotalMinutos;
END
GO

-- Avanza @Minutos hábiles desde @Inicio según el calendario indicado y
-- devuelve la fecha/hora resultante (usado para calcular Fecha_Objetivo).
-- Devuelve NULL si el calendario no tiene ningún horario configurado
-- dentro del rango de seguridad (~3 años) — el llamador debe validarlo.
CREATE FUNCTION fn_SumarMinutosHabiles
(
    @Inicio         DATETIME,
    @Minutos        INT,
    @IdCalendario   INT
)
RETURNS DATETIME
AS
BEGIN
    IF @Minutos <= 0 RETURN @Inicio;

    DECLARE @Restantes INT = @Minutos;
    DECLARE @DiaActual DATE = CAST(@Inicio AS DATE);
    DECLARE @Cursor DATETIME = @Inicio;
    DECLARE @Contador INT = 0;
    DECLARE @Resultado DATETIME = NULL;

    WHILE @Resultado IS NULL AND @Contador < 1100
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM Calendario_Feriado
            WHERE Id_Calendario = @IdCalendario AND Fecha = @DiaActual
        )
        BEGIN
            DECLARE @Ventanas TABLE (VentanaInicio DATETIME, VentanaFin DATETIME);

            INSERT INTO @Ventanas (VentanaInicio, VentanaFin)
            SELECT CAST(@DiaActual AS DATETIME) + CAST(Hora_Inicio AS DATETIME),
                   CAST(@DiaActual AS DATETIME) + CAST(Hora_Fin AS DATETIME)
            FROM Calendario_Horario
            WHERE Id_Calendario = @IdCalendario
              AND Activo = 1
              AND Dia_Semana = ((DATEDIFF(DAY, 0, @DiaActual) + 1) % 7) + 1;

            DECLARE @VentanaInicio DATETIME, @VentanaFin DATETIME, @EfectivoInicio DATETIME, @MinutosVentana INT;

            WHILE EXISTS (SELECT 1 FROM @Ventanas) AND @Resultado IS NULL
            BEGIN
                SELECT TOP 1 @VentanaInicio = VentanaInicio, @VentanaFin = VentanaFin
                FROM @Ventanas ORDER BY VentanaInicio;

                SET @EfectivoInicio = CASE WHEN @VentanaInicio < @Cursor THEN @Cursor ELSE @VentanaInicio END;

                IF @EfectivoInicio < @VentanaFin
                BEGIN
                    SET @MinutosVentana = DATEDIFF(MINUTE, @EfectivoInicio, @VentanaFin);

                    IF @Restantes <= @MinutosVentana
                        SET @Resultado = DATEADD(MINUTE, @Restantes, @EfectivoInicio);
                    ELSE
                        SET @Restantes = @Restantes - @MinutosVentana;
                END

                DELETE FROM @Ventanas WHERE VentanaInicio = @VentanaInicio AND VentanaFin = @VentanaFin;
            END
        END

        IF @Resultado IS NULL
        BEGIN
            SET @DiaActual = DATEADD(DAY, 1, @DiaActual);
            SET @Cursor = CAST(@DiaActual AS DATETIME);
            SET @Contador = @Contador + 1;
        END
    END

    RETURN @Resultado;
END
GO
