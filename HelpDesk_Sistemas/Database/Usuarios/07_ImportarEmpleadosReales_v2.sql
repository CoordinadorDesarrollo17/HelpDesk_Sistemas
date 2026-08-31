-- ============================================================
-- Usuarios -- 07: Importa empleados reales v2, usando la relacion oficial
-- de RRHH ("Lista Personal_Sistemas - Agosto.xlsx", 324 filas) en vez del
-- cruce con la intranet de adquisiciones (que arrastraba areas
-- desactualizadas/inactivas -- ver conversacion previa).
--
-- Se excluyen los 6 usuarios de Soporte/Administrador que ya existen
-- (manager1..manager6 -- confirmados por DNI en el mismo archivo, bajo
-- Sistemas). Todos entran con Rol = Usuario y Sociedad = Cobefar (el
-- archivo de RRHH no trae esos datos); se pueden corregir despues caso
-- por caso desde la pantalla de Usuarios.
--
-- Las contrasenas se generaron con el mismo algoritmo de
-- Common/GeneradorCredenciales.cs y Common/PasswordHasher.cs (PBKDF2-
-- HMACSHA256, 100000 iteraciones). Ver credenciales_generadas_v2.csv
-- para la lista de Usuario/Password en texto plano a entregar a cada
-- persona -- NO subir ese archivo al repositorio.
--
-- Requiere reactivar antes 2 areas (quedaron mal marcadas como
-- inactivas en el import anterior, pero RRHH confirma que si tienen
-- gente hoy):
--   UPDATE Area SET Activo = 1 WHERE Id IN (89, 76);
--
-- Idempotente: cada INSERT valida que el Usuario no exista todavia.
-- ============================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- Franklin Ramon Angulo Guerra -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Franklin Ramon', 'Angulo Guerra', NULL, NULL, NULL, 'operac1', '100000.wr+IbErSvvxI4u/CuL58Lw==.MjeHXHilfGxSz1m8OsxFsJNu2U0NjW9Wd2bezhXWtQg=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wendy Julleysi Oblitas Mestanza -- Contabilidad (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 81, 0, 'Wendy Julleysi', 'Oblitas Mestanza', NULL, NULL, NULL, 'finanzas1', '100000.pD8kqMK7DqmVIVB6lDK/1A==.irxT2ktF7He3xesa+yu6vq6HYTypBLcaWlygkc3DaBk=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhunior Dennis Aguirre Quito -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jhunior Dennis', 'Aguirre Quito', NULL, NULL, NULL, 'operac2', '100000.gBmPi5DaVIil4YAumNvgjg==.UnudXB9Sxcz5IgvHE4jRhMLMygp7WIIz+JgcV0vPlk0=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Ivan Banda Angaspilco -- Compras (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 45, 0, 'Jorge Ivan', 'Banda Angaspilco', NULL, NULL, NULL, 'compras1', '100000.1uA+bFxgs0lo2W1v1sOVmQ==.etP2qkqNR8NxI90TtOaz1AhxbLjVSkJVQB2DvstmlRc=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Fernanda Pamela Collahua Senosain -- Direccion Tecnica (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Fernanda Pamela', 'Collahua Senosain', NULL, NULL, NULL, 'dirtec1', '100000.5PaD3utp/aJFsgEKdvNr2Q==.Wtz4KRF1pcwzO71qYAoSXL47rKm7z/VItPOz1bck+eQ=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Damian Aldaba -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jorge', 'Damian Aldaba', NULL, NULL, NULL, 'operac3', '100000.WAE4lZ7zrAGG0sXgHySxMA==.+Vo9UTcaX8xX4cOJU4cOuVp0v/H5EQTr9vzBMZanvOo=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Antonio Huarachi Velasquez -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Antonio', 'Huarachi Velasquez', NULL, NULL, NULL, 'gerencia1', '100000.q2t1KEtqH1niabJWxnjW1A==.WIz6XmcT4v3VJdxDRIgtB+9xHkZ5ycNlhFsA7y4QgTY=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edgar Nolasco Chavez -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Edgar', 'Nolasco Chavez', NULL, NULL, NULL, 'operac4', '100000.6VoLOHWn6Q7KI08E78qsUQ==.F2eUCCMVuoiC98grg+t/nakn/XAqdf07Se1jUw+NlKg=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Robert Jhonatan Rojas Peregrino -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Robert Jhonatan', 'Rojas Peregrino', NULL, NULL, NULL, 'operac5', '100000.vfxgH0tLUg9vjpw8VBUI1A==.7Mn6C0l6TXChyyEhGHmyhdzeZ+oQpubx6+SKpBdgrDI=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Erlis Julio Roman Silva -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Erlis Julio', 'Roman Silva', NULL, NULL, NULL, 'operac6', '100000.+KkE1QyjvCnIep5LaCt3Kg==.jLXpI0OCk2Dvb/Ygn0Z8bFAiJcZog7ngwVrxGq1PljY=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Reyna Elena Soto Escriba -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Reyna Elena', 'Soto Escriba', NULL, NULL, NULL, 'comercial1', '100000.f6aG3fDeI2xvUxvOZDOk8w==.4IRgg+XSfVom4cqWQ+PlweX26lu6Q9T5EqGUlqxVGmg=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Betsy Yessica Untiveros Crispin -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Betsy Yessica', 'Untiveros Crispin', NULL, NULL, NULL, 'comercial2', '100000.iQOMHF31yHWQQxBBNT3MDg==.H1N2mnDh9bETPtnDt/gPnM6gshnb8mnFvJovBKuR9CE=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edgar Alfredo Yauri Montiveros -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Edgar Alfredo', 'Yauri Montiveros', NULL, NULL, NULL, 'gerencia2', '100000.PO1B5zb5BCUgMpqtnVZNIA==.Cwua7VpUpOaRmOM3URPCnBv2ximpe5O3kxvP08BBJxY=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilson Ivan Acho Navarro -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Wilson Ivan', 'Acho Navarro', NULL, NULL, NULL, 'operac7', '100000.uB0vGPZTk1sgzfp2ohJLuQ==.Agg1nMI0mlCM23dbYy/zudhspJrlgHLpiYeG4pZw5SA=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Anthony Alberto Auquipuma Quispe -- Subger. Y Analisis Operaciones (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 76, 0, 'Anthony Alberto', 'Auquipuma Quispe', NULL, NULL, NULL, 'operac8', '100000.v36OhWuiFnOd3vk2smcPSA==.7q4OPoLf0xXez+PzbIcOftEkvG4nb2qRnqxteXCJ+hk=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Dusan Ccarampa Leon -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Dusan', 'Ccarampa Leon', NULL, NULL, NULL, 'operac9', '100000.qU2ZPDwRMScJoZ3K3adKnw==.dNKV2m1k73wDgPMT3TEUj0WeSEVOcLOmH44MxTQCijY=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Robert Chapoñan Pizarro -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jose Robert', 'Chapoñan Pizarro', NULL, NULL, NULL, 'operac10', '100000.tYtKJiuJ+N2fG3w8TvUFWA==.5StI1nLeZqekUH+VuDiCLXqxWHkN3++xJk6J6MY+/aQ=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Pedro Juan Chocce Vargas -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Pedro Juan', 'Chocce Vargas', NULL, NULL, NULL, 'mant1', '100000.TJvIk7ITZCLcR3pRaQs/YQ==.0LaB2eUn6awm19ucGN3/1dJIVX9/MnQ8d0JijFZK6dU=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Manrique Cuadros Trillo -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jorge Manrique', 'Cuadros Trillo', NULL, NULL, NULL, 'operac11', '100000.HbK41lIwAtGtB9EmHeIvOQ==.HVgKRXTt2ajQpgN3b92HrtMtfUQzgkSU9Ek14PXgFTQ=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cruz Jayme Nancy De La -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Cruz Jayme Nancy', 'De La', NULL, NULL, NULL, 'operac12', '100000.Ow88VktFaDXBvOYyOAxwlQ==.21amuTCsOfMVSfBa6unlx+o4tRJbGbpRKaTkzAevZOc=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Luis Flores Ccasa -- Adquisiciones y Abastecimiento (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Jose Luis', 'Flores Ccasa', NULL, NULL, NULL, 'compras2', '100000.eh42DBF4WQ3Isi1RXkA8bg==.cmDOndylZoyHVlmUVGLFAmHalE1eJWr6q8Uqsv9/EtE=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Smith Hugo Gomez Samaniego -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Smith Hugo', 'Gomez Samaniego', NULL, NULL, NULL, 'comercial3', '100000.IZX9FpnhMjtv7B5OlYfimg==.jFKfn08SMhdkGvsr7z0UWY85+CYkUKPlWCbPb0ufGTM=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Arturo Cesar Huaman Yarasca -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Arturo Cesar', 'Huaman Yarasca', NULL, NULL, NULL, 'mant2', '100000.RnrWJ2/l5RerM7seZyjDJw==.JEMgGPLP8LH9DCU4AFIgDVT47dEpOyqfk8xlrMVFEFU=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Medalina Hidania Porras Jauregui -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Medalina Hidania', 'Porras Jauregui', NULL, NULL, NULL, 'mant3', '100000.79TXCYkbTR8qr+Nl/7m+9g==.tFzLLaFr7XUf0kdRJFR8A6RBYs1mHFBzMch2UrgeoFc=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mery Quispe Vega -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Mery', 'Quispe Vega', NULL, NULL, NULL, 'comercial4', '100000.DLoWpgb8ujL0gFlM/cPp7g==./o5xO2nS86ghw1POiHkPVbK8wj/eGoXTnZRIbWYhxQo=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mireya Roman Silva -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Mireya', 'Roman Silva', NULL, NULL, NULL, 'admin1', '100000.Pugo/LALzN5Yi7gP4RhGwA==.Knw6ezkpGriR6Axg7Y6Cw7DkwEn2A1nzFsQ1thgV9Q0=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Valentin Roque Rojas -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Valentin', 'Roque Rojas', NULL, NULL, NULL, 'operac13', '100000.o9tEkJMUs9+cuZKHh45rzQ==.7yIXM/zBS5s16bKjNj5+ESYmXULuztIRePA3lWaQq6M=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Aguila Mery Jesus Vasquez Del -- Recursos Humanos (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 50, 0, 'Aguila Mery Jesus', 'Vasquez Del', NULL, NULL, NULL, 'rrhh1', '100000.dJpLU6GbpWkmE5S7Du5aRg==.JPhMLpdmP1sSvfd3gruzG4UYoyNQeZTJnsetjnckKS8=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Arnulfo Condo Noa -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Arnulfo', 'Condo Noa', NULL, NULL, NULL, 'compras3', '100000.4ZS1WDe4+IelSYjj6qc2Gg==.08trWT0Nq51Gs970ucMAYOKWknFyfHoHdSiItPojwHs=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carmen Condori Saravia -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac14')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Carmen', 'Condori Saravia', NULL, NULL, NULL, 'operac14', '100000.UiK9ZOVb4peFKXR42PhuGQ==.Qqds7wauekehJNEWGS/93DB6nWwVCBdroOod6KDzdO0=', 14, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilder Orlando Espinoza Guere -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac15')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Wilder Orlando', 'Espinoza Guere', NULL, NULL, NULL, 'operac15', '100000.AUq22UZx2E7Iti63sXVmBg==.e0PL8sdIeUJXbPHZKoYITZVIJKzQzYLT9UPbxh66FDM=', 15, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Tait Sanmi Galindo Palomino -- Finanzas (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 80, 0, 'Tait Sanmi', 'Galindo Palomino', NULL, NULL, NULL, 'finanzas2', '100000.PbsPG4Qqd+1rsfuepb0QfQ==.GGSP2IGeEHRXykrVmFdr0nYMbw/n3BT7Tp5rjqNaRCg=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Milagros Begoña Mayta Ñaupari -- Tesoreria (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'Milagros Begoña', 'Mayta Ñaupari', NULL, NULL, NULL, 'finanzas3', '100000.pewpc84D7GtYpdctH7atLQ==.dW+h5O3qisOhZLD9WpERsYI4576u+6+xz2AC7z/JDNM=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Nico Salvador Oscco Mamani -- Infraestructura (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 85, 0, 'Nico Salvador', 'Oscco Mamani', NULL, NULL, NULL, 'mant4', '100000.pgqPWLjgm+ZGjg/JrwTNJA==.JQ2hmK5aol3Y2t6NYidTVjOtcKPitl639Lf/tDeRx+4=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mercedes Pinche Chipa -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Mercedes', 'Pinche Chipa', NULL, NULL, NULL, 'mant5', '100000.mX8Zvke27tPl0OJIF591Yw==.ki1RDaj43KBIuapBIsDSC7zJfHN4/2txd8vno/9FCts=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Camilo Nelson Quispe Mamani -- Infraestructura (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 85, 0, 'Camilo Nelson', 'Quispe Mamani', NULL, NULL, NULL, 'mant6', '100000.bAiGq0wzG4iQ221Bq+EI8Q==.AJfYGD8G1Ae8VgaoccO7DB94zMHVV+c03QL1p+Iypzg=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Julia Dorila Ramos Ortiz -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Julia Dorila', 'Ramos Ortiz', NULL, NULL, NULL, 'mant7', '100000.4icKL/aXfiaPrBBob2/cEQ==.kxGJ0HKxiS6UEET03LyzkTJvui5s/Vvqgk5mFEZyStY=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jehimy Lizeth Risco Rojas -- Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 91, 0, 'Jehimy Lizeth', 'Risco Rojas', NULL, NULL, NULL, 'admin2', '100000.0WTJy7cxWU3hrfHxazvDPg==.AoCB1BSt+7TCdRnA2Ql7lywAprwdNuemGlBRdQb420w=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Patricia Alexandra Mio Atoche -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Patricia Alexandra', 'Mio Atoche', NULL, NULL, NULL, 'admin3', '100000./M+YUHCDUqvlm5pKo+3RTg==.S7+uPuGPhUAPD91WPOfsTGJ270nmuUBA9Gi9ZlaKJ2Y=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ivette Misolina Jaimes Ceferino -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac16')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Ivette Misolina', 'Jaimes Ceferino', NULL, NULL, NULL, 'operac16', '100000.Te3cvzKkHwWHcRU8XGKVTQ==.DW71UcTdq2kzVEJ68Yp6P7JIWqXKNDhUnsk6n+ISAeM=', 16, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Thania Dalila Cruz Marcos -- Contabilidad (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 81, 0, 'Thania Dalila', 'Cruz Marcos', NULL, NULL, NULL, 'finanzas4', '100000.XACoJ/DKZIWD8ZAcrhX+Hg==.oQv11hSqsT02pqbD6sATllP6wMN7//jqoAJ1NhhfyA4=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Chaly Gonzales Torres -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac17')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Chaly', 'Gonzales Torres', NULL, NULL, NULL, 'operac17', '100000.uwKi91UTn4O3X6fCvgxUSg==.dHm8FEthpu94oeZxvtMoI3pq+zduXlhnrkh3UvxQ1Dk=', 17, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yulisa Peña Rodriguez -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Yulisa', 'Peña Rodriguez', NULL, NULL, NULL, 'mant8', '100000.QJIY3ziGNfGXPPU1lLpDaQ==.NcdSMQHtp6K5qP6Lr2bdTmXcZcb5FhbUnJrWB8bqvNw=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Daniel Angulo Garay -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Jose Daniel', 'Angulo Garay', NULL, NULL, NULL, 'mant9', '100000.AVcA4hNVVg9Dtk7nJR1rEg==.k/5tFoYJ88dMjytAi82d8lkU1gAkJJszQQFKJrcmSCs=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Renzo Renato Castañeda Guerrero -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Renzo Renato', 'Castañeda Guerrero', NULL, NULL, NULL, 'mant10', '100000.iiwugMDj2SUIM2mJXOsPig==.PtzdxVFzMS19TnIeh6Ltac6Sx46hBEvAkTsGPXCUIdY=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wisman Aurelio Chinchay Chasquero -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Wisman Aurelio', 'Chinchay Chasquero', NULL, NULL, NULL, 'comercial5', '100000.j+J69jp44Tt+Z830xKgb2g==.f1ZMRXz0ak9qJHAkjcI8AZmoQ3RiUxAxGWfPQb4fygs=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Pamela Susana Ojeda Vilca -- Direccion Tecnica (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Pamela Susana', 'Ojeda Vilca', NULL, NULL, NULL, 'dirtec2', '100000.kw2hMfViWTFFXnZQ92ZJiQ==.8uqpjLNsv8CW3M4I7QgSgV0MmAlYB2miwOlQCnHa2EM=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jimmy Antony Shupingahua Huaman -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Jimmy Antony', 'Shupingahua Huaman', NULL, NULL, NULL, 'mant11', '100000.tij4xuj5yoyYa6FoZUZunQ==.z/lB3tlHrlxo54isIJEj9FmCkMWcmk6qqhEkodjzMDY=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Graciela Uruchi Choque -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Graciela', 'Uruchi Choque', NULL, NULL, NULL, 'mant12', '100000.WZ5uuSI9aL4U2KMceMb1og==.MrxQ1Evsqg4OySn8SlUtQXQ7PorlLCCOm95sDuNxp+c=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Raul Junior Llanos Yauri -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac18')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Raul Junior', 'Llanos Yauri', NULL, NULL, NULL, 'operac18', '100000.SGu/mg+lTZ3Wg4xXmYw+3g==.CoxNb3Yf5mqzXNo5xx8DzlPcYKmmVtLj/E9ehfq9xZ4=', 18, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marco Antonio Raymundo Miranda -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac19')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Marco Antonio', 'Raymundo Miranda', NULL, NULL, NULL, 'operac19', '100000.kLtvNieXlXjSpT8BiGuVjQ==.g7kL7M9k0OQYGqGbYuJi2BzgVJN3MR1WETuHQGibodg=', 19, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Katty Tatiana Fabian Coronel -- Ventas Estratégicas (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 58, 0, 'Katty Tatiana', 'Fabian Coronel', NULL, NULL, NULL, 'comercial6', '100000./1rphJdEr3cmYccJGsQWfg==.qTpwUsRl1cCZJIxaWRAVX6PPE2ACsCZR+BU+KTuhlzw=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Deysi Yudit Osco Mamani -- Facturacion (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Deysi Yudit', 'Osco Mamani', NULL, NULL, NULL, 'finanzas5', '100000.6igGx4tJCo5XhAvgQd309g==.iWPDOaIQWm5794eYVHcdc0S83AblNmdCF/MDoPMZwAQ=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gerson Wilther Ruiz Romaina -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Gerson Wilther', 'Ruiz Romaina', NULL, NULL, NULL, 'mant13', '100000.hS7gaNPzMsSnTpM/ygW0gg==.8VAjBBtN+pb+nsRXc237FYtAljXFicXrFKNNFq2dqNs=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Antony Lino Salcedo -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac20')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Antony', 'Lino Salcedo', NULL, NULL, NULL, 'operac20', '100000.Zu94p7lOvCX3wQqiDyfBvA==.o8D5ghQ00EcbI0NzMK2ErzozEFqdD7xRE/DazwZcEvo=', 20, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Keny Yexon Garcia Calle -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac21')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Keny Yexon', 'Garcia Calle', NULL, NULL, NULL, 'operac21', '100000.QZgqaXJkmriODUoBmmViaw==.UXsQN1WgtbwouT3STf95Cscd8qkUMTfLmU2HB7ZTFc8=', 21, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lizbeth Trujillo Calderon -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Lizbeth', 'Trujillo Calderon', NULL, NULL, NULL, 'comercial7', '100000.zFmhbMg8O/SBtLW3dLI4mw==.RPWQlXVy9LrJbgyWd20KqvlK1borodYAT+173MWQnM4=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lesther Gil Vasquez Sajami -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant14')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Lesther Gil', 'Vasquez Sajami', NULL, NULL, NULL, 'mant14', '100000.PR2CjkfF5zxbC4aBwqMYfw==.UitNyf5hPW7pf3lJxsmkUGrTVyt8Zccq/UK+kGPuZLc=', 14, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Juan Daniel Garay Lopez -- Importaciones (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 93, 0, 'Juan Daniel', 'Garay Lopez', NULL, NULL, NULL, 'admin4', '100000.Y9STPLOfjUgHO7/I/o2Y/A==.r7p+SxhtvidEekfWTQtsPK3lqos8EC0kZe5a9pe/peg=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jesus Angel Huallullo Romero -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Jesus Angel', 'Huallullo Romero', NULL, NULL, NULL, 'compras4', '100000.lCrPhHfgb8WDt0YD5GM3pg==.T2YB/oqzvNyrX1TvAQnLLqKuBXJIDEcstDRdbT1ERsA=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Janeth Peña Pedraza -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Janeth', 'Peña Pedraza', NULL, NULL, NULL, 'gerencia3', '100000.+ymJ1mlOO2xABTGErk4/Ag==.79Br1DskVSmSxqGGFGLEEZVkC0RGRLgvwDp0nQtQqk4=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Leonidas Edinson Pilares Nieto -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant15')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Leonidas Edinson', 'Pilares Nieto', NULL, NULL, NULL, 'mant15', '100000.9LS0Sd4w6ElZ1yARa5z0Zw==.HZXSNDZxjKelz90Q/FlKIJjCC9c2aj3wL4XPLy/jw1c=', 15, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yenifer Rojas Diego -- Contabilidad (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 81, 0, 'Yenifer', 'Rojas Diego', NULL, NULL, NULL, 'finanzas6', '100000.JCUk4RSTlp4kzRepAahy7g==.lKzGiDONnoOWIHYvZuWadRNd+BIKS+wHiL2gglomDFw=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Henry Alfonso Rodas Sandoval -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac22')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Henry Alfonso', 'Rodas Sandoval', NULL, NULL, NULL, 'operac22', '100000.TBjfg/ZfatgNQ9yZbI7vDQ==.YMHOxwiv9tOS8H28cHnrKUqblapltXXMCHeWIlNr0cc=', 22, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Luis Casafranca Contreras -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant16')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Jose Luis', 'Casafranca Contreras', NULL, NULL, NULL, 'mant16', '100000.895vep/7u+K+cOxMxO4JiQ==.LPaIE2KCmSjYsav/evUQzVia2IUBFXc97jjAYM7A5Hg=', 16, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Orlando Chicchon Valdez -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac23')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jorge Orlando', 'Chicchon Valdez', NULL, NULL, NULL, 'operac23', '100000.Sxtr+8uoc6xckQUebK6bOg==.WxOXf4+D1V7CqNAgyAXGpCy8AAiiyybkT5q0XmJm5d8=', 23, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhasmyn Gonzales Marin -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Jhasmyn', 'Gonzales Marin', NULL, NULL, NULL, 'gerencia4', '100000.n0PUxsBoeM2oWao9SfvWCA==.PWCenUa9S8GvygeDtx0It5ovdijhTFA7ex7NmpEMUoQ=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Eswin Antonio Granda Aranda -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Eswin Antonio', 'Granda Aranda', NULL, NULL, NULL, 'compras5', '100000.aQKYvzULxaoTKjkJCoEZPA==.KSL4H6hbweIM3QW+CGcjpxfOezsCG+c39yEdch+mRzs=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Angel Christopher Vargas Lopez -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Angel Christopher', 'Vargas Lopez', NULL, NULL, NULL, 'admin5', '100000.vB9Y9fAIgjhbBQyzV4LArg==.oix/2UbGJO+iBgPS1aaCdCMJ9GrSBXlEKpS+4EQgEx0=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Elvis Jon Chapoñan Santisteban -- Distribución Provincia (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac24')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 73, 0, 'Elvis Jon', 'Chapoñan Santisteban', NULL, NULL, NULL, 'operac24', '100000.hXVJ3hbULhz+PZfQMqzrZg==.x+SQ6JDUxeiSyUSkYqd5KbSNobsZs6HY+tPeEiKdW1Q=', 24, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Angel Anderson Esteves Lazaro -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Angel Anderson', 'Esteves Lazaro', NULL, NULL, NULL, 'admin6', '100000.EHR6fJyUU3gH0B41FRRFZQ==.KfoZ5inlH6KWszc76YuFMGnl/o4hF6qMjZOMRroulwQ=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ronald Jean Pierre Rojas Ticllas -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac25')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Ronald Jean Pierre', 'Rojas Ticllas', NULL, NULL, NULL, 'operac25', '100000.zmRulsWtJtWlsxxAeI4FkA==.CJPsgv2nD3R64iYZDRcV2F/NhNQhdVvvss/1DrTohnw=', 25, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jenifer Valery Atanacio Julca -- Tesoreria (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'Jenifer Valery', 'Atanacio Julca', NULL, NULL, NULL, 'finanzas7', '100000.4wLu7hRVFx59iVV29pjT1g==.pXD47hbD+DXzke/03ttSNMdqhc0dvXpM0PtmZMz+A0c=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kevin Bladimir Chamaya Escriba -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Kevin Bladimir', 'Chamaya Escriba', NULL, NULL, NULL, 'compras6', '100000.O6AmV2+yIwmVO/moDwMsFw==.pAlnY7rIM9xbXFHpdhqoYzI4K1Po+bNg+19K04JLGrg=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Janeth Evelin Ccorimanya Quispe -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Janeth Evelin', 'Ccorimanya Quispe', NULL, NULL, NULL, 'comercial8', '100000.UsvGm5PmYLVpeDkoXB3PhQ==.BRA8Mz0OrlEJRciQV8z9/lMBMiaEQtpqEREMJa/M6yk=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Juan Carlos Oblitas Fernandez -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac26')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Juan Carlos', 'Oblitas Fernandez', NULL, NULL, NULL, 'operac26', '100000.hNXReM+pdsJDVpCdAnPnMA==.1mL0i23aq356EYh6NuF54m3GLQj6Sy2xXIlMxQy/etE=', 26, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kary Esteban Castañeda -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac27')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Kary', 'Esteban Castañeda', NULL, NULL, NULL, 'operac27', '100000.jVsgIZpeNbnsiT8G0EVwvw==.3VK82MmflBROvWO9yqRY4XQqoE63OhHi2toqSuLWMwA=', 27, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Manuel Justo Rojas Prada -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant17')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Manuel Justo', 'Rojas Prada', NULL, NULL, NULL, 'mant17', '100000.Sp8AcLklyFg/e27wxH+tVw==.EWmY8nKl3OaAJLRoe9wq0sx8AhK/tHSZRMnVnE9wxCw=', 17, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Milton Mamani Pucho -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac28')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jose Milton', 'Mamani Pucho', NULL, NULL, NULL, 'operac28', '100000.PRZzrW+ORqWNSaGPlGtqPg==.fUGjrZxY0aNo+stKuht5iSwmru2+WsRU4k6a8p+0lVs=', 28, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Veronica Odett Tarazona Capcha -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac29')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Veronica Odett', 'Tarazona Capcha', NULL, NULL, NULL, 'operac29', '100000.LobmFifqzVeHUZJsm4qbmg==.WRikvjS8sAbmenTcaWP6IkJdbSpaQFKPIcCxZVRl+BU=', 29, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Javier Yasmani Huarachi Mamani -- Distribución Provincia (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac30')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 73, 0, 'Javier Yasmani', 'Huarachi Mamani', NULL, NULL, NULL, 'operac30', '100000.vgDGwcomUeMu3h9RL7qRZw==.byAbZF5GjsJLybSkOdhaP28E8VDdxoaMj0Qaj+FdlO8=', 30, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Manuel Alberto Lopez Castro -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac31')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Manuel Alberto', 'Lopez Castro', NULL, NULL, NULL, 'operac31', '100000.pS6BBIDjSZbClSZ3OFlHFQ==.cad+vBH+iQplTZaVypELp+suTX28Qbuh6TIMttnLfQk=', 31, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Anibal Mamani Quispe -- Facturacion (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Anibal', 'Mamani Quispe', NULL, NULL, NULL, 'finanzas8', '100000.TOnaHUqWHK4aXKHnOT29Xw==.5uzSVT8I57ZZAbc1f0eQJxE5XDoNqOs9kg3lq6nqkkk=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Diego Yeme Mamani Quispe -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac32')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Diego Yeme', 'Mamani Quispe', NULL, NULL, NULL, 'operac32', '100000.cgr3KQrGrHb6AKxbJ8dheA==.1J80pQRy04vYx9tq544Y3nDFg8XFuqH4rST2XkLAwUw=', 32, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Paul Anderson Mamani Quispe -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Paul Anderson', 'Mamani Quispe', NULL, NULL, NULL, 'comercial9', '100000.VeRNyJ2mg7bgkUA4GU1qNQ==.BsheIvRqKJ1bzTvBKLb+A8aCuxW7di6ljMPcwhxVcdY=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Abel David Rampas Huayhua -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac33')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Abel David', 'Rampas Huayhua', NULL, NULL, NULL, 'operac33', '100000.2TafjEZY3w9iuv4vMtD9Kg==.o3SFsjSrEkHZhuSUfa+hJO836EFT28fd/XW8NIDmzW0=', 33, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Abner Ever Amasifuen Tuanama -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Abner Ever', 'Amasifuen Tuanama', NULL, NULL, NULL, 'compras7', '100000.NnpVILXfjaExU5skgTfVSw==.bNTmbzXJO+FFC6lEfDnV0NXUOXVO2wwtyCHtpnqNcg4=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Shirley Melanie Castillo Espinoza -- Atención al Cliente (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 89, 0, 'Shirley Melanie', 'Castillo Espinoza', NULL, NULL, NULL, 'admin7', '100000.kE8Iu4vGpiWjRe/YEFLWdg==.XnLX7m0B0P7iCEh3i25c5YJwrxjJi9Epzj/pWTF5nAg=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maria Isabel Machanay Sulca -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant18')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Maria Isabel', 'Machanay Sulca', NULL, NULL, NULL, 'mant18', '100000.o3tBkAfiwsWemDvKaCBSdA==.SIFwxf1lU34TfeIcIFlQp+A3lDwDO3mK7myqsz6NI4E=', 18, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Javier Sebastian Burgos Trinidad -- Tesoreria (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'Javier Sebastian', 'Burgos Trinidad', NULL, NULL, NULL, 'finanzas9', '100000.O4R06TDVMDOUxQQutnc1jQ==.vnTmGNAIHK7duNzRm4gyud72e5GLNWrlu55GoUFLu5U=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sandra Rossana Roman Tello -- Comercial (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 62, 0, 'Sandra Rossana', 'Roman Tello', NULL, NULL, NULL, 'comercial10', '100000.6BWiBZC1V5o9iW2ExJE7xA==.Cqd7/sNaCvoE4OsfHtcBFlFkeGaxvqyqzMi9aMB5JGM=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sindy Lisbeth Diaz Bazan -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Sindy Lisbeth', 'Diaz Bazan', NULL, NULL, NULL, 'admin8', '100000.xphkC0/Dzbi/Ed7G9nGO/g==.BnOAVfe+jU+HmB7wcifFg6dI5vKtQJW0A9CHP9Wh+I4=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jesus Angel Nunahuanca Cordova -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac34')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jesus Angel', 'Nunahuanca Cordova', NULL, NULL, NULL, 'operac34', '100000.bAKrg/9q4Fx3SYeIfO6TdQ==.UnXFULFxaq4zv1jWc3Q+RGGZZX1Cs/j2PueJoY94PbU=', 34, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Celia Talia Peña Rodriguez -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant19')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Celia Talia', 'Peña Rodriguez', NULL, NULL, NULL, 'mant19', '100000.Gsfe2eZ4eG4dOBXy4UTFVg==.T+hfsTw0qMi/TtSIAc4lLIIcEg3g2xbQEPVk4QxApSg=', 19, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- De Castro Erika Geraldine Roiter Espinoza -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant20')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'De Castro Erika Geraldine', 'Roiter Espinoza', NULL, NULL, NULL, 'mant20', '100000.BBwQ9B4qWGANVXZ4fudK0A==.qdWgBNPtltKfmfP0m98UE1td8sUJy+FyOPBVH5XSBHE=', 20, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Richard Franklin Flores Chambilla -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac35')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Richard Franklin', 'Flores Chambilla', NULL, NULL, NULL, 'operac35', '100000.nizyNVEBaABjFrbsJo1Whg==.N+Btm8Zb0SaL6LmjFi/M8RB60v6Mnc6E1LaOnaNGtAA=', 35, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carlos Asis Rodas Sandoval -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac36')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Carlos Asis', 'Rodas Sandoval', NULL, NULL, NULL, 'operac36', '100000.FJwGNRIIaTfmnlU+Y9RvkA==.kGRHvmwyuBxcr/cnKxFaaYQJiO/7kIupy0Rg5nM1f20=', 36, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Elmer Alberto Espinoza Aldava -- Facturacion (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Elmer Alberto', 'Espinoza Aldava', NULL, NULL, NULL, 'finanzas10', '100000.YmuRqrYzAn4Lkfaa44Nhxg==.HWRuxcREkBXQAzsVi8I0UJoblJqrfq0Lm1fs49sQmjY=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cesar Ruben Lopez Rivas -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac37')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Cesar Ruben', 'Lopez Rivas', NULL, NULL, NULL, 'operac37', '100000.uj5BPGej0p6nVeJXgmukhg==.EPNpmMsi/TgUBLhA72QikrNLr2oMHzsSLoVTJ2LMmyg=', 37, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Nancy Liliana Inoñan Santisteban -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Nancy Liliana', 'Inoñan Santisteban', NULL, NULL, NULL, 'comercial11', '100000.m9CK+6e8skfVHzEjwkmKfw==.PdFdNhMahv/sugipN0EAswv1K4aOe5kLpDadfgAHefM=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Brayan Antony Quispe Taquila -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac38')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Brayan Antony', 'Quispe Taquila', NULL, NULL, NULL, 'operac38', '100000.lKZveK2MH0y0qX4fW/h4DQ==.dhG7RMBt5dkokOroK70bdb/y/ECaym+un7jMyn9HhNY=', 38, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ghelen Celiz Saravia -- Operaciones (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac39')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 75, 0, 'Ghelen', 'Celiz Saravia', NULL, NULL, NULL, 'operac39', '100000.eqYqO+wFJAov5Ji38rlg0w==.sJpONNO++NanrOKhF8fHoHH4HYa96Bc1QA+oyaoD+GI=', 39, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Aramis Angel Soto Aldana -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant21')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Aramis Angel', 'Soto Aldana', NULL, NULL, NULL, 'mant21', '100000.aa3zaiO9B0FvuiV4qrpQYA==.8acbEupq1uXGitZ45w8Gq5SL7ouq2APqihSQGp1FGdM=', 21, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ysabel Carmen Huaman Llarasca -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant22')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Ysabel Carmen', 'Huaman Llarasca', NULL, NULL, NULL, 'mant22', '100000.6D34RAj5N31/U+MRwOMBPA==.XpplZUjy65RLFyFKOchprBK7J4eESZp7nVnFaUAlKbY=', 22, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jesus Israel Gutierrez Avendaño -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Jesus Israel', 'Gutierrez Avendaño', NULL, NULL, NULL, 'comercial12', '100000.hDQHwGrueiTozpT2tkH+CQ==.36WCazLqiBPPfr1rUu1bhhVFFCs+QzALGLg2m4EkDJ8=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhoel Huamani Romero -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac40')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jhoel', 'Huamani Romero', NULL, NULL, NULL, 'operac40', '100000.LABlRpCU1m9+v9z+zH/ZXw==.yq7WPi9+XQO6QgNY06HJEzYRcmX+HFHUq+3e7n8poOg=', 40, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Dany Josue Lazo Murrieta -- Subger. Y Analisis Operaciones (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac41')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 76, 0, 'Dany Josue', 'Lazo Murrieta', NULL, NULL, NULL, 'operac41', '100000.AEpt/9k5YnlaF9SQJie2TQ==./IwjTSvDe7uuIhKsKhCfZBd1d11LJwg01CIo2jZiwyI=', 41, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lyz Mariela Zamudio Gonzales -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Lyz Mariela', 'Zamudio Gonzales', NULL, NULL, NULL, 'comercial13', '100000.GRYzLQ8byakXLzGYJmKYJw==.DJ8/6PRIJYjV907V91ke8aIPlyUWRNsERUKdj5aFtYo=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maria Yogana Aguirre Reyes -- Control de Calidad (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 52, 0, 'Maria Yogana', 'Aguirre Reyes', NULL, NULL, NULL, 'dirtec3', '100000.OqUoI9n9jXtFGSzQxOllcg==.GFh3OmUrh2zSkiSAV5r0UeZNIzlhzXyy4RE2Sjw+UKo=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Bryan Hector Cristobal Pariona -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac42')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Bryan Hector', 'Cristobal Pariona', NULL, NULL, NULL, 'operac42', '100000.CwiAegQ1/I6lDaxA+bdw0A==.qb1SX4NgRQotuJNMyYrTIArFYb+wo4vyXJ0AlhmSYt0=', 42, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Veronika Del Pilar Fiallega Montero -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial14')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Veronika Del Pilar', 'Fiallega Montero', NULL, NULL, NULL, 'comercial14', '100000.PCWO+twqDq4PWm/d8hEweg==.YPrCqCIPXtj7pzg083bkD8KZbgq+ngjOFtiraxpBUJc=', 14, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alfredo Benito Roldan Esparraga -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac43')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Alfredo Benito', 'Roldan Esparraga', NULL, NULL, NULL, 'operac43', '100000.aWXRZH6QssdTlC9YJqdLIg==./zxEMt/1XjyjbiyK/OWzHSpaxO6JGveqE/JfW7+0vp4=', 43, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Joseph Daniel Arellano Garcia -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Joseph Daniel', 'Arellano Garcia', NULL, NULL, NULL, 'compras8', '100000.omEIzdtb+hhPjIVQkhnQHg==.kRnVt6Zl7zmyV3UNRnSTcckIwM6+f8AVuuema+iiBNY=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gilda Rosmery Jaimes Ceferino -- Direccion Tecnica (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Gilda Rosmery', 'Jaimes Ceferino', NULL, NULL, NULL, 'dirtec4', '100000.OypjWZkN6Uyd3dJJvCNNOQ==.3tOWVHL1hyNpC6+iZA6hNWJsXjgL1BvACSUGf13LFB0=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Haydee Pfoccori Choyña -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial15')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Haydee', 'Pfoccori Choyña', NULL, NULL, NULL, 'comercial15', '100000.LCnaph7QE35PfUS8DdZ5vw==.5KwqoUPGSWUjj8qF+SinBmDBkW9xeegO/KmSjrenyW0=', 15, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gregori Jhonatan Gutierrez Avalos -- Adquisiciones y Abastecimiento (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Gregori Jhonatan', 'Gutierrez Avalos', NULL, NULL, NULL, 'compras9', '100000.E/LPMG0m/c2SXq4Mk6/8gQ==.5Ub5hfYg7/MpbnOMmhYcCD1YxIkdQ5AS9QkejyMdDLw=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Juan Leonardo Terreros Tenazoa -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac44')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Juan Leonardo', 'Terreros Tenazoa', NULL, NULL, NULL, 'operac44', '100000.M1JNvsfWcnABVuMzsB7zQA==.CShbkAc7L0OeGT3ZFEI/bAncizOVAJ+RosXO0UO8+bA=', 44, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhon Elvis Ttito Calderon -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac45')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Jhon Elvis', 'Ttito Calderon', NULL, NULL, NULL, 'operac45', '100000.UXqpHdwP9IKQDQ7teAF8WQ==.oJ+4Dd26SuupJEMDDj3aN5HA07RWcmgdKo9RSMfILtw=', 45, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jackelin Tomasa Roman Tello -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial16')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Jackelin Tomasa', 'Roman Tello', NULL, NULL, NULL, 'comercial16', '100000.l1lxeaHhZTUAPwnUE9AuHw==.DfBUNEzd3DaQRO8pYYBbth7hkLcc2vzrOi5XX+d15eA=', 16, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cesar Aldo Villavicencio Pinto -- Compensaciones (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh2')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 48, 0, 'Cesar Aldo', 'Villavicencio Pinto', NULL, NULL, NULL, 'rrhh2', '100000.aSXWK8F0aOGcze22Oc4iJQ==.e7NK243/NSWS2vQf6IL3oBxlzYG5yK9N3K32sG9B2lQ=', 2, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lizbet Erika Galindo Castañeda -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial17')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Lizbet Erika', 'Galindo Castañeda', NULL, NULL, NULL, 'comercial17', '100000.sXgX6C/27c7YBLKgIfH3bg==.YZ/AKSSb1Y0b23bXdm06xFJhVyJBWdHuvA9MHVZXPdI=', 17, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gilson Marcelino Quispe Vidal -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac46')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Gilson Marcelino', 'Quispe Vidal', NULL, NULL, NULL, 'operac46', '100000.w1/asDelVK2Cx4mBn8PIZg==.ks5roenPBo52iC3sr15ZwODqj4HC0QevPhJE2/l+jWc=', 46, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhander Jhan Berrocal Gomez -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac47')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Jhander Jhan', 'Berrocal Gomez', NULL, NULL, NULL, 'operac47', '100000.UyRFW3/kTKL0k9WIcFcvoA==.YXXYCq4iZKQFJvcDr0/wWTpBzNM32p1ZWfcqvWNApS4=', 47, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Junnior Damian Villanueva -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac48')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Luis Junnior', 'Damian Villanueva', NULL, NULL, NULL, 'operac48', '100000.Y17Kb9DR//5ICIc1WgmVnQ==.pPqpW3VOA30xGvnuap3d+9smDk4Mm9BCzd6Q+vZVjNY=', 48, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- David Noe Vidal Rafael -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac49')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'David Noe', 'Vidal Rafael', NULL, NULL, NULL, 'operac49', '100000.yd+Cc5/sstdq5k4cJjetXw==.9T7sWmSQcxxC56kT6M5euQwh7iDOiMgPXEb0CC9acW0=', 49, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edward Percy Gomez Ludeña -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac50')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Edward Percy', 'Gomez Ludeña', NULL, NULL, NULL, 'operac50', '100000.lBqJ5OJfwg6d30NL1jDMrg==.p6McfLHrMcgqVp7QFnRWfH934+bKFaeXJbY/z7evkG0=', 50, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Nick Randall Velasquez Rodriguez -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial18')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Nick Randall', 'Velasquez Rodriguez', NULL, NULL, NULL, 'comercial18', '100000./8/AyqpFPR0x2KUH6Own1A==.sPRXy1a/1PgR3WgDcNydGxTdtQgPExOVEmeI997kHKg=', 18, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Eugenio Conde Andres -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant23')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Eugenio', 'Conde Andres', NULL, NULL, NULL, 'mant23', '100000.OM23mClx+SGPR38DOfZb2w==./qrflxW3uteHxtsxk1O5MiRxA/w8AxWMT6QftULpEFQ=', 23, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Paul Cesar Ochoa Boado -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac51')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Paul Cesar', 'Ochoa Boado', NULL, NULL, NULL, 'operac51', '100000.Mb5tRk1sbn3kethVvjJoFQ==.zXxrUzn7U/AhbYT4NtRbLSlfl+jMKkuAahAuM9tZWT8=', 51, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Christian Bernardo Caballero Baldeon -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac52')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Christian Bernardo', 'Caballero Baldeon', NULL, NULL, NULL, 'operac52', '100000.Gp/8ptlAC0CLGBXudAw4tA==.kfAbhZfEJIFXnYr820kD3MQ88mKpk1yENYeqZltcmqs=', 52, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Camila Felicita Ventura Huarcaylata -- Comercial (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial19')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 62, 0, 'Camila Felicita', 'Ventura Huarcaylata', NULL, NULL, NULL, 'comercial19', '100000.WXa3wZZiby8ZLAX8qx43+A==.z9UIkggPdNWt4TP0upozdvrrg1wRxXKQKqk8J5/mNqs=', 19, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Fiorella Zacarias Ramon -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial20')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Fiorella', 'Zacarias Ramon', NULL, NULL, NULL, 'comercial20', '100000.sPgG79zMxrzg6Dp/7A7oug==.iuNqmeW7Ra5nfL3LWTjXIQ1OKdrKofCrfYocaSqXapQ=', 20, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Joseph Andrew Morales Barja -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac53')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Joseph Andrew', 'Morales Barja', NULL, NULL, NULL, 'operac53', '100000.Ss54QcLyyRKVqYvUj/hryQ==.CU5j/1MKoSniG/XsDc+tZ4jwN/DPIbYfCRGUFrFaksY=', 53, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Celeste Estrella Falcon Valdivia -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial21')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Celeste Estrella', 'Falcon Valdivia', NULL, NULL, NULL, 'comercial21', '100000.uyIYbyefNpZ+YdX8KWajDg==.gvzjVaWzG1i4ZhLJlcJvf3AXUIrrRAd5dweqcF60XCE=', 21, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mishell Vanessa Rojas Bueno -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac54')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Mishell Vanessa', 'Rojas Bueno', NULL, NULL, NULL, 'operac54', '100000.+wtdWx/3TuIdpEEJi7vb2w==.sgF0+2btTak9vNGH3ZbK52+WFSWgC5+eZvgAyQ45ya0=', 54, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marco Antonio Rojas Cerron -- Tesoreria (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'Marco Antonio', 'Rojas Cerron', NULL, NULL, NULL, 'finanzas11', '100000.zdvaPqfT3i7sFnIgirLINg==.YrN0n3ZnvlF9MQoe/BP7l2pO9zZXN5Nl6OGqcR6Bjr0=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edwar Alonso Chapoñan Huiman -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac55')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Edwar Alonso', 'Chapoñan Huiman', NULL, NULL, NULL, 'operac55', '100000.XsN0PybT6suWw033rf03zQ==.h7S5jKCy77ZRM+eTIwIZegjjqy+8SfDrXVo7Nyy8spc=', 55, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Hugo Ricardo Perez Ñaupari -- Mantenimiento (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant24')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 86, 0, 'Hugo Ricardo', 'Perez Ñaupari', NULL, NULL, NULL, 'mant24', '100000.4pxf1+lF5RJ3+/ZReuIPwg==.fZwj5dTaM3FiKmFODUKKuC+VCVDMzTDbSrIHdtuBPR4=', 24, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jessica Milagritos Ventura Sandoval -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Jessica Milagritos', 'Ventura Sandoval', NULL, NULL, NULL, 'gerencia5', '100000.tyaT4DXKyMKPRBKzVAd0yQ==.6Rr7q37g9dA6ntcdt/76zk0kTwkbUAJyrpnwm59yoek=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Vicente Abel Aguilar Bardales -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac56')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Vicente Abel', 'Aguilar Bardales', NULL, NULL, NULL, 'operac56', '100000.zCRz3pwY8etJP0FGFlp1Xg==.h4b+/pWZsI7sAbMwh3OmhcD4+qTKwMHb0mEo65TF7cg=', 56, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Zandalee Karl Farfan Litano -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac57')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Zandalee Karl', 'Farfan Litano', NULL, NULL, NULL, 'operac57', '100000.Wp2ex5N5l8syQ/woxVxNsg==.PppzfjcV1qq9auF/L2hJPcRIunmhaRJT/lK9oHBTKcg=', 57, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alexander Castañeda Aldaba -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac58')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Alexander', 'Castañeda Aldaba', NULL, NULL, NULL, 'operac58', '100000.P60HnpLf+sYSkpu7cAaHlQ==.SzKnJsidoIJtOIcyf8YeUbTWfzf3K65OfJG0tmJ2JRQ=', 58, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhordan Carlos Chuquiray Flores -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac59')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Jhordan Carlos', 'Chuquiray Flores', NULL, NULL, NULL, 'operac59', '100000.Na3fcwnGkpG6/rrKJzHS2g==.roxafb9SSG3SyVfw16JizmieFTM3bkMYdBYGbt/JXlw=', 59, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Oscar Orlando Paucar Ramos -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac60')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Oscar Orlando', 'Paucar Ramos', NULL, NULL, NULL, 'operac60', '100000.GSrf+mNVcJTOqJLKoMgaPg==.sL93ZLy5OfwH87g8PNU5RewymlaY7WecwOTWBgUj9F0=', 60, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Roly Ronald Gonzales Romero -- Control de Calidad (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 52, 0, 'Roly Ronald', 'Gonzales Romero', NULL, NULL, NULL, 'dirtec5', '100000.cqkWBF5ltgWB9S/PGsqNLQ==.9md5WyclkrIQ15m77jyepHxXWll0JL3r4V+ELqfxxK8=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jesus Alberto Illachoque Manzano -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac61')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jesus Alberto', 'Illachoque Manzano', NULL, NULL, NULL, 'operac61', '100000.xB/cjS/hNiC2hQY/cFmz2A==.vAYg70oFe9yohwli7Cp2uYFrxbWUCOX7a5HRAED4k3Q=', 61, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jetzabel Roxana Huanuqueño Obregon -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial22')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Jetzabel Roxana', 'Huanuqueño Obregon', NULL, NULL, NULL, 'comercial22', '100000.RsY/eDZn5d1zgfu3TIdfxg==.Ki1302XSKJHzJnoBavRjm1hh9WpZS241bKW2UxzNnWc=', 22, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Miguel Angel Carrion Marticorena -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac62')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Miguel Angel', 'Carrion Marticorena', NULL, NULL, NULL, 'operac62', '100000.4ZMdFx7xExK3uIAvp7VA+w==.oprK01pey+nQDPLj+3+PHUkYcYH7vUXWLEerRbvIVAs=', 62, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jean Paul Ramirez Rodriguez -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial23')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Jean Paul', 'Ramirez Rodriguez', NULL, NULL, NULL, 'comercial23', '100000.xgVxXglBTTpyIjTysFOJKg==.t/fjLOJ36sBDTZDLS3roVVpimQb5v+9nihYn+rxL7u8=', 23, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jerico Charles Aguirre Marin -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac63')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Jerico Charles', 'Aguirre Marin', NULL, NULL, NULL, 'operac63', '100000.E06vb4xU4DZvqFlE7gtB5g==.QeP5+D+o+/oeGh53z1khAS/znyyMHuurCwOa3mBcml4=', 63, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Clara Cecilia Becerra Sanchez -- Aseguramiento de la Calidad (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 55, 0, 'Clara Cecilia', 'Becerra Sanchez', NULL, NULL, NULL, 'dirtec6', '100000.vIvOvoshOotWQZOzbFw5RA==.W13KcxUWCVMgXO/E0iyHEeevwcwBfQDLpmKdBQ6jNaU=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Oliber Amerlin Chambilla Mamani -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac64')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Oliber Amerlin', 'Chambilla Mamani', NULL, NULL, NULL, 'operac64', '100000.OU49xV4rM5uu4pAYRNqnwg==.cVUdwYIIhH+IjPHStobSD1y+znzh9z9WAKwAThbu1Ow=', 64, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Russel Cristaldo Chambilla Mamani -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac65')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Russel Cristaldo', 'Chambilla Mamani', NULL, NULL, NULL, 'operac65', '100000.Wq1bMIELuypQHTBUnXyLmw==.fsDet5rRE24IOgFQVGSYQtWpsoTd0srDNlrZven/UyY=', 65, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mary Luz Miranda Rojas -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant25')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Mary Luz', 'Miranda Rojas', NULL, NULL, NULL, 'mant25', '100000.TQyoJTgFmNxoJkiqtEhosw==.lUI+ihmPE25tWIAkDNWplYCaTuTEBaPt3GCO32JIrrk=', 25, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Fredy Huamani Fernandez -- Contratacion y Desarrollo (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh3')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 46, 0, 'Fredy', 'Huamani Fernandez', NULL, NULL, NULL, 'rrhh3', '100000.FBqPnlk7Ua5pzWDlY9+23g==.MUg5tDV1gipsMtV4RBV9Q7ozKmT/M1OkrZhUMBsLa9o=', 3, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sandy Roxana Yarasca Yancce -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant26')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Sandy Roxana', 'Yarasca Yancce', NULL, NULL, NULL, 'mant26', '100000.25CLT7M11bBklU1N/9xUQQ==.1ftjNJKXvEJcswRaQsMnDp+wPBSiAZGO8V0QSnLnHmI=', 26, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Eder Sandino Quispe Cunto -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac66')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Eder Sandino', 'Quispe Cunto', NULL, NULL, NULL, 'operac66', '100000.SWxgumteuKyH4gif70Wp3w==.dEE9qQY3UKoXybWCOTKG6g/xiUmiMJQiUCFodZUTzqA=', 66, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilfredo Miranda Asillo -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac67')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Wilfredo', 'Miranda Asillo', NULL, NULL, NULL, 'operac67', '100000.KjvxumoFWI6Zi3B/X/9hQA==.bp+TJpcEXOWVJtxmKiSmtOsTS8ynqXxFvo31scFxeiI=', 67, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kathia Melissa Mamani Pucho -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Kathia Melissa', 'Mamani Pucho', NULL, NULL, NULL, 'gerencia6', '100000.ZKLzc2xEM8GsTk/DFh6NGg==.y3jCpNtGTJoyHaPeWJpj/dPxaoqgzf4Im86bmovZwIA=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maricruz Julia Bacilio Cardenas -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial24')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Maricruz Julia', 'Bacilio Cardenas', NULL, NULL, NULL, 'comercial24', '100000.ETjMWu9LKp1LiYwKpOluog==.1tCkNdWLXt914NMazM72gs83FzLlClWmkaMMA+eKFBo=', 24, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Damian Leoncio Alvarez Garcia -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac68')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Damian Leoncio', 'Alvarez Garcia', NULL, NULL, NULL, 'operac68', '100000.uSd/R5nC2sBT9IiROx0rug==.yKDuduFNm+eKGeQQQDMfunvPWHGPq0qRCh930enEUio=', 68, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marco Andy Cruz Cuellar -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial25')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Marco Andy', 'Cruz Cuellar', NULL, NULL, NULL, 'comercial25', '100000.zjjwnYOy32hptlLeouiKDA==./5ffKkzdYOc1RhUm3qjDSyEHlIf3efq7+0NwKnSBaYU=', 25, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Renzo Julian Huamancayo Quispe -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac69')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Renzo Julian', 'Huamancayo Quispe', NULL, NULL, NULL, 'operac69', '100000.Jf3MuYVTakMj3oyNWl8VrA==.am/w2j7zoAzDLr9KLwVIpWk59mX/GGVvd3XyCUkMjXo=', 69, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mari Cruz Nayeli Galindo Castañeda -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial26')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Mari Cruz Nayeli', 'Galindo Castañeda', NULL, NULL, NULL, 'comercial26', '100000.LXfdXzTPkfFTMKW8sNNFlw==.o6VnISaqTqm/yGgTNR5/e2sX5N91uPcDBvcfQrYUY3I=', 26, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Constantino Mejia Torres -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant27')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Luis Constantino', 'Mejia Torres', NULL, NULL, NULL, 'mant27', '100000.imbqb1RT1yJ0jlwb4KBj+g==.Eo10zSjcybvbNiC39aZRIoT6vL31jDPNx3xeXbstpuE=', 27, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- David Omar Peralta Espinoza -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac70')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'David Omar', 'Peralta Espinoza', NULL, NULL, NULL, 'operac70', '100000.JeYVcfWn12UcgWWO3xgUbA==.Z1TIOzEhLrUOAPtwmmoFNSOFudwBxQP07GrLJHYjZzk=', 70, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Rodolfo Gabriel Gutierrez Sanchez -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac71')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Rodolfo Gabriel', 'Gutierrez Sanchez', NULL, NULL, NULL, 'operac71', '100000.5PK7pxPdapAfIZf34hqNtA==.Pn034PKqAABp7SzWDsIQRoZoyIcAScu5RpG3NTQ2RlQ=', 71, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maribel Ramos Jamjachi -- Direccion Tecnica (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Maribel', 'Ramos Jamjachi', NULL, NULL, NULL, 'dirtec7', '100000.Q2ZZr1Nc3RtXhPiXOEwK+g==.I0mRvPSB1n+jqC4Le3aN3KrfgOM2VuzEbvDriWO2AXc=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhan Edhitson Ticona Quispe -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac72')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jhan Edhitson', 'Ticona Quispe', NULL, NULL, NULL, 'operac72', '100000.eEV7piN6pgCwG6JGFJQz2Q==.UuJFTViSf3pWhrbC42d9SAIES7B7ZeUyhBja7sQz6dg=', 72, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Judith Smith Cordova Lopez -- Finanzas (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 80, 0, 'Judith Smith', 'Cordova Lopez', NULL, NULL, NULL, 'finanzas12', '100000.O5oy/57sHUZ4s2uxcXD1XA==.Qx4GAlCR63leR+WOnN4GXQxBqwjUATKT1OjfgzcJfVE=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Eduardo Billy Alejandro Sotomayor -- Subger. Y Analisis Comercial (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial27')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 57, 0, 'Eduardo Billy', 'Alejandro Sotomayor', NULL, NULL, NULL, 'comercial27', '100000.Lqpwi6ePX4stzvJmUZ5O0A==.zGkljx9NRdrxv+EfY4LMj3Q3OIduuhzqm2b+bnA7g/U=', 27, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yorh Socrates Carbajal Ponce -- Mantenimiento (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant28')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 86, 0, 'Yorh Socrates', 'Carbajal Ponce', NULL, NULL, NULL, 'mant28', '100000.GG+AGymzwAXqOXb3q/c3cA==.Fi0XmBqGVag/E30rkapm0/18lHb/auw5wXdZuArnpgo=', 28, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Driden Rainer Bendezu Morote -- Subger. Y Analisis Operaciones (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac73')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 76, 0, 'Driden Rainer', 'Bendezu Morote', NULL, NULL, NULL, 'operac73', '100000.sG3TpPTAEGzkRr8GsGcGNQ==.8MzW/FVEuVtcRoBGjVu/bJUpTzLzw5EViVOgAKfPLPE=', 73, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilmer Luis Inga Cuadros -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac74')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Wilmer Luis', 'Inga Cuadros', NULL, NULL, NULL, 'operac74', '100000.UFAwJlaQrWR1cDS/hC4mJw==.SC6CKJx5/o0qOWt1oTZZ6r8jVUfX3uDRpaIloBuadYw=', 74, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilian Melendrez Calvay -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac75')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Wilian', 'Melendrez Calvay', NULL, NULL, NULL, 'operac75', '100000.x4ES5ZzClr8a6LFcqk87DA==.QLRsZ5PSR2fCWKIuBB/dUzZuuAKmAM1rN58s6B1DtPY=', 75, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alvaro German Otarola Pongo -- Compras de Existencias (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 43, 0, 'Alvaro German', 'Otarola Pongo', NULL, NULL, NULL, 'compras10', '100000.heBizQcj5Ie750a/v6sYtA==.se9tW4OccjYYEFX42VF0mFFgP39OYUv6OLPSYWuC3Us=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maribel Elizabeth Quintana Saldarriaga -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial28')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Maribel Elizabeth', 'Quintana Saldarriaga', NULL, NULL, NULL, 'comercial28', '100000.ku7UqUjuHmLrg1R0eHmfDQ==.lw99LQbH0Mdl+VNvfyPFel/LHgdzPQiFccXbMxodfL0=', 28, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Katherine Milusca Vera Valderrama -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial29')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Katherine Milusca', 'Vera Valderrama', NULL, NULL, NULL, 'comercial29', '100000.KuAecWwJKABYoEQld3ThPQ==.gH6Je6gBVO8T53p3JkPg+x8m5Q0f3+3Nk9CUhqgMMy8=', 29, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Alberto Camacho Benavides -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac76')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Luis Alberto', 'Camacho Benavides', NULL, NULL, NULL, 'operac76', '100000.VVWLX/z2i4Rz2gb/zSl4Ww==.FwUUl235Es7bgXbsMcKy0A8R3TNKBvpFsn/3X1py/mU=', 76, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jennyfer Lucero Carrascal Lozada -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial30')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Jennyfer Lucero', 'Carrascal Lozada', NULL, NULL, NULL, 'comercial30', '100000.czbo0i4y8XcyKo6AIusTIA==.IaZrpqiUR25NQUHaOaiM6YpuCf9iRMVogmf6ISXfwlg=', 30, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jeferson Chumbimuni Pampa -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac77')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Jeferson', 'Chumbimuni Pampa', NULL, NULL, NULL, 'operac77', '100000.YESowHR3FoZMvScvtVXB5w==.HtvoyHf6zJ1jJffwekVFSVwSII17tRCKqIf7ONBGs7s=', 77, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Carlos Damian Aldaba -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac78')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jose Carlos', 'Damian Aldaba', NULL, NULL, NULL, 'operac78', '100000.MYVZFpzrKush0Iu9B2EOEQ==.B8tPkuBShWnXZXI8sW4IjN9KVSALKnxmz6KJUBmfvmM=', 78, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Percy Alberto Fernandez Galindo -- Subger. Y Analisis Compras (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 42, 0, 'Percy Alberto', 'Fernandez Galindo', NULL, NULL, NULL, 'compras11', '100000./OhM80ugCxHeR1tnU5JyKw==.ZUHhQIAL1W7o+0tjjzS5hOx619JuSPXdCkNey5txQWA=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- William Alfredo Muro Dioses -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac79')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'William Alfredo', 'Muro Dioses', NULL, NULL, NULL, 'operac79', '100000.YswBrQR71KM2Tp+4o1OGuA==.fSYeXVI9PYrCimu78Zx65Vv32zjvOVg3vZ0jfg5V//Q=', 79, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cesar Eduardo Vasquez Ascona -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac80')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Cesar Eduardo', 'Vasquez Ascona', NULL, NULL, NULL, 'operac80', '100000.t7VPnXSlwx+aevETiNtUXw==.6TEdkY68dLzXblHumt6LRQXq9hoq7kmni6y3Q2Gn7dw=', 80, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marcio Elias Bardales Tuanama -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac81')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Marcio Elias', 'Bardales Tuanama', NULL, NULL, NULL, 'operac81', '100000.uzgBQ0TJtFmpfXECc+FblA==.vVCVTdpyBPzRqCpPouLLwUwsfzA22qV2JrsRPBAP9z4=', 81, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yesenia Yerin Ayllon Collahua -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Yesenia Yerin', 'Ayllon Collahua', NULL, NULL, NULL, 'admin9', '100000.vqz8afhM4fsI7i5RS6blww==.j/eQgNBe78CvSDxocphKeDGFfS43ekx5hrj7wGEIgv8=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carlos Esteban Perez Reyes -- Limpieza (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant29')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 84, 0, 'Carlos Esteban', 'Perez Reyes', NULL, NULL, NULL, 'mant29', '100000.ouq2qfyfy087LGoI+QxiyA==.09k2wc64najcRjCbvt/zpY8SBTx4aayfVlnDNzP66Mw=', 29, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Claudia Soza Vilchez -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial31')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Claudia', 'Soza Vilchez', NULL, NULL, NULL, 'comercial31', '100000.H+GTdj/eT8xJySd2YlVLYQ==.b1CI8AP12chy5a8W1Mo3r+sbjiEuGPdfZqpyDqvZNNE=', 31, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Richard David Venegas Walhoff -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial32')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Richard David', 'Venegas Walhoff', NULL, NULL, NULL, 'comercial32', '100000.wAYvYEsmEXi5yKdioFvJ2w==.5BjGIDjVp24ZCAVhGcRLtc0Wnbobccq0d7gsI1Jyfsg=', 32, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maria Rosalina Ventura Sandoval -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Maria Rosalina', 'Ventura Sandoval', NULL, NULL, NULL, 'gerencia7', '100000.XZ/yJx7NMGwhBrLotm0wzg==.q8U4rODwapCDTZ3UIXXUu8hHlhFbhTEwXLMO0xQjFhk=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Pedro Luis Zapata Sosa -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac82')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Pedro Luis', 'Zapata Sosa', NULL, NULL, NULL, 'operac82', '100000.PQRsNrwE/vjE3qjy716Y/w==.NwseRShTrZqytnAXlPNQ+luPVChvmco4awiuFN3Ucfo=', 82, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Richard Bryan Martinez Capcha -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac83')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Richard Bryan', 'Martinez Capcha', NULL, NULL, NULL, 'operac83', '100000.xT4MGe2+lMb4YxS0rPsPzw==.1qTay6YCG6aJRnlfvIUWyWaq9a8g+3osIHVJ3rNEinc=', 83, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ronald Alexander Poma Ruiz -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac84')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Ronald Alexander', 'Poma Ruiz', NULL, NULL, NULL, 'operac84', '100000.OcEoGHQufSngV2avBRuuXQ==.wVRFWHg7HjWm8C4VqupRy1r58zRpSBZSCyyo5bBs9gg=', 84, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Leonardo Miguel Sarmiento Romero -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac85')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Leonardo Miguel', 'Sarmiento Romero', NULL, NULL, NULL, 'operac85', '100000.8xTjQMo1CnTYu0GjHVl76Q==.Dqe4rum6+hfEuyCbQuQUi8YlTibzxMBA1dOf4Qtp6Xc=', 85, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ronald Antonio Flores Flores -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac86')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Ronald Antonio', 'Flores Flores', NULL, NULL, NULL, 'operac86', '100000.09PMKefOTYGdXYctcKAmbA==.2KoPl5IvBS/93yJ/ozTRSyDUpeI2/ml0etp0GoX/3Ws=', 86, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Daniel Gerson Auccapoma Hijar -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac87')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Daniel Gerson', 'Auccapoma Hijar', NULL, NULL, NULL, 'operac87', '100000.KLajV6kCKXTWb1J3KsSmlQ==.QptBYmffxh6eHaqrdjvIU91CbyCQDWUl0FuqPCapHb8=', 87, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kelly Victoria Murayari Pacaya -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial33')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Kelly Victoria', 'Murayari Pacaya', NULL, NULL, NULL, 'comercial33', '100000.ILKHJy+sZSnfAp+UsS91rA==.jTDoOH/zK5MovM6yygHdKsxeMc68zK/y6W6Zo+BhowQ=', 33, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Diego Eduardo Flores Cardenas -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac88')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Diego Eduardo', 'Flores Cardenas', NULL, NULL, NULL, 'operac88', '100000.dRR//qw7ftqRoBauYFKmdg==.Ouhpwma2rWyJcdwl/A1/1Uv6uOZxB4ElS2CDU7uTE5g=', 88, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Luis Pezo Mozombite -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac89')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Jorge Luis', 'Pezo Mozombite', NULL, NULL, NULL, 'operac89', '100000.bUPDA/o/p1wY/Ye3Q9Lw3Q==.fYPyEUKwBcBRXu4smJ8uvj6kWI6hY4dgV5ISMkykCnY=', 89, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Melissa Elizabeth Huarcaya Figueroa -- Sub-Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 92, 0, 'Melissa Elizabeth', 'Huarcaya Figueroa', NULL, NULL, NULL, 'admin10', '100000.Ux/sYtx9YUb26lsM++Zddw==.1TIWv6xfcVTiJn8zOxtPe6R1tRxRoZNDOTEzFaMpeIk=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edin Onan Leyva Saucedo -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant30')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Edin Onan', 'Leyva Saucedo', NULL, NULL, NULL, 'mant30', '100000.C6aauqeHsNd7ABvUjo1ilQ==.O3UXsjYx0+MrD5ckGFcBmD93eUV7GfJwi70y7TqLeCk=', 30, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alex Shupingahua Sangama -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac90')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Alex', 'Shupingahua Sangama', NULL, NULL, NULL, 'operac90', '100000.ewKMD4YlP/Dw0gMAm0NGEQ==.K/hyJFwRp1zqHV2GKlPCUYFCUcrvv9wEJGAYdy/CLag=', 90, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Bryan Rogger Mamani Palacios -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac91')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Bryan Rogger', 'Mamani Palacios', NULL, NULL, NULL, 'operac91', '100000.I44MeEEkfs5L0gdzk3Q1nQ==.EMrKPMkR+StbCY6BRllxGAJTTXoACh6HI6xbBGbqPRk=', 91, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Susel Geraldine Castillo Ventocilla -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial34')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Susel Geraldine', 'Castillo Ventocilla', NULL, NULL, NULL, 'comercial34', '100000.bvhBFr8WAwOb4diNwMR2pQ==.K0iCHpiIFzKbIZDMxCcvMnKBT9ME4bDgYNJ1XLrohhY=', 34, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jair Mateus Egoavil Torres -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac92')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jair Mateus', 'Egoavil Torres', NULL, NULL, NULL, 'operac92', '100000.pRDzPqy2jWFev47LLF7u2g==.EtylUuza9dcydqIKGVCBXEOcAvnVIHzPBFdwMZL/ppA=', 92, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhonatan Alexander Villarroel Huamalias -- Facturacion (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 79, 0, 'Jhonatan Alexander', 'Villarroel Huamalias', NULL, NULL, NULL, 'finanzas13', '100000.KfkM5owhJdGaQsyuH2RWFA==.DyJbhsI4YesCr/S6GL7bLTERBc80Uy/7MSIUT3smYZE=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gerson Alexis Robledo Mamani -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac93')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Gerson Alexis', 'Robledo Mamani', NULL, NULL, NULL, 'operac93', '100000.MspksJPvsbC7FJwFgGT4Og==.D8Dc/qXrzxB5r8oNabQg8myBSRTlJ2VVm8/0CwtHAhU=', 93, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Angel Canchumanta Macavilca -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac94')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Luis Angel', 'Canchumanta Macavilca', NULL, NULL, NULL, 'operac94', '100000.QLoFpb5bGq/1AMUnzPFfbA==.JcF5chXW8vU387IiVVaZICSrsq2rOvlcmbqpxh9ubic=', 94, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jack Michael Minaya Calderon -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac95')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jack Michael', 'Minaya Calderon', NULL, NULL, NULL, 'operac95', '100000.8dbAdfTTj3uHLXYDO8zFmQ==.s5XfeibUL2fMr8K9nzs3BicuFOkBIDmhOcneDa/XqvY=', 95, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jean Marcos Cirilo Achaya Solorzano -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac96')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jean Marcos Cirilo', 'Achaya Solorzano', NULL, NULL, NULL, 'operac96', '100000.fhdCXOc/5rUcZSeAxo2b3g==.OU/mMVR4BaExK2JwCgPuT5lRWCW66P+fj/qS5VXsoN8=', 96, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Alberto Rojas Toledo -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac97')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jose Alberto', 'Rojas Toledo', NULL, NULL, NULL, 'operac97', '100000.RSDpnWtMp8KWGkqCMXZhZA==.T9PhAVgyJQLNN9/QsMu7Es/Bq0b7cmDVsSzN9mEXeEw=', 97, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mariela Escurra Ayala -- Aseguramiento de la Calidad (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 55, 0, 'Mariela', 'Escurra Ayala', NULL, NULL, NULL, 'dirtec8', '100000.qIrb+bbJwf26JwcyPNrVew==.DeJ8Un/k30tl0ypFvC29m9OJQTniGCkRQC7PiqIwkaU=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gin Al Jhonatan Caso Castro -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac98')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Gin Al Jhonatan', 'Caso Castro', NULL, NULL, NULL, 'operac98', '100000.vZjluECdjPxXHaVHMADwYA==.d4mx1UQy0zJRo1OeRd+oxolcZodbXgv2MnuJtEo7lFY=', 98, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cristian Noel Huayta Villegas -- Adquisiciones y Abastecimiento (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Cristian Noel', 'Huayta Villegas', NULL, NULL, NULL, 'compras12', '100000.CC4dS7QCs/IqaPnuo2ZbSQ==.S0rKIYfRhV6QRRb/svPVasvC8lLnPhN8DAKelpveNiw=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Adolfo Hitler Reyes Ramirez -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant31')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Adolfo Hitler', 'Reyes Ramirez', NULL, NULL, NULL, 'mant31', '100000.2YTnCsJU2jYHwoGEmg9jYw==.MqLeJccYXukZiZ7mDkWXhdm/GYQHKT/cVIA3hCyIpZw=', 31, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Luiz Cumbia Ramirez -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac99')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Jose Luiz', 'Cumbia Ramirez', NULL, NULL, NULL, 'operac99', '100000.TB1+CQtTGHee9XkwOlPSeA==.XXL8LNhcncJoYtJeKUPF9itTIAStD1CF3fg3CUCCP/I=', 99, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Marvin Carlos Gonzales Ruiz -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac100')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Marvin Carlos', 'Gonzales Ruiz', NULL, NULL, NULL, 'operac100', '100000.8XbsGOMa/bNkRHKzZAoYjQ==.ISOep5SsTEY8Yb7zTDck8m6mA606Eg215s9nqH1W2+I=', 100, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sebastian Oliveros Mitma -- Recepción y Control (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac101')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 70, 0, 'Sebastian', 'Oliveros Mitma', NULL, NULL, NULL, 'operac101', '100000.fU+mn3AhHOTNsNYjhC5S5Q==.T6Db5D5/pVcxzzSvb/3eLUKGpSrBlnkq5IWIIu4niBk=', 101, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- La Cruz Marcos David Ramirez De -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac102')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'La Cruz Marcos David', 'Ramirez De', NULL, NULL, NULL, 'operac102', '100000.PKcLoXIWENJG8KfRIpynyw==.nQmulBrw3IPy61vOskr+oyJiIb6V/k2OUW2B8wTjvWQ=', 102, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Daniel Santos Apolinario -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac103')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Daniel', 'Santos Apolinario', NULL, NULL, NULL, 'operac103', '100000.e2YaYjmC4lWdEdp24xIgoA==.c/v32vys3G6OWUlFMtS5xQ6Mz3gmDlPZDRwytYdh/ro=', 103, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- La Cruz Mishell Allison Paucar De -- Marketing (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial35')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 61, 0, 'La Cruz Mishell Allison', 'Paucar De', NULL, NULL, NULL, 'comercial35', '100000.0sjDX8B7TBsS9ugqlkBlhQ==.qYJ6JJpXCyszLnuh93kTiqf8blnklTXOiCxk1XfgVgE=', 35, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jonathan Michael Puris Naupay -- Seguridad y Salud en el Trabajo (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh4')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 49, 0, 'Jonathan Michael', 'Puris Naupay', NULL, NULL, NULL, 'rrhh4', '100000.MVQSpPi1IyjrvJv06bcnFg==.YlRVRkprIEx5UHxj7MgmeMWUvOWrE7QpSqf/pgKclhk=', 4, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yamilet Blanca Zamudio Gonzales -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial36')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Yamilet Blanca', 'Zamudio Gonzales', NULL, NULL, NULL, 'comercial36', '100000.NicJvKJd+6q69n5yo69jpw==.97yd8eQ8grObL6o2of242ZlxtYNunS1CBn0aiv3oHIE=', 36, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Miguel Angel Fabriccio Villalobos Picon -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac104')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Miguel Angel Fabriccio', 'Villalobos Picon', NULL, NULL, NULL, 'operac104', '100000.XmEFqutHvM6usPRSIndN9A==.6xmU9gvflirTMxiLevO9gFvxOAtb63+5ug4D5atWyns=', 104, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Mayron Serquen Quispe -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac105')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Luis Mayron', 'Serquen Quispe', NULL, NULL, NULL, 'operac105', '100000.Jk5WU5wrrrg4bC6QhKsC7w==.1zVbkpuLp2BTCIXeGMsm0BS63CxoXBhTXuyL7bprCP8=', 105, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yaicate Lincolns Wicherry Del Aguila -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant32')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Yaicate Lincolns Wicherry', 'Del Aguila', NULL, NULL, NULL, 'mant32', '100000.TC6df5uRzebN05ZIpwnaQw==.thGHxRE9MId1z7O0hLA1P8umyoSehxWUFmJhkbMnHKg=', 32, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yorelly Milagros Vinces Chumpitaz -- Operaciones (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac106')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 75, 0, 'Yorelly Milagros', 'Vinces Chumpitaz', NULL, NULL, NULL, 'operac106', '100000.jYw8MJRv9QhMrGqdm5S4+g==.eTWuVFPW7iiefRHMdnnS9nO+rLi5eg9TlLEpW20MIwY=', 106, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Frank Jhordy Bonzano Bustamante -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac107')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Frank Jhordy', 'Bonzano Bustamante', NULL, NULL, NULL, 'operac107', '100000.lyv1A9Hkj/F512lWfuwovg==.NdIuBDDMPPrvgzdcdPdlVN6zs2RxzEuimVqkdhh8ik0=', 107, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lenny David Inga Miranda -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac108')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Lenny David', 'Inga Miranda', NULL, NULL, NULL, 'operac108', '100000.WJiNGzwUn5Jph/c8Md3Ghg==.rbAMJFmOlsTWwDDjPSHSZkm3BTHZ4YtT0JwaDq+l4nA=', 108, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Manuel Siesquen Bances -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac109')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Manuel', 'Siesquen Bances', NULL, NULL, NULL, 'operac109', '100000.wriEbADrmQ9pQ7JPX9sDqw==.br4OCeBqCG9R3UAUn01q4ggzWGyNSep8B9rryFCbvnE=', 109, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Natalia Carolina Huayambe Lopez -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial37')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Natalia Carolina', 'Huayambe Lopez', NULL, NULL, NULL, 'comercial37', '100000.kh5V+I0OF2aJm1WeuJ5vWw==.T7qsuuyJ/qShkiKS8I9zZv4oXeLyKOeW+DeJF/egq0o=', 37, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Asuncion Barraza Flores -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac110')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Jose Asuncion', 'Barraza Flores', NULL, NULL, NULL, 'operac110', '100000.DSIu1O437ojfK06SFow7NQ==.vC298eFYVg+bbwXdU9GBsYbHQCDY9sEFfQMW1hhmOvA=', 110, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jonathan Eladio Berru Vasquez -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac111')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Jonathan Eladio', 'Berru Vasquez', NULL, NULL, NULL, 'operac111', '100000.o1gg02GH+dPKah6CEWGEBQ==.9fa1jNmeBrjKumtkfg1wmOWsuxkPPntApkyRvmLCFRA=', 111, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Michael Castañeda Aldaba -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac112')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Michael', 'Castañeda Aldaba', NULL, NULL, NULL, 'operac112', '100000.PaWrdfUyYXFJ/rJND4DMww==.7BvmWY4xkRfvU8BzXo5Z5IQdYxYUztQFk2XAt6+A1FQ=', 112, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gerardo Axl Francisco Vento Morales -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac113')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Gerardo Axl Francisco', 'Vento Morales', NULL, NULL, NULL, 'operac113', '100000.ZLT4h5ivpUEYX6/ME/O6MQ==.JlVfOrIVdshiFJNfTAc8ah1MjMqDWum+BjUcwz6Q6Xk=', 113, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Aldo Pacuri Muñoz -- Comercial (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial38')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 62, 0, 'Aldo', 'Pacuri Muñoz', NULL, NULL, NULL, 'comercial38', '100000.gr2er2S9RSZJaah5IXgCOQ==.UcTtq71StTLVb+W25AruMFXfUthq9Dsvm1b1eHAiyUc=', 38, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Israel Daniel Villanueva Maldonado -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial39')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Israel Daniel', 'Villanueva Maldonado', NULL, NULL, NULL, 'comercial39', '100000.ENEa/e5cfsc9UMTYNiZbQg==.QpgJ611gyvI4uU92+tSDQyawdXE1gW7BDVyhx1MT5D4=', 39, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ketty Jovahana Yañac Soto -- Control de Calidad (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec9')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 52, 0, 'Ketty Jovahana', 'Yañac Soto', NULL, NULL, NULL, 'dirtec9', '100000.7D8OTKhD2BlD42yWVdXl1Q==.SWqNxTjKx1z3WUBbO0M6kikje2nVd3VjNG3/TEcnI5M=', 9, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Luis Francisco Requejo Loarte -- Marketing (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial40')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 61, 0, 'Jorge Luis Francisco', 'Requejo Loarte', NULL, NULL, NULL, 'comercial40', '100000.ROBvo7CCvr5Y59RE8HEMmw==.apJmJEuNiqy++gHaEDPZ6qtOnfSCAGx7duuUU45ytDo=', 40, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Isaias Janampa Bañico -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac114')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Isaias', 'Janampa Bañico', NULL, NULL, NULL, 'operac114', '100000.2OjerBmpkbE6OYZGKso90Q==.pKH13Pi5Mih+pi02U7W+g33NHflhhuiq0cff7QxLTmI=', 114, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sandra Paola Oros Bendezu -- Reclutamiento y Selección (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh5')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 51, 0, 'Sandra Paola', 'Oros Bendezu', NULL, NULL, NULL, 'rrhh5', '100000.Nju345tgMbn5imPUooyrPQ==.CrYbzlRtjgsbRWF4bsszlHoAFfuZZEkajIq4l2OyndE=', 5, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Karen Jasmin Mamani Chambilla -- Gerencia General (Gerencia General)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gerencia8')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 87, 0, 'Karen Jasmin', 'Mamani Chambilla', NULL, NULL, NULL, 'gerencia8', '100000.NsN33tW6R2eOVSGBFURpow==.JrENhI+xEFprCw9Ic1h2POMRQzKgR69SQMEyHUufBi0=', 8, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Heather Aileen Aguirre Miranda -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial41')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Heather Aileen', 'Aguirre Miranda', NULL, NULL, NULL, 'comercial41', '100000.+2H47KbyxtcaX/0Dyq5fIA==.kSM7R/fc3VRnJPESlKVb+kLJuhKKsP+rHdU+P0ztPVw=', 41, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Daniel Esteban Andia Levano -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac115')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Daniel Esteban', 'Andia Levano', NULL, NULL, NULL, 'operac115', '100000.LC2pSDsx28pvsYRACSDszg==.YAXnbvGEH9JU31qRVlVY+AyrZCSVilHssYVlfZzDyqo=', 115, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jairo Joao Curi Ordaya -- Distribución Provincia (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac116')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 73, 0, 'Jairo Joao', 'Curi Ordaya', NULL, NULL, NULL, 'operac116', '100000.iDhe7DvqSW05D54SuzguSA==.C4re5kwYQ5II7SH+cSbgLv+ge5qpi3AGdAe1wIw14Hw=', 116, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jose Jhonatan Vasquez Diaz -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac117')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jose Jhonatan', 'Vasquez Diaz', NULL, NULL, NULL, 'operac117', '100000.juYko7grx1KdGPf9s3YY/g==.i6FMIzhvm4+dFqzWCuIyosXLNFF0vE7mcCMpws1xqPY=', 117, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Omar Davila Rodriguez -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial42')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Luis Omar', 'Davila Rodriguez', NULL, NULL, NULL, 'comercial42', '100000.CkBxhfK6ZnidXkmxaPDDlw==.TK/CvCAE5PgFmVGArIT+q2IxOKg1lOquc3ALot6o2vc=', 42, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carlos Concepcion Larrea Reyes -- Seguridad y Salud en el Trabajo (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh6')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 49, 0, 'Carlos Concepcion', 'Larrea Reyes', NULL, NULL, NULL, 'rrhh6', '100000.iJrSMSk7md44QfnqZmUVVA==.JvGXCp0Lu/3vjXnZcWlqPcb8g8aMdX3p1TYPZa1lMtk=', 6, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carlos Manuel Valentin Blas Chaupis -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac118')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Carlos Manuel Valentin', 'Blas Chaupis', NULL, NULL, NULL, 'operac118', '100000.WMBMIGvhxW4cE1QT2JWaNw==.tvcsY2CN3X7a3fzdbyZlr5BPcEyxzUcvhnDz2RWqdVo=', 118, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- David Lozano Leyva -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant33')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'David', 'Lozano Leyva', NULL, NULL, NULL, 'mant33', '100000.TlK/E6H6TFewCG24RiQe6g==.Xx3W7sa5qY04KwfbHlh+9BhsR7BE6Aeo5YxGk1n0nXs=', 33, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jefersson Yaren Huamancha Maldonado -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac119')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jefersson Yaren', 'Huamancha Maldonado', NULL, NULL, NULL, 'operac119', '100000.zeqDB4SNpLXNivldM462kA==.o4Icxuq5nOsG0xZS3ZMQojanXV4C4LemPEuMV4aEfbg=', 119, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yessica Seleni Gonzales Vallejos -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial43')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Yessica Seleni', 'Gonzales Vallejos', NULL, NULL, NULL, 'comercial43', '100000.y1QF/l4FyWsUxvIhagqqIg==.JXrq930wXTDMQR29TD3i5wEmFJI3AI2IMqtMBC++ZfE=', 43, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Arnold Rojas Amoretti -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac120')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Arnold', 'Rojas Amoretti', NULL, NULL, NULL, 'operac120', '100000.NvHulEhKtM6CFXJlWOhT8A==.d2ZLM+1SMRx+mpJino7jDk1xSRkAuZ+MBVa9U3Cvb2A=', 120, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhoana Smith Cuadros Flores -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac121')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Jhoana Smith', 'Cuadros Flores', NULL, NULL, NULL, 'operac121', '100000.Xu2SR+XBUEaM2Rs1kk9+Iw==.jD2ISsy/7eqvdy9Ts3xWpLf0FKQMBWxst1WALPL/7Mw=', 121, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhonatan Adrian Chavez Flores -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac122')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jhonatan Adrian', 'Chavez Flores', NULL, NULL, NULL, 'operac122', '100000.ilIrpbJOfXRlYTi8SIhh3g==.yJIpaXG5f6S1OSQbLg8qHiOqsqtTTcwAc+T4HchfRos=', 122, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Maely Ismelda Mamani Quispe -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial44')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Maely Ismelda', 'Mamani Quispe', NULL, NULL, NULL, 'comercial44', '100000.veNgkJ+MivlV++ID6qKxkw==.ZjOuUsNINQrw6TMvnyzJiNA6XyfkHkYfomLOWrRNME8=', 44, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Saul Antony Mamani Quispe -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac123')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Saul Antony', 'Mamani Quispe', NULL, NULL, NULL, 'operac123', '100000.DWlCffjNjsiY2kWxTxzCfQ==.EPComEg8x5i3yvefKiqBYHM0In9qwkDB+jdUDJybYY8=', 123, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cruz Escriba Angelo Eric De la -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac124')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Cruz Escriba Angelo Eric', 'De la', NULL, NULL, NULL, 'operac124', '100000.SPOjk+prRV2kEMinYTpD/Q==.RgiakEU0FlrCYmCHeuKN/yWUMx7E0DflTBOPCZ4Zi5s=', 124, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lizz Anhely Mamani Machaca -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac125')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Lizz Anhely', 'Mamani Machaca', NULL, NULL, NULL, 'operac125', '100000.+MDfhsGKQnRLxXKITkvU2w==.kGKn9anLDIt1D5KFsF+BuKmX3wyP0Tdbav72ctZhPYw=', 125, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Manuel Enrique Jimenez Ramos -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant34')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Manuel Enrique', 'Jimenez Ramos', NULL, NULL, NULL, 'mant34', '100000.mk/EoxAmzd0HUsZpT9mL0w==.kicy4+NqlAMUTtP5qP+4RcTpA9tqP3dXrID71O8t2oE=', 34, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Angelito Durand Prieto -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac126')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Angelito', 'Durand Prieto', NULL, NULL, NULL, 'operac126', '100000.PyXgLXKEgVVBuamDF31gTw==.Arp7saRqM1HZlazb2T6KI/AxsmB3jiYyGsAhwVGwy2c=', 126, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Salvador Manuel Yarleque Martinez -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial45')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Salvador Manuel', 'Yarleque Martinez', NULL, NULL, NULL, 'comercial45', '100000.g1Ipe+HmC7EPUkdNpmnO4g==.wrIAycSf3fNG4Su6WlfcKrdJvnJ+2Y0YxHf4np+11Fo=', 45, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Sebastian Castro Humpiri -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac127')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Sebastian', 'Castro Humpiri', NULL, NULL, NULL, 'operac127', '100000.f/5JDmEpLbiujGucqH7dGg==.fSa4HH9GGwCvdr45xgYb1VjEgFSpSlrj50KM9AVyOLw=', 127, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Brayan Beder Portilla Lliuyacc -- Adquisiciones y Abastecimiento (Compras)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'compras13')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 44, 0, 'Brayan Beder', 'Portilla Lliuyacc', NULL, NULL, NULL, 'compras13', '100000.OaxwczjP5J7vx+68hzJPcg==.cPYyneE3nrpwoaBjmM7f6EQW2+0OmrstpUP0beuUzxo=', 13, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Miguel Adher Sulca Espinoza -- Preparación de Pedidos (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac128')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 69, 0, 'Miguel Adher', 'Sulca Espinoza', NULL, NULL, NULL, 'operac128', '100000.Dm30mAvtY9b+YGKN+ddeMA==.pfOFG3lnaZEIl7t+B2Or+mItFNDqZ2I18fw4TlCHalI=', 128, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Nicolas Cabrera Fuentes -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac129')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Nicolas', 'Cabrera Fuentes', NULL, NULL, NULL, 'operac129', '100000.EKezBzKlZsohTbSoX1Hf2w==.Xx5cEwK4P0FE9MwDBvx9gH4oUDHibX/4EG5noUg3+Z8=', 129, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jefferson Juan Vega Mendoza -- Infraestructura (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant35')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 85, 0, 'Jefferson Juan', 'Vega Mendoza', NULL, NULL, NULL, 'mant35', '100000.4IOekHVXzU5TZrwhMoE4wQ==.FgYjORwQsg9XIvEMT38WRQ7Q709trkIQaNQ1RymTPTQ=', 35, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jason Luis Huaynamarca Morales -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial46')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Jason Luis', 'Huaynamarca Morales', NULL, NULL, NULL, 'comercial46', '100000.oEd76xXG3piJoKmLLfFBSw==.4sshN71AbtPjABgYNgXMKaWcE1UYwlLIE4psHIQHqlQ=', 46, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Yashira Sixta Soto Torres -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial47')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Yashira Sixta', 'Soto Torres', NULL, NULL, NULL, 'comercial47', '100000.bym/4sSnBn5UEP4ZHCDAzg==.7FCzJk2g2xFch74Ry6qfOU/wgsatRtp1CMg3t4NOfas=', 47, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Betty Eliana Pacotaipe Vargas -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial48')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Betty Eliana', 'Pacotaipe Vargas', NULL, NULL, NULL, 'comercial48', '100000.LqJk4qQPHAv53mi6Sdqv7A==.7TrqWLQNLTGcwfkIq4N7ow1eL+VS6RAXb3XMud33pqw=', 48, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Nicole Adela Rojas Segovia -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac130')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Nicole Adela', 'Rojas Segovia', NULL, NULL, NULL, 'operac130', '100000.6xQ1B0e9mUTTTzrW9IuWaQ==.DOnLh5aASCew34XKGN2YQKKFz/xyzzQdrV3Om8duMqQ=', 130, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhoel Villalobos Fernandez -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant36')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Jhoel', 'Villalobos Fernandez', NULL, NULL, NULL, 'mant36', '100000.ni+E2hJHsYxVTWTNzEkjEg==.f/2NOpL5r/l/8aNVyO9T2XbdcZDfQRYz/OtAmffKVDA=', 36, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Tashina Aolenka Mejia Soto -- Bienestar Social (Recursos Humanos)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'rrhh7')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 47, 0, 'Tashina Aolenka', 'Mejia Soto', NULL, NULL, NULL, 'rrhh7', '100000.mMsQ2oE3mBhL+Tx8ZyZJbg==.3qTelzED4Dc3PceD6+xQBajAiGCg9Xe9pig38GKaxho=', 7, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edgar David Antezana Quilo -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac131')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Edgar David', 'Antezana Quilo', NULL, NULL, NULL, 'operac131', '100000.C5NMTwSaV/qfN0JMIZla+g==.EapQgFAKvxxZQV6qcDjEi0zn1hNr4taTwzwN/H0s+/w=', 131, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jaime Oscar Armas Rioja -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac132')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jaime Oscar', 'Armas Rioja', NULL, NULL, NULL, 'operac132', '100000.5VFzJZQZclCLDxrGwK3WgQ==.sm8q5xpYjeRywg5TYd1CbYdoqTO+6U1mkt+APcS5kBM=', 132, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Karla Rosita Iglesias Paulino -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac133')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Karla Rosita', 'Iglesias Paulino', NULL, NULL, NULL, 'operac133', '100000.cERgJB6WYiCk33tB0bVbnA==.NuCmci3Ur0E/ieTnQYL6zc24oOwDhCN48anJFo3uBeo=', 133, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Ruth Esmeralda Llanqui Huarachi -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial49')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Ruth Esmeralda', 'Llanqui Huarachi', NULL, NULL, NULL, 'comercial49', '100000.bkZYZZjBZ6kVkKY4gregjw==.dzsie5T/4TI/46ktkW1UMkf+kA0J1I1MpcZRbkzKgGg=', 49, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Delia Zorayda Llanqui Huarachi -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac134')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Delia Zorayda', 'Llanqui Huarachi', NULL, NULL, NULL, 'operac134', '100000.grdaOMqswIBBuyk5zkwGDA==.qBVJbASPf9ctehSanOlF9CsD34v9T3K1jQmLaSdTzvs=', 134, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Flor Karina Ancalle Javier -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac135')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Flor Karina', 'Ancalle Javier', NULL, NULL, NULL, 'operac135', '100000.dvn8NRnIpcRQmxv8l015tQ==.nwO4QEZpHDYKfOdVXf2y/ltPUaJe4LrAKlxErXWonS4=', 135, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Shinay Paola Maricela Correa Mamani -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac136')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Shinay Paola Maricela', 'Correa Mamani', NULL, NULL, NULL, 'operac136', '100000.F9chWbZq+cE1h39BJ3nIfg==.Oc9q9gdJZZZDtzn8s3xDNmLvlb3AFddQVSvOI/kwwiM=', 136, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alberto Alexander Vergara Panduro -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac137')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Alberto Alexander', 'Vergara Panduro', NULL, NULL, NULL, 'operac137', '100000.5gqZrNOCRKfdhJH1pViZ9g==.dnQsg9T7qwbQcCW0zoWRlQ1iUwSjKp9RyGnIurtKALg=', 137, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Oscar Enrique Obando Montes -- Subger. Y Analisis Comercial (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial50')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 57, 0, 'Oscar Enrique', 'Obando Montes', NULL, NULL, NULL, 'comercial50', '100000.7qa+Ti/oHHsac8uO7GguCA==.UEDu2DMgxpOAz17RIaH6GwfmzYnhqQxnYh/YQm6S4Cc=', 50, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carlos Alberto Reyes Flores -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac138')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Carlos Alberto', 'Reyes Flores', NULL, NULL, NULL, 'operac138', '100000.IeNstAHOs2a5vwzdYzYlKQ==.eilHxeKYdvKp4xhtfAhKRvmhVR1TdHKSkWgWVgU9qUg=', 138, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jefferson Fedor Huaman Jimenez -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac139')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Jefferson Fedor', 'Huaman Jimenez', NULL, NULL, NULL, 'operac139', '100000.m+w45Gid0icXn6S7CANZTg==.1aFVZCEZo+e7G+mAOlAdRDu6Vzy7XjQCEMxUtG0NNQ4=', 139, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Milagros Melanie Cruzado Tafur -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac140')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Milagros Melanie', 'Cruzado Tafur', NULL, NULL, NULL, 'operac140', '100000.7tbWSQ5LLyXQfurR/pvemw==.1tFxQgQAb0kCpobYHYOb43y9YMuAQbIfPQ2CpqtdJQA=', 140, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Robert Daniel Hernandez Cruzado -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac141')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Robert Daniel', 'Hernandez Cruzado', NULL, NULL, NULL, 'operac141', '100000.yuCiPFoU71fa445WPZprhw==.dfsLxCrn+kherspDAJiguyjqNG6XxvXn0e/NlN1yYHo=', 141, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gianfranco Cubas Armas -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac142')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Gianfranco', 'Cubas Armas', NULL, NULL, NULL, 'operac142', '100000.h5B398+O//4J9UEo3MTArQ==.5Umn4GOxt2BlaGCZSDfvn62qieYyrOREix5mchE1p4g=', 142, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Edgar Oscco Quispe -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac143')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Edgar', 'Oscco Quispe', NULL, NULL, NULL, 'operac143', '100000.+rBfqseS2WqWRhdyWV/q0w==.EPPRlGUqhQ4cfzDXlO2zu2VjXzPZ60+Hx39TObZGXnw=', 143, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Elias Esteban Muñoz Vargas -- Marketing (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial51')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 61, 0, 'Elias Esteban', 'Muñoz Vargas', NULL, NULL, NULL, 'comercial51', '100000.5UMTWJXuIrehSIlhJcmQaw==.88ZiJJumRs9sYTIVYAmEUvyW5KTgqLjYnQZQvlXaV8k=', 51, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Lizseth Jessica Paucar Condor -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial52')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Lizseth Jessica', 'Paucar Condor', NULL, NULL, NULL, 'comercial52', '100000.GsAi+jEv3+T/7Hlt53Q57A==.HvlFMzNhc9c3L56PoCJojeFzmSzhWHuj9/hrYO7grAw=', 52, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Hans Irvin Nanfaro Gonzales -- Subger. Y Analisis Operaciones (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac144')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 76, 0, 'Hans Irvin', 'Nanfaro Gonzales', NULL, NULL, NULL, 'operac144', '100000.mBum/M6Oxw5mUTaeJ8tHpw==.mUC3VzWjnjJkjUmIMG9Yvm9HSs5V+D/AwFe55nQr3AA=', 144, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Randu Michael Flores Flores -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac145')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Randu Michael', 'Flores Flores', NULL, NULL, NULL, 'operac145', '100000.+Xx6185cOmJGmAnUebzRMA==.b1+cY6/cRZTotAQ/PJGaNtyl5f3CEp8hO8+1UxQAx6c=', 145, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Mayte Fernanda Rojas Pisconte -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial53')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Mayte Fernanda', 'Rojas Pisconte', NULL, NULL, NULL, 'comercial53', '100000.nYpywEIIjAiA+PE/SqmBCQ==.pI0Dfe5VWNDmaMYw44yGRWpCPzrcrHVLk5oHihIm1SM=', 53, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cristian Miguel Moreno Tarazona -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial54')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Cristian Miguel', 'Moreno Tarazona', NULL, NULL, NULL, 'comercial54', '100000.sYo9Ltn+PAQN3eML4NaLHw==.nzHqM37HOBx9DACqlGWOhtUVnxhQW+IBbkEcxI4feo8=', 54, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jhoselyn Belen Gonzalo Flores -- Verificacion y Packing (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac146')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 67, 0, 'Jhoselyn Belen', 'Gonzalo Flores', NULL, NULL, NULL, 'operac146', '100000.nArTufZhh/o3EweXDcv8kw==.PbWVPpzbJcjwnb/431X5pDwxlX7bLNeMgvnI/sSRhc0=', 146, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Gladis Llanqui Huarachi -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac147')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Gladis', 'Llanqui Huarachi', NULL, NULL, NULL, 'operac147', '100000.Fyu782LOvMvxmmHp9DNVtw==.j2b1KoNfx/83OfjNHpDBwOPzy4o8VyuvcMpqLMHr/m4=', 147, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Carlos Felipe Junco Mendivil -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac148')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Carlos Felipe', 'Junco Mendivil', NULL, NULL, NULL, 'operac148', '100000./0vrW9xyuc9pR2QEsKicww==.klTS1WKS/OmQ/X23opA9jLjaO9lBXe18QQTNGAVQ1iM=', 148, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Eliana Flor Campos Carrazco -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial55')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Eliana Flor', 'Campos Carrazco', NULL, NULL, NULL, 'comercial55', '100000.u3PGhrEoaqX9aSTX32akrA==.G1grw4/VfL1A5KjZvz+h5qxJpk85Fbil3wDBnsREQf0=', 55, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Camilo Cunayapa Padilla -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant37')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Camilo', 'Cunayapa Padilla', NULL, NULL, NULL, 'mant37', '100000.1r24SYEg5sVuO5y6FUBr2Q==.u445ftg943Ec9LjWKwCkw1cl+7pJFsMINzU8o4MSuik=', 37, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- la Cruz Jean Carlos Velasquez De -- Tesoreria (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas14')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 82, 0, 'la Cruz Jean Carlos', 'Velasquez De', NULL, NULL, NULL, 'finanzas14', '100000.HF7fc8f+aFlHqaNtaRWXjg==.6ioKmHnMTElHTFjnW1wJKe74MY6d5mry7sqGfdJWF9Y=', 14, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Raul Adolfo Salazar Galvez -- Gastos Varios (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'gastosv1')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 95, 0, 'Raul Adolfo', 'Salazar Galvez', NULL, NULL, NULL, 'gastosv1', '100000.7GHPhKbt04uDS7gTSUiSdw==.qVz/bokAFZY+T+jOyc0sF/iycN6StZLygPyHj4wsjdY=', 1, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Angelo Alberto Medina Carrasco -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac149')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Angelo Alberto', 'Medina Carrasco', NULL, NULL, NULL, 'operac149', '100000.+yCpci1ZWtO9HfWNCausiQ==.Hz0Q8m9OD7tOUY1BNnjbkqUXZ7Cum1JVZq0F1i18R9Y=', 149, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Deysi Maria Crespin Ortiz -- Ventas Call Center Lima (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial56')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 63, 0, 'Deysi Maria', 'Crespin Ortiz', NULL, NULL, NULL, 'comercial56', '100000.+ztQln0M0AOCcNkTRI1PoA==.ULD/wvMBwu3GTOXfehHESHS1gQw5SypazOp85iwQ/4I=', 56, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Erick Renzo Panduro Panduro -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac150')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Erick Renzo', 'Panduro Panduro', NULL, NULL, NULL, 'operac150', '100000.bWoQoUyUfP3iojjOH4xPlw==.UWWS4bUlNVtj44d3UlikCIAu+liZnKSWxJ7HNakVWec=', 150, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jorge Felipe Gaspar Gonzales -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac151')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jorge Felipe', 'Gaspar Gonzales', NULL, NULL, NULL, 'operac151', '100000.5CN7XjeDF0x08FmqwJHkXA==.PEXExB3JqFz/Fdsjl4+yoo12JxGtF/TlqP1tpnrEaTw=', 151, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Junior Michael Flores Chahuayo -- Transporte (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac152')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 74, 0, 'Junior Michael', 'Flores Chahuayo', NULL, NULL, NULL, 'operac152', '100000.6gaJAURD7jdRJ23TgZHxww==.cyu4EwLf+7uX6lQ2+EirTJPR5zc+5Sbt3ocw7mGDxOM=', 152, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kiara Yandira Sanchez Vargas -- Direccion Tecnica (Direccion Tecnica)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'dirtec10')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 56, 0, 'Kiara Yandira', 'Sanchez Vargas', NULL, NULL, NULL, 'dirtec10', '100000.qKqI7HDNPLsRzJd1sVawCQ==.zRep9Ll6DdVq2rhAt2Q02oHKmguBcRYbW+9C88CfAn0=', 10, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Roberto Carlos Melgarejo Guevara -- Distribución Local (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac153')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 72, 0, 'Roberto Carlos', 'Melgarejo Guevara', NULL, NULL, NULL, 'operac153', '100000.KcJTd8UT9vMMqfLbhhZAkQ==.zOl8M0WHiwhcjx8fmIDizXsNIecHu42kbbkKMddShCk=', 153, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Jair Israel Ricardo Mendoza Huapaya -- Recepción ,Abastecimiento y Picking (Operaciones)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'operac154')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 77, 0, 'Jair Israel Ricardo', 'Mendoza Huapaya', NULL, NULL, NULL, 'operac154', '100000.l5Ls0TEJryZRuabj5DkaPg==.Gr2xeylFQ4yFhdWlCBWxa7KDE156UVT24tvHlHpRmjs=', 154, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Wilian Vasquez Mori -- Seguridad y Vigilancia (Mantenimiento)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'mant38')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 83, 0, 'Wilian', 'Vasquez Mori', NULL, NULL, NULL, 'mant38', '100000.bWP0Dm9hQ6WoYBud7nQqHA==.XD+0IID2lT/4H9eylVYd7mY2jZJr6QC9yVK7kcNhJus=', 38, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Zuleyka Aracely Domenack Espinoza -- Ventas Horizontal (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial57')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 60, 0, 'Zuleyka Aracely', 'Domenack Espinoza', NULL, NULL, NULL, 'comercial57', '100000.NJRR54Z4zS4xuP6OXm8p5g==.YbNhlPd57ft0FXa2/7ja9iaN1//3aCSKtaIMPQwGKnM=', 57, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Oscar Jair Vasquez Adriazola -- Bussiness Intelligence (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin11')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 90, 0, 'Oscar Jair', 'Vasquez Adriazola', NULL, NULL, NULL, 'admin11', '100000.GmRUK5Kd2kKPAdEjX/tgXA==.vtaHYy+TORCKHwQJgDvhNYXkwQZMFNsXj+RbnRY1DvI=', 11, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Cristhian Eduardo Huaman Rivas -- Finanzas (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas15')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 80, 0, 'Cristhian Eduardo', 'Huaman Rivas', NULL, NULL, NULL, 'finanzas15', '100000.VK+ESeuO+x2lhBhv4VY3Gg==.S1ugZaXDxba/FPpvgJ6R+y6o6pJ8bEWDKFg1d7Di+Uk=', 15, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Alex Antony Diaz Veramendi -- Finanzas (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas16')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 80, 0, 'Alex Antony', 'Diaz Veramendi', NULL, NULL, NULL, 'finanzas16', '100000.0hdMJO39BU1Xe9p/Xj28Qw==.U06XKghQM3Ar5+YoTZIgmlanhf11S/FyiBcB4KUmUjI=', 16, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Kimberly Quintanilla Baca -- Ventas Call Center Provincia (Comercial)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'comercial58')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 64, 0, 'Kimberly', 'Quintanilla Baca', NULL, NULL, NULL, 'comercial58', '100000.S5+/gl9O+dUzwD/YuxKYCQ==.6CUEb0IPM4fWUFWpePt5b0Hi0IdnUIOSqFFZaQdGbds=', 58, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Rayda Martha Gonzales Tapia -- Contabilidad (Contabilidad y Finanzas)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'finanzas17')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 81, 0, 'Rayda Martha', 'Gonzales Tapia', NULL, NULL, NULL, 'finanzas17', '100000.2JaHVhFcLN5ObRfAatpHRA==.iKZcKeFvVvl4NV1pKD3lN/w4TAxz731Qhcc3/HkYrL0=', 17, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

-- Luis Alberto Terrones Lozano -- Area Administrativa (Gerencia Administrativa)
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Usuario = 'admin12')
BEGIN
    DECLARE @IdNuevo INT;
    INSERT INTO Usuarios (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario, Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
    VALUES (1, 91, 0, 'Luis Alberto', 'Terrones Lozano', NULL, NULL, NULL, 'admin12', '100000.xuAjRWzD1+rSaweaSo103A==.z+pyIbagLi874FKnnsT+TC5wogeOobR8BFOJF3ZqsXw=', 12, 1, 'ImportacionEmpleados');
    SET @IdNuevo = SCOPE_IDENTITY();
    INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdNuevo, 1);
END
GO

