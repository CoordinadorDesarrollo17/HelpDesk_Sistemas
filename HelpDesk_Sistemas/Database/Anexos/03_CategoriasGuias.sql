-- Carga las categorías y subcategorías del módulo de Anexos a partir del catálogo real
-- de tickets:
--   Categoría de guía    = Tipo de atención   (Tipo_Requerimiento.Nombre)
--   Subcategoría de guía = Categoría del ticket (Categoria.Nombre) que cuelga de ese tipo
--
-- Los nombres se leen de las tablas (no están escritos a mano), así que el script sirve
-- igual en cualquier base que tenga el mismo catálogo de tickets, sin depender de los Id.
--
-- Los tipos y categorías se repiten una vez por área de soporte (Sistemas, Desarrollo, TI),
-- por eso se usa DISTINCT: en las guías cada nombre queda una sola vez. Además,
-- "Consulta/Asesoria" (área de TI) y "Consultas/Asesorias" (Sistemas y Desarrollo) son el
-- mismo tipo con distinto nombre, y se unen bajo "Consultas/Asesorias".
--
-- Es idempotente: no duplica lo que ya exista.

SET QUOTED_IDENTIFIER ON;

-- 1) Categorías (tipos de atención)
INSERT INTO Guia_Categoria (Nombre)
SELECT DISTINCT
    CASE WHEN tr.Nombre IN ('Consulta/Asesoria', 'Consultas/Asesorias') THEN 'Consultas/Asesorias' ELSE tr.Nombre END
FROM Categoria c
INNER JOIN Tipo_Requerimiento tr ON tr.Id = c.Id_Tipo_Req
WHERE c.Activo = 1
  AND NOT EXISTS (
        SELECT 1 FROM Guia_Categoria gc
        WHERE gc.Nombre = CASE WHEN tr.Nombre IN ('Consulta/Asesoria', 'Consultas/Asesorias') THEN 'Consultas/Asesorias' ELSE tr.Nombre END
      );

-- 2) Subcategorías (categorías del ticket, bajo su tipo de atención)
INSERT INTO Guia_Subcategoria (Nombre, Id_Guia_Categoria)
SELECT DISTINCT c.Nombre, gc.Id
FROM Categoria c
INNER JOIN Tipo_Requerimiento tr ON tr.Id = c.Id_Tipo_Req
INNER JOIN Guia_Categoria gc
    ON gc.Nombre = CASE WHEN tr.Nombre IN ('Consulta/Asesoria', 'Consultas/Asesorias') THEN 'Consultas/Asesorias' ELSE tr.Nombre END
WHERE c.Activo = 1
  AND NOT EXISTS (
        SELECT 1 FROM Guia_Subcategoria gs
        WHERE gs.Nombre = c.Nombre AND gs.Id_Guia_Categoria = gc.Id
      );
