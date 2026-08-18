-- ============================================================
-- Usuarios — 01: Numeración secuencial por rol + regenera el
-- Usuario de los usuarios semilla con la convención real de Cobefar:
--   Usuario    = rol en minúsculas + secuencial por rol (soporte1, soporte2...)
--   Contraseña = 3 letras Nombre + 3 letras Apellido + mismo secuencial
-- La contraseña NO se toca aquí (T-SQL no tiene PBKDF2 nativo) — se
-- recalcula y hashea desde la app y se aplica con un UPDATE aparte
-- (ver README/paso de migración).
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

ALTER TABLE Usuarios ADD Numero_Secuencial INT NULL;
GO

;WITH Numerados AS (
    SELECT Id, ROW_NUMBER() OVER (PARTITION BY IdRol ORDER BY Id) AS Numero
    FROM Usuarios
)
UPDATE u
SET u.Numero_Secuencial = n.Numero
FROM Usuarios u
INNER JOIN Numerados n ON n.Id = u.Id;
GO

ALTER TABLE Usuarios ALTER COLUMN Numero_Secuencial INT NOT NULL;
GO

UPDATE u
SET u.Usuario = LOWER(r.Nombre) + CAST(u.Numero_Secuencial AS VARCHAR(10))
FROM Usuarios u
INNER JOIN Rol r ON r.Id = u.IdRol;
GO
