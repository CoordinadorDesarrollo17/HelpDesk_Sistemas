-- Categorías oficiales del área Soporte TI.
-- El script es idempotente: se puede volver a ejecutar sin duplicar filas.
--
-- IMPORTANTE: ejecutar con codificación UTF-8, si no las tildes se guardan mal:
--   sqlcmd -S TI-9 -d HELPDESK_V1 -f 65001 -i 01_CategoriasSoporteTI.sql

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

DECLARE @IdArea INT = (SELECT Id FROM Area WHERE Nombre = 'Soporte TI');

IF @IdArea IS NULL
BEGIN
    RAISERROR('No existe el área "Soporte TI".', 16, 1);
    RETURN;
END

-- Las dos categorías que ya existían son las mismas de la lista nueva, solo que
-- con el nombre más corto: se renombran en vez de borrarlas e insertarlas, para
-- no romper ninguna referencia (Tickets, SLA_Definicion, Guias_Anexos).
UPDATE Categoria SET Nombre = 'Red e Internet'
WHERE Id_Area = @IdArea AND Nombre = 'Red';

UPDATE Categoria SET Nombre = 'Impresoras y escáneres'
WHERE Id_Area = @IdArea AND Nombre = 'Impresoras';

DECLARE @Categorias TABLE (Nombre VARCHAR(150));

INSERT INTO @Categorias (Nombre) VALUES
    ('Consulta y ayuda'),
    ('Hardware'),
    ('Software'),
    ('Correo electrónico'),
    ('Usuarios y accesos'),
    ('Red e Internet'),
    ('Impresoras y escáneres'),
    ('Servidores'),
    ('Intranet y extranet'),
    ('Archivos y carpetas compartidas'),
    ('Copias de seguridad'),
    ('Seguridad informática'),
    ('Base de datos'),
    ('Telefonía y comunicaciones'),
    ('Altas, bajas y cambios de personal'),
    ('Solicitud de equipos'),
    ('Mantenimiento preventivo');

INSERT INTO Categoria (Nombre, Id_Area, Activo, Usu_Creacion, Fecha_Creacion)
SELECT c.Nombre, @IdArea, 1, 'seed', GETDATE()
FROM @Categorias c
WHERE NOT EXISTS (
    SELECT 1 FROM Categoria existente
    WHERE existente.Id_Area = @IdArea AND existente.Nombre = c.Nombre
);
GO

SELECT Id, Nombre, Activo
FROM Categoria
WHERE Id_Area = (SELECT Id FROM Area WHERE Nombre = 'Soporte TI')
ORDER BY Nombre;
GO
