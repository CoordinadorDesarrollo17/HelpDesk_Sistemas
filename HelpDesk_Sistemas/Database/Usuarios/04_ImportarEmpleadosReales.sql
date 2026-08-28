-- ============================================================
-- Usuarios — 04: Importa empleados reales desde intranet normal + adquisiciones
--
-- Generado automáticamente cruzando EmpleadoID (intranet normal) con
-- IdOEMPL (intranet adquisiciones) para obtener el Departamento/Área real
-- de cada persona. Se excluyeron: los 6 usuarios de Soporte/Administrador
-- ya creados, empleados con FechaCese o Activo=0, duplicados (se usó la
-- fila con FechaRegistro más reciente por persona), y quienes no tuvieran
-- un Área válida en HelpDesk (ver lista aparte "sin_area_valida.csv").
--
-- Todos entran con Rol = Usuario y Sociedad = Cobefar (no había ese dato
-- en los extractos); ambos se pueden corregir después caso por caso desde
-- la pantalla de Usuarios.
--
-- Las contraseñas del sistema origen NO se reutilizan (hash incompatible):
-- se generaron credenciales nuevas con la convención de
-- Common/GeneradorCredenciales.cs. Ver "credenciales_generadas.csv" para
-- la lista de Usuario/Password en texto plano a entregar a cada persona.
--
-- Idempotente: cada INSERT valida que el Usuario no exista todavía.
-- Ejecutar con: sqlcmd -S <server> -d HELPDESK_V1 -f 65001 -i 04_ImportarEmpleadosReales.sql
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- Jehimy Lizeth Risco Rojas — AREA ADMINISTRATIVA (DEP. ADMINISTRATIVO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 91, 0, 'Jehimy Lizeth', 'Risco Rojas', NULL, NULL, NULL, 'admin1', '100000.uvrbgR8BSGwnOkVjxFEtAA==.STPybUV3b6ptgBqihB/YDla2WloMtjzJniGEA7CcSHA=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Alberto Terrones Lozano — AREA ADMINISTRATIVA (DEP. ADMINISTRATIVO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 91, 0, 'Luis Alberto', 'Terrones Lozano', NULL, NULL, NULL, 'admin2', '100000.p6duS4XRHkZ/yZz7QJY7Ig==.WIINsSZSiVxIMMrZn7B7+Oy2jUOZl8ltNhDt9OqBPAs=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Melissa Elizabeth Huarcaya Figueroa — AREA ADMINISTRATIVA (DEP. ADMINISTRATIVO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 91, 0, 'Melissa Elizabeth', 'Huarcaya Figueroa', NULL, NULL, NULL, 'admin3', '100000.pl9BDjejRA30rwlmt1FN0Q==.D91G1gCo5EWuL6h1USwONLWV683Ddfakn3ZYzfEZM9s=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sindy Lisbeth Diaz Bazan — AREA ADMINISTRATIVA (DEP. ADMINISTRATIVO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 91, 0, 'Sindy Lisbeth', 'Diaz Bazan', 'sindy.diaz@cobefar.com.pe', NULL, NULL, 'admin4', '100000.iErIuxvZ/jGPWRHntrDFMg==.yU8b+clT9mkkTZPuH2KXTvs7S3uUQGo4KNiDNIhCKNE=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Betsy Yessica Untiveros Crispin — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Betsy Yessica', 'Untiveros Crispin', NULL, NULL, NULL, 'comercial1', '100000.d5GIfqkMUA4xvs9mu6oU4A==.6P3fKdKxASKbClz3erV4ylz8syetj5xs+WgZJmakO88=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Camila Ventura Huarcaylata — AREA COMERCIAL (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 62, 0, 'Camila', 'Ventura Huarcaylata', NULL, NULL, NULL, 'comercial2', '100000.1jLMclEcglIDZ+ypSSGb5w==.LOMUJ2rN+iGI1hsdIOa/FqoVrU0AI2qhS5JOmetXeYE=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Eduardo Billy Alejandro Sotomayor — AREA SUB-GERENCIA Y ANALISIS (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 57, 0, 'Eduardo Billy', 'Alejandro Sotomayor', NULL, NULL, NULL, 'comercial3', '100000.SUrrQNbRLKqKhI2BhxBEXw==.lX1/ZvkTeTIYJShtUVw2Pf/XxHOGCP4x8ytxBO61h2o=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Fiorella Zacarias Ramon — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Fiorella', 'Zacarias Ramon', NULL, NULL, NULL, 'comercial4', '100000.5Hty5lLFCyKtMhiBbnpPrg==.5Ol0FyXPmFbOpJRkuV+OeYY9GnxsfgZRbkq8dGyjv4Q=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gissela Arevalo Aching — AREA DE VENTAS ESTRATEG. (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 58, 0, 'Gissela', 'Arevalo Aching', NULL, NULL, NULL, 'comercial5', '100000.71DOSNYrYdF8YEm84fkfGQ==.CY3A+f+GSvk9KehTDwHbshcOcKK3Mzdy53vYTyw6Qts=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jackelin Tomasa Roman Tello — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Jackelin Tomasa', 'Roman Tello', NULL, NULL, NULL, 'comercial6', '100000.2i6/8/z03UJWSsgjMGsOsQ==.n/3pUtYhx+9tgU8Eb+sf2GWK7rxK9e4i/nrDLsEH9qo=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jean Paul Ramirez Rodriguez — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Jean Paul', 'Ramirez Rodriguez', NULL, NULL, NULL, 'comercial7', '100000.FWeCd3BnmR/Yeh6CJ699ig==.OHBac5TNKLXsq1ZymP4VS4l39VzZeCrxWwGUz9Rgka0=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jennyfer Lucero Carrascal Lozada — AREA DE VENTAS HORIZONTAL (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Jennyfer Lucero', 'Carrascal Lozada', 'ventas.cobefar@gmail.com', NULL, NULL, 'comercial8', '100000.9XTaKSEA+RTwoR+j0nV1dw==.SjoHAa0Q0BcFv7p0nDFa5I64Q07m7mnRYAYeofcyIE8=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Katherine Milusca Vera Valderrama — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Katherine Milusca', 'Vera Valderrama', NULL, NULL, NULL, 'comercial9', '100000.y1Tak8SgvMyMluHqtz0V7g==.No9fEYNR9tzvlQSDLAUTXvVB9ZV4p9dFeCE3lYAz9oQ=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Katty Tatiana Fabian Coronel — AREA DE VENTAS ESTRATEG. (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 58, 0, 'Katty Tatiana', 'Fabian Coronel', NULL, NULL, NULL, 'comercial10', '100000.QzrGHJKC3fdQLVZj4kPmfg==.j0OQsCZX4NerQjJ5Fcjdop/EG3bMKsObwSVrwpYXmSo=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kelly Victoria Murayari Pacaya — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Kelly Victoria', 'Murayari Pacaya', NULL, NULL, NULL, 'comercial11', '100000.WBuRYUYHjq4txZM4fIX/fg==.vdH2AjZRMtWxyQ7sGt+0llHt3LGRHXKw4qZo6Wpa7ko=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kevin Brandy Ramos Artica — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Kevin Brandy', 'Ramos Artica', NULL, NULL, NULL, 'comercial12', '100000.S7lyG1R1F7SHrmfCtU3bKQ==.4YU/dqYGV6wyuAfi93UNnteu9HIG5tpoKwF4bDFDgUY=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lizbet Erika Galindo Castañeda — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Lizbet Erika', 'Galindo Castañeda', NULL, NULL, NULL, 'comercial13', '100000.rzS0n/TIN+0VmtUIo/49/w==.mX38GSbT/RtchPd2wb7zoHPoKnZuhg5uzpivHZCcGRU=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lizseth Jessica Paucar Condor — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial14')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Lizseth Jessica', 'Paucar Condor', NULL, NULL, NULL, 'comercial14', '100000./TPueh/PJgoxHgEgge1PkQ==.1TJXFPU7LXHC3RtpJy/TEMrXMZAOS8EY9kChcvWH4v0=', 14, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lyz Mariela Zamudio Gonzales — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial15')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Lyz Mariela', 'Zamudio Gonzales', NULL, NULL, NULL, 'comercial15', '100000.1HRVO2vMRNrIl7BC8da7OQ==.jy3UC542F6bQIU/ek4e5kBOBAaiZSyH0P7TYo4REd7Y=', 15, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marco Andy Cruz Cuellar — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial16')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Marco Andy', 'Cruz Cuellar', NULL, NULL, NULL, 'comercial16', '100000.4LiehO6gB30qnJKdMOrYxQ==.QDsTeTKFY1FjJgpC39WT66etDQlJyNT+BdNGm02v15I=', 16, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maricruz Julia Bacilio Cardenas — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial17')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Maricruz Julia', 'Bacilio Cardenas', NULL, NULL, NULL, 'comercial17', '100000.CqLwp4DRMwIVY+POXm6aOw==.xtNA+Vgx5vJqFslrszsObo5YCsYAbAV9H637M7PWw6o=', 17, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mery Quispe Vega — AREA DE VENTAS ESTRATEG. (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial18')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 58, 0, 'Mery', 'Quispe Vega', NULL, NULL, NULL, 'comercial18', '100000.Iz9ynhDuoNFxFG59s1693w==.EGjLpu3sTQpEYIK9CDfZkEiH9doE9bPoOzH8jN9zll0=', 18, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Miriam Rocio Valer Arroyo — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial19')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Miriam Rocio', 'Valer Arroyo', NULL, NULL, NULL, 'comercial19', '100000.3NvMOolKtAm+mvbKPAxTVQ==.slk8ZsRjA89PYDdyNTCA0AzhDbtoK/4nvqF4U47mwqI=', 19, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Reyna Elena Soto Escriba — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial20')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Reyna Elena', 'Soto Escriba', NULL, NULL, NULL, 'comercial20', '100000.pBCmrtTFs4GLmOyNZkuC+g==.ENnlWcHbukchzsTpQE/TYLx6JnuaJb+QWn0CeEST6Tw=', 20, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Richard David Venegas Walhoff — AREA DE VENTAS HORIZONTAL (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial21')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Richard David', 'Venegas Walhoff', 'richar.venegas@cobefar.com.pe', NULL, NULL, 'comercial21', '100000.LK1i76g/8ii0aTQFs2eRoA==.Hqtz5PFqvS87Ls0JgGwkM/PJjVh9JTkoypKuw0bV148=', 21, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sandra Rossana Román Tello — AREA COMERCIAL (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial22')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 62, 0, 'Sandra Rossana', 'Román Tello', NULL, NULL, NULL, 'comercial22', '100000.xMyeaRhp8GlJph0Q3AqFVg==.Jmj1On4McT04jrO2ySX3m9KjUmoVskwBAGoMKFvqLjA=', 22, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Smith Hugo Gomez Samaniego — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial23')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Smith Hugo', 'Gomez Samaniego', NULL, NULL, NULL, 'comercial23', '100000.MT1E5VEBbsuFQJV56vFW2A==.Lv/RDTXcUkkfd3H18gwnHz70cbxNzA+ci/P0ln/Va1A=', 23, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Susel Geraldine Castillo Ventocilla — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial24')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Susel Geraldine', 'Castillo Ventocilla', 'susel.castillo@cobefar.com.pe', NULL, NULL, 'comercial24', '100000.BEALwhrjyeOFHMvQRY7eUQ==.9XmP+LGYqfLxC/nPXSPci76kYLWuJI8KKvOU8Rtw+qM=', 24, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wisman Aurelio Chinchay Chasquero — AREA DE VENTAS CALL CENTER (DEP. COMERCIAL)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial25')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 59, 0, 'Wisman Aurelio', 'Chinchay Chasquero', NULL, NULL, NULL, 'comercial25', '100000.rR9qMVOupfAfPpP+Fz0jMQ==.BEokMISf7kIgky3SuxG192f5IZDHihARGlJF4XrULXE=', 25, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Brayan Beder Portilla Lliuyacc — AREA DE ADQUISICION Y ABASTECIMIENTO (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Brayan Beder', 'Portilla Lliuyacc', NULL, NULL, NULL, 'compras1', '100000.jd9YH3V3rg5oCRohGeVEzg==.jQLPTQqzmYMnglDjEEc95P41bwlAiDO0RRGvMw1ggog=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cristian Noel Huayta Villegas — AREA DE ADQUISICION Y ABASTECIMIENTO (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Cristian Noel', 'Huayta Villegas', NULL, NULL, NULL, 'compras2', '100000.YToHUPfSp7Nhj9oiXKNKJw==.7jcCpw3vsUjlgRyeUPo10q9fNop8XNx1w7aD84BH6f8=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Dennys Jesus Mendoza Urquizo — AREA DE ADQUISICION Y ABASTECIMIENTO (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Dennys Jesus', 'Mendoza Urquizo', NULL, NULL, NULL, 'compras3', '100000.Qi40FBpkaDYwRFs7/lsGrQ==.Tf6bA3ny+7LvZXA3Y9LQwadRSRxmfH3yo59rjjUuDs4=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gregori Jhonatan Gutierrez Avalos — AREA DE ADQUISICION Y ABASTECIMIENTO (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Gregori Jhonatan', 'Gutierrez Avalos', NULL, NULL, NULL, 'compras4', '100000.cRqVos3QEsYs+huPS0yzvw==.K0hIM/xL0gD5rEtXoHhVqst8N3tLd/0yCYct/VSfjrw=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Ivan Banda Angaspilco — AREA DE COMPRAS (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 45, 0, 'Jorge Ivan', 'Banda Angaspilco', NULL, NULL, NULL, 'compras5', '100000.9RO4aVgOhif2GKcXHok8jA==.q9WvGuvV9HEAvwkrdb7+zpgerf4UiSCi1nX5whek+sE=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Luis Flores Ccasa — AREA DE ADQUISICION Y ABASTECIMIENTO (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Jose Luis', 'Flores Ccasa', NULL, NULL, NULL, 'compras6', '100000.0lvZhz0O8ldRPIwXgbb1ow==.2SQwOVmimAiXeRAUezCcMQVGuzAiy9puaSyg2pcffbQ=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Antonio Garcia Chauca — AREA DE ADQUISICION Y ABASTECIMIENTO (DEP. DE COMPRAS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Luis Antonio', 'Garcia Chauca', NULL, NULL, NULL, 'compras7', '100000.NVLUDFvlfa61EhFBycvuvA==./aPgR1SMq3Qgena4oBnWx13g88lGueP1Siet3JrNfxw=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Clara Cecilia Becerra Sanchez — AREA DE ASEGURAMIENTO DE LA CALIDAD (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 55, 0, 'Clara Cecilia', 'Becerra Sanchez', NULL, NULL, NULL, 'dirtec1', '100000.mk17qulNnhKqkF09f8/QHA==.MC9yobM08uIfrq4ss/yU0w/0sCa8AZuRADcNU5/mjO8=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Fernanda Pamela Collahua Senosain — AREA DE DIRECCION TECNICA (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Fernanda Pamela', 'Collahua Senosain', NULL, NULL, NULL, 'dirtec2', '100000./mG2s5ZWzu2y3d6aXAt9Iw==.BpWd8RBwJY68acbIufwm4BtbizEH/Yq2cvB4NgZSc0U=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maria Yogana Aguirre Reyes — AREA DE CONTROL DE CALIDAD (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 52, 0, 'Maria Yogana', 'Aguirre Reyes', NULL, NULL, NULL, 'dirtec3', '100000.e7cKJSU9r/ty6ykLcQCNjg==.z6FNM4JLWCAhIaP0DAXHJeWz1XUxTcEw7IZp6GbaTuU=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maribel Ramos Jamjachi — AREA DE DIRECCION TECNICA (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Maribel', 'Ramos Jamjachi', NULL, NULL, NULL, 'dirtec4', '100000.gyrvPafTRzIfLAtJH5WJew==.rWdeTNL9hbbtcqR9eZUjbnfgtxp5XFcRvrbJJPR6+YE=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Pamela Susana Ojeda Vilca — AREA DE DIRECCION TECNICA (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Pamela Susana', 'Ojeda Vilca', NULL, NULL, NULL, 'dirtec5', '100000.a9DMq5hT46zhjsQrkeAb3g==.jskq99hBOZUP3A8KATbMEwBkICfxeVq48kpJpOU1IdU=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Roly Ronald Gonzales Romero — AREA DE CONTROL DE CALIDAD (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 52, 0, 'Roly Ronald', 'Gonzales Romero', NULL, NULL, NULL, 'dirtec6', '100000.NvJpWGrxpw4+ragCj0agFw==.qslGAUVwqAdUT23A0NmLpY4stu9xEHhhT7twOHT2Gzk=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Shirley Melanie Castillo Espinoza — AREA DE ASEGURAMIENTO DE LA CALIDAD (DEP. DE DIRECCION TECNICA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 55, 0, 'Shirley Melanie', 'Castillo Espinoza', NULL, NULL, NULL, 'dirtec7', '100000.2zwHyj49qgDujn3UHxQDNg==.lNRkEuircxTXaYD663SlH9Xe2FFyH9qe0/LcqtF1kTE=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Anibal Mamani Quispe — AREA DE FACTURACION (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Anibal', 'Mamani Quispe', NULL, NULL, NULL, 'finanzas1', '100000.Xey5pdK//WO0rQBFFjcbOw==.ypVsEKuAB3BOSGsQhFnBGF9Za4OZbpIkE7mFTFX6YQk=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Deysi Yudit Osco Mamani — AREA DE FACTURACION (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Deysi Yudit', 'Osco Mamani', NULL, NULL, NULL, 'finanzas2', '100000.NgpcbJw0dr9vSqnJKHANhg==.sXra/g4IG0JXcHFP5qadIjJnzO54BwQn99ppfT4HtwQ=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Elmer Alberto Espinoza Aldava — AREA DE FACTURACION (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Elmer Alberto', 'Espinoza Aldava', NULL, NULL, NULL, 'finanzas3', '100000.mKNuaX4r3LlP1PTmwzbilw==.TbLXJcEq3teUXF6pcQ2wcAWqDQVk8r/bgPXOwvU/usQ=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Javier Sebastian Burgos Trinidad — AREA DE TESORERIA (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'Javier Sebastian', 'Burgos Trinidad', NULL, NULL, NULL, 'finanzas4', '100000.Zh0iHEhEgmf2Pp6iGFclKg==.wtr2MEgz8cNELw+F1TCgLycGAohxR6nb3T8hVjWqAF8=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Myriam Daniela Banda Angaspilco — AREA DE TESORERIA (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'Myriam Daniela', 'Banda Angaspilco', NULL, NULL, NULL, 'finanzas5', '100000.fLjsZBMh+Tgaht6Cx5KKdg==.Grz5kv1bNWKffBjIPXZAL3rnZWdcLvMUG8D+mOOUSG8=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Tait Sanmi Galindo Palomino — AREA DE FINANZAS (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 80, 0, 'Tait Sanmi', 'Galindo Palomino', NULL, NULL, NULL, 'finanzas6', '100000.m6xR43rsxjuINX2tDmLjsA==.xLC5XDf/JoXN806xPIId7N5NX+xVcMlvEz6J2rNuxAU=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wendy Oblitas Meztanza — AREA DE CONTABILIDAD (DEP. DE FINANZAS Y CONTABILIDA)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 81, 0, 'Wendy', 'Oblitas Meztanza', NULL, NULL, NULL, 'finanzas7', '100000.5/qSrlvnRpMpE3rxovoCSQ==.goITeL+yNdVNaQOtWb2Hv/NI4mRSqqP8J7LEu+Vbw7U=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Hugo Ricardo Perez Ñaupari — AREA DE INFRAESTRUCTURA (DEP. DE MANTENIMIENTO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 85, 0, 'Hugo Ricardo', 'Perez Ñaupari', 'hugo.perez@cobefar.com.pe', NULL, NULL, 'mant1', '100000.eu/CixlGYzIfKIlIU3DSUA==.atCQ97YdQJMWEWTX6fOppkjNq/sTjyygQE/30gXM1Eo=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lesther Gil Vasquez Sajami — AREA DE SEGURIDAD Y VIGILANCIA (DEP. DE MANTENIMIENTO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Lesther Gil', 'Vasquez Sajami', NULL, NULL, NULL, 'mant2', '100000.HEidOoXLQiYFxcrY+ZBHMg==.PEYfhqYzvA7SyNYkeHLUIsW0UDdIP8k0shI+3nV4OvM=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yorh Socrates Carbajal Ponce — AREA DE MANTENIMIENTO (DEP. DE MANTENIMIENTO)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 86, 0, 'Yorh Socrates', 'Carbajal Ponce', NULL, NULL, NULL, 'mant3', '100000.B22NZp9DmTVAxfLcYh209w==.IvjeAbLGWp/HabEJ94AYM2MaP+78L/iMW1n3yDd/tRA=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alex Shupingahua Sangama — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Alex', 'Shupingahua Sangama', NULL, NULL, NULL, 'operac1', '100000.w+Penn7m98PGeaAnIAeayg==.zaQqwDXeqn7lx8tQvZlI+PoU2fc413M/WaUV6tyKEWg=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alfredo Benito Roldan Esparraga — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Alfredo Benito', 'Roldan Esparraga', NULL, NULL, NULL, 'operac2', '100000.jq91mvHBGeFVakAdfmM1Kw==.4nOWeMr5Oc0jHfm5xZ4gji+GpzRZBlltFZD3AYynxy8=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Anita Cuadros Chuchon — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Anita', 'Cuadros Chuchon', NULL, NULL, NULL, 'operac3', '100000.5MmBdBDUGnUHhroeBbL4og==.oe3JVnOjTDI3CWv4oKnRBjzFpuVAOWG/GUQpeCG/lMA=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Bryan Hector Cristobal Pariona — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Bryan Hector', 'Cristobal Pariona', NULL, NULL, NULL, 'operac4', '100000.0IOvkVpK3QfIcO14WqAwEw==.NTHSXlCjMhtO6sH++ASxai4L6QzCnwBwei6AaeC0PAU=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Bryan Rogger Mamani Palacios — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Bryan Rogger', 'Mamani Palacios', NULL, NULL, NULL, 'operac5', '100000.i+fFAB+bSkOecSy57nl/kA==.UDJlMa7Jc919uUCoeYs3lcvnA9Q4v4YhssIra19pUxw=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carmen Condori Saravia — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Carmen', 'Condori Saravia', 'recepcioncobefar7@gmail.com', NULL, NULL, 'operac6', '100000.5KlLIyY4DSprdKeDCNdEgQ==.EG/EkggZ6l0/C9lDZZhLofB8rPTAuu6Ol46wcAEEmGg=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cesar Eduardo Vasquez Ascona — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Cesar Eduardo', 'Vasquez Ascona', NULL, NULL, NULL, 'operac7', '100000.iTvO7WxHlXM2EWZVgB95vQ==.LmwxDTmHh8BN1Mc4GilTo/czEG+bEYR0e2OAdTMzVH4=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Chaly Gonzales Torres — AREA DE VERIFICACIÓN Y PACKING (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Chaly', 'Gonzales Torres', NULL, NULL, NULL, 'operac8', '100000.jhRtIhC3TEfNYXXev+qnrA==.j09liZJ73cONK/kn6p3Rq8ffanWuY0IZAEVxZcbMr5A=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Daniel Gerson Auccapoma Hijar — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Daniel Gerson', 'Auccapoma Hijar', NULL, NULL, NULL, 'operac9', '100000.VDwfZdfAI7kguWUQxlj51g==.rKJkJWUDekGRa6On5hawRNqw0DFi0jOfurxMryMXfYI=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Diego Yeme Mamani Quispe — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Diego Yeme', 'Mamani Quispe', NULL, NULL, NULL, 'operac10', '100000.XvhaQ8oPziTZDHCarc+tLQ==.g5BN/ppfPUjxIrjl9gtNMb8hING/u2zRzd4P5nGAE8c=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Dusan Ccarampa Leon — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Dusan', 'Ccarampa Leon', NULL, NULL, NULL, 'operac11', '100000.L6tMFLw0e7i3U61bc6S7ug==.y5siMeJBnlckvpAI31MM70QUrm1bltDtM/xXvK87+l8=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edwar Alonso Chapoñan Huiman — AREA DE VERIFICACIÓN Y PACKING (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Edwar Alonso', 'Chapoñan Huiman', NULL, NULL, NULL, 'operac12', '100000.RjbvZhzvSZkk9DELTgKJnw==.E+OnaMgYL8EteYdDSiViWcAmp8cgKUOIlOfyKwBCdUQ=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ericson Torres Flores — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Ericson', 'Torres Flores', NULL, NULL, NULL, 'operac13', '100000.lcs9tTSo8IyBvp1ffeHRXA==.BnX/JegjRbEeXNDOBbHXEU3RQ5boJkJmxb8phc4AcJU=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Erlis Julio Roman Silva — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac14')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Erlis Julio', 'Roman Silva', NULL, NULL, NULL, 'operac14', '100000.GCo+gA2qx73naZkJIZUgzA==.oHc4N2uHzGhd2p9D1K06HmBq4SMnzRKRubK1/tVOMGE=', 14, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ghelen Celiz Saravia — AREA SUB GERENCIA Y ANALISIS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac15')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 76, 0, 'Ghelen', 'Celiz Saravia', NULL, NULL, NULL, 'operac15', '100000.3Ve3CtHEh6zz97Ypn4GPVg==.gGriZTjLXY6fX5iL8PNNpO0wSLCZKas8lPClbQ6SiKU=', 15, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gilson Marcelino Quispe Vidal — AREA DE VERIFICACIÓN Y PACKING (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac16')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Gilson Marcelino', 'Quispe Vidal', NULL, NULL, NULL, 'operac16', '100000.ERh4DdH5GI6YlJLlYZ9gcg==.CvmSs6K5z9MK1N1ddmYx4op9V4snCpXZA/IVB37DlJg=', 16, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gin Al Jhonatan Caso Castro — AREA DE PREPARACIÓN DE PEDIDOS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac17')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Gin Al Jhonatan', 'Caso Castro', NULL, NULL, NULL, 'operac17', '100000.ZXO+w/k7u5Wn8h2h+9GjMg==.kF1pvr7Cnki24VkhUqtB7OXcXrRYbNJ529l70TUp3zo=', 17, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jack Michael Minaya Calderon — AREA DE VERIFICACIÓN Y PACKING (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac18')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jack Michael', 'Minaya Calderon', NULL, NULL, NULL, 'operac18', '100000.zuzJhRyzfYZKhdakP1EUyQ==.4SyQ1H9KccfUb56aobCjI514WKUbkw03rma/DfbY/OU=', 18, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Javier Yasmani Huarachi Mamani — AREA DE DISTRIBUCIÓN PROVINCIA (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac19')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 73, 0, 'Javier Yasmani', 'Huarachi Mamani', NULL, NULL, NULL, 'operac19', '100000.cOVnOBFh4Guv5HWDZTHqRg==.z0TDoPzDHkMKsD0Brb2GaLlnthvst/FdSEtlZZGhhIo=', 19, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhan Edhitson Ticona Quispe — AREA DE PREPARACIÓN DE PEDIDOS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac20')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Jhan Edhitson', 'Ticona Quispe', NULL, NULL, NULL, 'operac20', '100000.xC44hPCmrfg4KUm0gQ081w==.z/tr5Lh0RYMrHUdI7IVPNa8rQCrtMiuxiMAya8oqxgw=', 20, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhordan Carlos Chuquiray Flores — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac21')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Jhordan Carlos', 'Chuquiray Flores', NULL, NULL, NULL, 'operac21', '100000.P9JA3+wbcqfaz0tXyYki8w==.B11pZmmCrayqw/MojP5Fc0hfXJKM7RNeplpMuYzSxMs=', 21, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Luis Pezo Mozombite — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac22')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Jorge Luis', 'Pezo Mozombite', NULL, NULL, NULL, 'operac22', '100000.cbpENNin/yOdoADfrAp5kA==.V13MzHKfT8BbCVxsD2oI23f13TzoTPE4WsTW8W8MWDA=', 22, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Manrique Cuadros Trillo — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac23')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Jorge Manrique', 'Cuadros Trillo', NULL, NULL, NULL, 'operac23', '100000.iB5KyyQKzsmlhdmCtf0CLg==.jclEbsFl+LNaumg3ecxUw5VhUKbs+ejIg6N/Y1uYbtw=', 23, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Carlos Damian Aldaba — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac24')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Jose Carlos', 'Damian Aldaba', NULL, NULL, NULL, 'operac24', '100000.VYRw8hxFpqOxVA3zcn5HBg==.IG4iLM638rBs4WjAUyElJbk7p+wfV++kb8dy+tyfQeo=', 24, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- José Luiz Cumbia Ramírez — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac25')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'José Luiz', 'Cumbia Ramírez', NULL, NULL, NULL, 'operac25', '100000.qzg2ZoCJxdXiZRy2GnoFJg==.T5lMBs0UZk8GuQGCckJFm0MZNcFDbli/wrc+9L81uIU=', 25, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Milton Mamani Pucho — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac26')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Jose Milton', 'Mamani Pucho', NULL, NULL, NULL, 'operac26', '100000.bahmYV+TXqkzfPmJnbLZtA==.snOxTMOi0SbxS94jceqN41VEPx3+0/HpiXqAz1GfT1c=', 26, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Juan Leonardo Terreros Tenazoa — AREA DE PREPARACIÓN DE PEDIDOS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac27')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Juan Leonardo', 'Terreros Tenazoa', NULL, NULL, NULL, 'operac27', '100000.Z8K9kxI/hORLApNYH9i/jA==.qK31bMX+dM19As9p8upOzxciIC78UB8EjgpAIvc9+pU=', 27, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Leonardo Miguel Sarmiento Romero — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac28')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Leonardo Miguel', 'Sarmiento Romero', NULL, NULL, NULL, 'operac28', '100000.9Y0v3hWj7Cc4pTJg8ZmOaQ==.Iq5pLmsvpJQRSw2seEPY0aNBr+Qdk1SsuPRhEWDPIS4=', 28, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Junnior Damian Villanueva — AREA DE PREPARACIÓN DE PEDIDOS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac29')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Luis Junnior', 'Damian Villanueva', NULL, NULL, NULL, 'operac29', '100000.9rxnfQY8qMJPGfDy68vY6w==.sbmyoZXKj6GnQvduDgbvGPzDvck6U+hl2M7vB0EqaUM=', 29, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Mayron Serquen Quispe — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac30')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Luis Mayron', 'Serquen Quispe', NULL, NULL, NULL, 'operac30', '100000.EUmwJykoH0m4J+yUfTd52Q==.xOuSavYacV2dpYMTqpUViix8SaM3Dcr9O8kEgDZAZoo=', 30, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Manuel Alberto Lopez Castro — AREA DE DISTRIBUCIÓN LOCAL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac31')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Manuel Alberto', 'Lopez Castro', NULL, NULL, NULL, 'operac31', '100000.nUnIRmyTEsRCTlqpbCbAJA==.r95p2XcUTf8e6thE8XGfUDCBmPH8u140IzxDQH2Cq7M=', 31, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marco Antonio Raymundo Miranda — AREA DE TRANSPORTE (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac32')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Marco Antonio', 'Raymundo Miranda', NULL, NULL, NULL, 'operac32', '100000.NHvNaMhQE7ezt65WXnzv1A==.MuM430GIy2+/5PWQsm9tB7iiGIMWLfgF0cO5AfuAr8w=', 32, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mark Renzo Landa Arévalo — AREA SUB GERENCIA Y ANALISIS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac33')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 76, 0, 'Mark Renzo', 'Landa Arévalo', NULL, NULL, NULL, 'operac33', '100000.u8kZ8vzSJSyZxB4KODYJWQ==.ZmxZPny9NJYcR8KeHQ4Tha84AhHYEy/WEe3KqQBawPk=', 33, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marvin Carlos Gonzales Ruiz — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac34')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Marvin Carlos', 'Gonzales Ruiz', NULL, NULL, NULL, 'operac34', '100000.XjZJ22Ku8Cy5NdDHYnOrSQ==.pH7mFU//HWkdZ3nUuitwLaV/WLJKBScDf9jgCOdiD8w=', 34, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mishell Vanessa Rojas Bueno — AREA DE TRANSPORTE (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac35')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Mishell Vanessa', 'Rojas Bueno', NULL, NULL, NULL, 'operac35', '100000.gWYG21z7mDuqlT+PNlN5qQ==.X1WeWm0s2c20juDmVCIkdu9KmMmlaZfFK2Dkcr4921s=', 35, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Nancy Liliana Inoñan Santisteban — AREA DE VERIFICACIÓN Y PACKING (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac36')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Nancy Liliana', 'Inoñan Santisteban', NULL, NULL, NULL, 'operac36', '100000.kbhIRbF7nTwd2W/y+b63Gw==.Y5UL6acyHljOSSAkHYx5J0hxM7pwzeimmctBXH3kQIg=', 36, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Pedro Luis Zapata Sosa — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac37')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Pedro Luis', 'Zapata Sosa', NULL, NULL, NULL, 'operac37', '100000.9tsCpngE9GjSI2uF8keMjg==.GDR9xIIm5auInF22+jyFYIy7acoq5PU8OJDHhAU6p14=', 37, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Richard Franklin Flores Chambilla — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac38')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Richard Franklin', 'Flores Chambilla', NULL, NULL, NULL, 'operac38', '100000.JNgrLTf4Rz39FIqRbGQKAg==.PULXoQoghOFqx9xAJcUCGVep8c96X2gBGuYd3t+DUao=', 38, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Robert Jhonatan Rojas Peregrino — AREA DE RECEPCIÓN Y CONTROL (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac39')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 66, 0, 'Robert Jhonatan', 'Rojas Peregrino', NULL, NULL, NULL, 'operac39', '100000.RICxBkkyrwAj3DZlZxEoyQ==.g86NQ3YiexBijFH5FiD9m3cxlPnoVe1AoihVxp7tDgc=', 39, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Vicente Abel Aguilar Bardales — AREA DE PREPARACIÓN DE PEDIDOS (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac40')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Vicente Abel', 'Aguilar Bardales', NULL, NULL, NULL, 'operac40', '100000.JplyY0Jq8/yPuoF9vB7rLw==.ys9Qa+AMPB7U2Zg7mqIusxE6P3d2jEnN4tKmCKaSq4o=', 40, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilder Orlando Espinoza Guere — AREA DE VERIFICACIÓN Y PACKING (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac41')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Wilder Orlando', 'Espinoza Guere', NULL, NULL, NULL, 'operac41', '100000.5YT2JrUYI8BgZCBhyjReAQ==.aS38g3rGv31DVqHFsKsKKOU4VHAtwsiZz+0o/xDP6+c=', 41, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilfredo Miranda Asillo — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac42')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Wilfredo', 'Miranda Asillo', NULL, NULL, NULL, 'operac42', '100000.JseIoMmM1sVakw8a/FueAg==.c+yBL+ICP6Qnhd5uWZtBD9OSBiA708p1Mi/kmCE0Tmg=', 42, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yesenia Yerin Ayllon Collahua — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac43')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Yesenia Yerin', 'Ayllon Collahua', NULL, NULL, NULL, 'operac43', '100000.vIJ2OVDlnXdMhgloTToYFg==.wf2nFd3s86qVLPdVQn5I8DyQjfHjEP0GKUYVs1nLr54=', 43, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yorelly Milagros Vinces Chumpitaz — AREA DE OPERACIONES (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac44')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 75, 0, 'Yorelly Milagros', 'Vinces Chumpitaz', NULL, NULL, NULL, 'operac44', '100000.IssO/Aaqx3FCuApKRBeg8Q==.lk54s7hkoNflWiszjNXMi0/US7/V1MEczdR15ItgNLE=', 44, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Zandalee Karl Farfan Litano — AREA DE PICKING ALM 08 (DEP. DE OPERACIONES)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac45')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 68, 0, 'Zandalee Karl', 'Farfan Litano', NULL, NULL, NULL, 'operac45', '100000.4hw7WAXFhqgLEgjthhW6eA==.ATtbkBXz2Gr4Tl1hxBk0ZVxwurDwAv1mreoYfMG7xUE=', 45, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jonathan Michael Puris Naupay — AREA DE SST (DEP. DE  RECURSOS HUMANOS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 49, 0, 'Jonathan Michael', 'Puris Naupay', NULL, NULL, NULL, 'rrhh1', '100000.yjLpkV84EHgvmnaSjLlplg==.bMGD/q9QaIkFsfAzqPDgCfpyXSE65jqYLNMnmXiICVQ=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mery Jesus Vasquez Del Aguila — AREA DE COMPENSACIONES (DEP. DE  RECURSOS HUMANOS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 48, 0, 'Mery Jesus', 'Vasquez Del Aguila', NULL, NULL, NULL, 'rrhh2', '100000.wY83yssetjEyQlz+QYNc8Q==.7NyJdvtn58fjVi9JoYYnbyoL7BxRl98ykM1DtHAGrSE=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Tashina Mejia Soto — AREA DE BIENESTAR SOCIAL (DEP. DE  RECURSOS HUMANOS)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 47, 0, 'Tashina', 'Mejia Soto', NULL, NULL, NULL, 'rrhh3', '100000./OKofSTdUw5+7zvvCkOcpg==.cQg9JkEc08DmJGLKF3gWMJ9+djnysgHoNItX2b7qdFg=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- ============================================================
-- Verificación
-- ============================================================

SELECT COUNT(*) AS TotalUsuarios FROM Usuarios;
SELECT Id, Usuario, Nombre, Apellido, Activo FROM Usuarios WHERE Usu_Creacion = 'ImportacionEmpleados' ORDER BY Id;
GO
