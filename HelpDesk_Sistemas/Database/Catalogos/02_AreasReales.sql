-- Reemplaza el catálogo simplificado de Área (5 filas, solo IT) por la
-- estructura real de la empresa (23 áreas). El usuario/contraseña de
-- HelpDesk ahora se genera a partir del Prefijo del ÁREA, no del Rol.
--
-- IMPORTANTE:
-- - Las 3 áreas de soporte (Soporte TI/Sistemas/Desarrollo) NO se tocan ni
--   se les cambia el Id: siguen siendo las únicas seleccionables para
--   enrutar tickets (Es_Area_Sistemas = 1) y las categorías ya cargadas
--   siguen apuntando a ellas. Solo se les agrega Prefijo = 'MANAGER'
--   (las tres comparten el mismo prefijo: para la empresa son un solo
--   "Sistemas", la subdivisión en 3 es un detalle interno de HelpDesk).
-- - "Ventas" se conserva (ya no se duplica) y se le agrega Prefijo.
-- - "Contabilidad" se renombra a "Administración" (el código CONT ya
--   pertenece a esa área en la intranet real) — no tenía usuarios, tickets
--   ni categorías asociadas, así que renombrar es seguro.
-- - El resto (20 áreas) son filas nuevas, todas con Es_Area_Sistemas = 0
--   porque son departamentos de la empresa, no equipos de soporte: jamás
--   deben aparecer como destino de un ticket, solo como "área" de un
--   empleado al crearlo/editarlo en HelpDesk.
--
-- Ejecutar con: sqlcmd ... -f 65001 -i 02_AreasReales.sql

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

IF COL_LENGTH('Area', 'Prefijo') IS NULL
BEGIN
    ALTER TABLE Area ADD Prefijo VARCHAR(20) NULL;
END
GO

UPDATE Area SET Prefijo = 'VENTAS' WHERE Nombre = 'Ventas';
UPDATE Area SET Nombre = 'Administración', Prefijo = 'ADM' WHERE Nombre = 'Contabilidad';
UPDATE Area SET Prefijo = 'MANAGER' WHERE Nombre IN ('Soporte TI', 'Soporte Sistemas', 'Soporte Desarrollo');

DECLARE @Areas TABLE (Nombre VARCHAR(150), Prefijo VARCHAR(20));

INSERT INTO @Areas (Nombre, Prefijo) VALUES
    ('DIGEMID', 'DIGEMID'),
    ('Almacén', 'ALM'),
    ('Caja', 'CAJA'),
    ('Compras / Adquisiciones / Abastecimiento', 'COMPRAS'),
    ('Atención al Cliente', 'ATC'),
    ('Recursos Humanos', 'RRHH'),
    ('Aseguramiento de la Calidad', 'CALIDAD'),
    ('SST', 'SST'),
    ('Infraestructura', 'INFRA'),
    ('Mantenimiento', 'MANT'),
    ('BI Comercial', 'BICOM'),
    ('BI Operaciones', 'BIOPE'),
    ('BI Compras', 'BICMP'),
    ('Operaciones', 'OPER'),
    ('Reparto', 'REPA'),
    ('Marketing', 'MKT'),
    ('Seguridad', 'SEG'),
    ('Comercial', 'COM'),
    ('Lidermax', 'LIDER'),
    ('Promociones', 'PROM');

INSERT INTO Area (Nombre, Es_Area_Sistemas, Activo, Prefijo, Usu_Creacion, Fecha_Creacion)
SELECT nueva.Nombre, 0, 1, nueva.Prefijo, 'seed', GETDATE()
FROM @Areas nueva
WHERE NOT EXISTS (SELECT 1 FROM Area existente WHERE existente.Nombre = nueva.Nombre);
GO

SELECT Id, Nombre, Prefijo, Es_Area_Sistemas, Activo FROM Area ORDER BY Es_Area_Sistemas DESC, Nombre;
GO
