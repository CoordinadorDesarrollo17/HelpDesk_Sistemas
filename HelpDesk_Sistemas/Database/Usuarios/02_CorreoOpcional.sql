-- El correo es opcional al crear un usuario desde el módulo HelpDesk (no todos los
-- roles/áreas necesitan uno registrado), pero la columna original no admitía NULL.
ALTER TABLE Usuarios ALTER COLUMN Correo VARCHAR(150) NULL;
GO
