-- ============================================================
-- Motor de SLA — 13: Refrigerio al medio del horario (Lunes a Viernes)
-- Parte cada franja de Lunes a Viernes en dos (mañana / tarde), dejando
-- 1 hora de refrigerio centrada exactamente en el punto medio del rango
-- (ej. 09:00-18:00 -> refrigerio 13:00-14:00). Sábado no tiene refrigerio,
-- se deja igual.
-- Idempotente: si una franja ya dura <= 5 horas (ya fue partida antes o
-- es muy corta para tener refrigerio), se ignora.
-- Ejecutar contra HELPDESK_V1.
-- ============================================================

SET NOCOUNT ON;

BEGIN TRAN;

DECLARE @Franjas TABLE (
    Id            INT,
    Id_Calendario INT,
    Dia_Semana    TINYINT,
    Hora_Inicio   TIME(0),
    Hora_Fin      TIME(0)
);

INSERT INTO @Franjas (Id, Id_Calendario, Dia_Semana, Hora_Inicio, Hora_Fin)
SELECT Id, Id_Calendario, Dia_Semana, Hora_Inicio, Hora_Fin
FROM Calendario_Horario
WHERE Dia_Semana BETWEEN 2 AND 6   -- Lunes(2) a Viernes(6)
  AND Activo = 1
  AND DATEDIFF(MINUTE, CAST(Hora_Inicio AS DATETIME), CAST(Hora_Fin AS DATETIME)) > 300; -- > 5h, para no partir franjas ya cortas/partidas

DECLARE @Id INT, @IdCal INT, @Dia TINYINT, @Inicio TIME(0), @Fin TIME(0);
DECLARE @Medio DATETIME, @RefIni TIME(0), @RefFin TIME(0);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT Id, Id_Calendario, Dia_Semana, Hora_Inicio, Hora_Fin FROM @Franjas;

OPEN cur;
FETCH NEXT FROM cur INTO @Id, @IdCal, @Dia, @Inicio, @Fin;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Medio  = DATEADD(MINUTE, DATEDIFF(MINUTE, CAST(@Inicio AS DATETIME), CAST(@Fin AS DATETIME)) / 2, CAST(@Inicio AS DATETIME));
    SET @RefIni = CAST(DATEADD(MINUTE, -30, @Medio) AS TIME(0));
    SET @RefFin = CAST(DATEADD(MINUTE,  30, @Medio) AS TIME(0));

    -- La franja original se recorta para terminar donde empieza el refrigerio (mañana)
    UPDATE Calendario_Horario
    SET Hora_Fin = @RefIni
    WHERE Id = @Id;

    -- Se agrega la franja de la tarde, desde que termina el refrigerio
    INSERT INTO Calendario_Horario (Id_Calendario, Dia_Semana, Hora_Inicio, Hora_Fin, Activo)
    VALUES (@IdCal, @Dia, @RefFin, @Fin, 1);

    FETCH NEXT FROM cur INTO @Id, @IdCal, @Dia, @Inicio, @Fin;
END

CLOSE cur;
DEALLOCATE cur;

COMMIT;

SELECT Id_Calendario, Dia_Semana, CONVERT(VARCHAR, Hora_Inicio, 108) AS Hora_Inicio, CONVERT(VARCHAR, Hora_Fin, 108) AS Hora_Fin
FROM Calendario_Horario
WHERE Activo = 1
ORDER BY Id_Calendario, Dia_Semana, Hora_Inicio;
