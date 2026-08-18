-- El UNIQUE CONSTRAINT original sobre Correo bloqueaba crear más de un usuario
-- sin correo (SQL Server solo permite un NULL por columna UNIQUE). Se reemplaza
-- por un índice único filtrado que solo aplica cuando el correo sí está definido.
SET QUOTED_IDENTIFIER ON;
GO
ALTER TABLE Usuarios DROP CONSTRAINT UQ__Usuarios__60695A193F3C8885;
GO
CREATE UNIQUE INDEX UQ_Usuarios_Correo ON Usuarios(Correo) WHERE Correo IS NOT NULL;
GO
