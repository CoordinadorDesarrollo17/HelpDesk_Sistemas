-- Corrige usuarios que quedaron apuntando a áreas inactivas (Id_Area con Activo=0)
-- por reorganizaciones posteriores al export de "intranet adquisiciones".
-- Ejecutar con: SET QUOTED_IDENTIFIER ON (hay índice único filtrado sobre Usuarios.Correo).

SET QUOTED_IDENTIFIER ON;

-- ============================================================
-- GRUPO 1: "AREA DE RECEPCIÓN Y CONTROL" duplicada.
-- Id=66 (inactiva) -> Id=70 (activa, mismo nombre exacto). Mapeo 1:1 sin ambigüedad.
-- ============================================================
UPDATE Usuarios SET Id_Area = 70 WHERE Id_Area = 66;

-- ============================================================
-- GRUPO 2: "AREA DE VENTAS CALL CENTER" (Id=59, inactiva) se dividió en
-- VENTAS CALL CENTER-LIMA (Id=63) y VENTAS CALL CENTER-PROVINCIA (Id=64).
-- Mapeo confirmado por el usuario, persona por persona.
-- ============================================================

-- -> LIMA (63)
UPDATE Usuarios SET Id_Area = 63 WHERE Id IN (23, 24, 30, 31, 37, 41);
-- 23 comercial6  Jackelin Roman Tello
-- 24 comercial7  Jean Paul Ramirez Rodriguez
-- 30 comercial13 Lizbet Galindo Castañeda
-- 31 comercial14 Lizseth Paucar Condor
-- 37 comercial20 Reyna Soto Escriba
-- 41 comercial24 Susel Castillo Ventocilla

-- -> PROVINCIA (64)
UPDATE Usuarios SET Id_Area = 64 WHERE Id IN (18, 21, 26, 28, 32, 33, 34, 40, 42);
-- 18 comercial1  Betsy Untiveros Crispin
-- 21 comercial4  Fiorella Zacarias Ramon
-- 26 comercial9  Katherine Vera Valderrama
-- 28 comercial11 Kelly Murayari Pacaya
-- 32 comercial15 Lyz Zamudio Gonzales
-- 33 comercial16 Marco Cruz Cuellar
-- 34 comercial17 Maricruz Bacilio Cardenas
-- 40 comercial23 Smith Gomez Samaniego
-- 42 comercial25 Wisman Chinchay Chasquero

-- -> YA NO TRABAJAN: eliminar cuenta (mismo criterio que UsuariosRepository.EliminarUsuario)
DELETE FROM Usuario_Sociedad WHERE Id_Usuario IN (29, 36);
DELETE FROM Usuarios WHERE Id IN (29, 36);
-- 29 comercial12 Kevin Ramos Artica
-- 36 comercial19 Miriam Valer Arroyo
