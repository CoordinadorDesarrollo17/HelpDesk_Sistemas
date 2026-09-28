-- Enlaza cada usuario del HelpDesk con su identidad en la intranet (DocEntry, siempre
-- único y estable), para poder validar credenciales contra la API de la intranet en
-- lugar de la contraseña local. Nullable a propósito: mientras se migra, los usuarios
-- sin enlazar siguen entrando con su Usuario/Password local (ver UsuariosService).
ALTER TABLE Usuarios ADD Id_Intranet INT NULL;
GO

-- Único cuando está definido (mismo patrón que UQ_Usuarios_Correo en 03_CorreoUniqueFiltrado.sql):
-- evita enlazar dos usuarios del HelpDesk con la misma persona de la intranet, pero
-- permite que muchos usuarios todavía no migrados queden en NULL a la vez.
-- Los índices filtrados exigen QUOTED_IDENTIFIER ON en la sesión que los crea.
SET QUOTED_IDENTIFIER ON;
GO
CREATE UNIQUE INDEX UQ_Usuarios_IdIntranet ON Usuarios(Id_Intranet) WHERE Id_Intranet IS NOT NULL;
GO
