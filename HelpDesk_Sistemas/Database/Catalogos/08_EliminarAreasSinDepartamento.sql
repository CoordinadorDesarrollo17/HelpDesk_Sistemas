-- Elimina las áreas "huérfanas" (Id_Departamento IS NULL): son 22 filas de un
-- catálogo anterior al modelo Departamento -> Área actual, todas ya inactivas
-- (Activo = 0) y sin ningún uso. Verificado antes: 0 referencias en Usuarios,
-- Categoria, Tickets y Tipo_Requerimiento (las 4 tablas con FK hacia Area).

SET QUOTED_IDENTIFIER ON;

DELETE FROM Area WHERE Id_Departamento IS NULL;
