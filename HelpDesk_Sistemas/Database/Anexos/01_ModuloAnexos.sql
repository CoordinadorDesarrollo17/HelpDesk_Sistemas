-- Módulo de Anexos/Guías: base de conocimiento con categoría y subcategoría,
-- CRUD para Soporte/Administrador, lectura para todos, y vínculo con la
-- solución de un ticket.

-- 1) Categorías propias del módulo (no reutiliza Categoria de Tickets: esa
--    tabla está atada al área/tipo de requerimiento de creación de tickets,
--    una taxonomía distinta a la de la base de conocimiento).
IF OBJECT_ID('dbo.Guia_Categoria') IS NULL
BEGIN
    CREATE TABLE Guia_Categoria (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(100) NOT NULL,
        Activo BIT NOT NULL DEFAULT 1
    );
END

IF OBJECT_ID('dbo.Guia_Subcategoria') IS NULL
BEGIN
    CREATE TABLE Guia_Subcategoria (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(100) NOT NULL,
        Id_Guia_Categoria INT NOT NULL,
        Activo BIT NOT NULL DEFAULT 1,
        CONSTRAINT FK_GuiaSubcategoria_Categoria FOREIGN KEY (Id_Guia_Categoria) REFERENCES Guia_Categoria(Id)
    );
END

-- 2) Ajustar Guias_Anexos (ya existe, vacía): sacar el FK viejo hacia
--    Categoria (de tickets) y apuntar a las tablas nuevas, más los campos
--    que le faltan para igualar el patrón de Ticket_Adjuntos (nombre
--    original del archivo, peso, quién lo subió).
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Guias_Categoria')
BEGIN
    ALTER TABLE Guias_Anexos DROP CONSTRAINT FK_Guias_Categoria;
END

IF COL_LENGTH('dbo.Guias_Anexos', 'Id_Categoria') IS NOT NULL
BEGIN
    EXEC sp_rename 'dbo.Guias_Anexos.Id_Categoria', 'Id_Guia_Categoria', 'COLUMN';
END

IF COL_LENGTH('dbo.Guias_Anexos', 'Id_Subcategoria') IS NULL
BEGIN
    ALTER TABLE Guias_Anexos ADD Id_Subcategoria INT NULL;
END

IF COL_LENGTH('dbo.Guias_Anexos', 'Nombre_Archivo') IS NULL
BEGIN
    ALTER TABLE Guias_Anexos ADD Nombre_Archivo VARCHAR(255) NULL;
END

IF COL_LENGTH('dbo.Guias_Anexos', 'Peso_KB') IS NULL
BEGIN
    ALTER TABLE Guias_Anexos ADD Peso_KB INT NULL;
END

IF COL_LENGTH('dbo.Guias_Anexos', 'Id_Usuario_Sube') IS NULL
BEGIN
    ALTER TABLE Guias_Anexos ADD Id_Usuario_Sube INT NULL;
END

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Guias_GuiaCategoria')
BEGIN
    ALTER TABLE Guias_Anexos ADD CONSTRAINT FK_Guias_GuiaCategoria FOREIGN KEY (Id_Guia_Categoria) REFERENCES Guia_Categoria(Id);
END
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Guias_GuiaSubcategoria')
BEGIN
    ALTER TABLE Guias_Anexos ADD CONSTRAINT FK_Guias_GuiaSubcategoria FOREIGN KEY (Id_Subcategoria) REFERENCES Guia_Subcategoria(Id);
END

-- 3) Vínculo guía <-> ticket (muchos a muchos: un ticket puede resolverse
--    con más de una guía).
IF OBJECT_ID('dbo.Ticket_Guias') IS NULL
BEGIN
    CREATE TABLE Ticket_Guias (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Id_Ticket INT NOT NULL,
        Id_Guia INT NOT NULL,
        Id_Usuario_Accion INT NOT NULL,
        Fecha_Vinculo DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_TicketGuias_Ticket FOREIGN KEY (Id_Ticket) REFERENCES Tickets(Id),
        CONSTRAINT FK_TicketGuias_Guia FOREIGN KEY (Id_Guia) REFERENCES Guias_Anexos(Id)
    );
END