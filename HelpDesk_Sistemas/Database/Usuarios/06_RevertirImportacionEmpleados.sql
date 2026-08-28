-- Revierte la importación de empleados reales (04_ImportarEmpleadosReales.sql):
-- deja solo los 6 usuarios de Soporte/Administrador originales (manager1..manager6),
-- elimina todos los demás (admin*, comercial*, compras*, dirtec*, finanzas*, mant*,
-- operac*, rrhh*). El área/departamento/centro de costo se pedirá a RRHH y se
-- cargará manualmente más adelante.
--
-- Verificado antes de correr: ningún Ticket pertenece a estos usuarios (los 7
-- tickets existentes son todos de manager4), así que no hay nada que perder.

SET QUOTED_IDENTIFIER ON;

DELETE FROM Usuario_Sociedad
WHERE Id_Usuario NOT IN (
    SELECT Id FROM Usuarios WHERE Usuario IN ('manager1','manager2','manager3','manager4','manager5','manager6')
);

DELETE FROM Usuarios
WHERE Usuario NOT IN ('manager1','manager2','manager3','manager4','manager5','manager6');
