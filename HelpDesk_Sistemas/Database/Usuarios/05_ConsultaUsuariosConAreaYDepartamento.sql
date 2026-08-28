-- Usuarios con su Rol, Área, Departamento, Supervisor y Sociedades en texto,
-- en vez de solo los IDs crudos de la tabla Usuarios.

SELECT
    u.Id,
    u.Usuario,
    u.Nombre,
    u.Apellido,
    u.Correo,
    u.Nro_Contacto AS NroContacto,
    r.Nombre AS Rol,
    a.Nombre AS Area,
    a.Activo AS AreaActiva,
    d.Nombre AS Departamento,
    sup.Usuario AS Supervisor,
    STUFF((
        SELECT ', ' + s.Nombre
        FROM Usuario_Sociedad us
        INNER JOIN Sociedad s ON s.Id = us.Id_Sociedad
        WHERE us.Id_Usuario = u.Id
        FOR XML PATH('')
    ), 1, 2, '') AS Sociedades,
    u.Es_Coordinador AS EsCoordinador,
    u.Activo,
    u.Fecha_Creacion AS FechaCreacion
FROM Usuarios u
INNER JOIN Rol r ON r.Id = u.IdRol
INNER JOIN Area a ON a.Id = u.Id_Area
LEFT JOIN Departamento d ON d.Id = a.Id_Departamento
LEFT JOIN Usuarios sup ON sup.Id = u.Id_Sup_Usuario
ORDER BY d.Nombre, a.Nombre, u.Apellido, u.Nombre;
