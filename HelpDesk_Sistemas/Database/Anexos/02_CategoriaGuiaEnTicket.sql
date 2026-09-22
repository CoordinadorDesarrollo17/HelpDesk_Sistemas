-- El agente, al vincular una guía de otra categoría a la solución de un ticket,
-- puede recategorizar el ticket para que coincida (para que los reportes reflejen
-- el problema real). Este campo guarda esa corrección; es independiente de
-- Tickets.Id_Categoria (la categoría de triage elegida al crear el ticket).

IF COL_LENGTH('dbo.Tickets', 'Id_Guia_Categoria') IS NULL
BEGIN
    ALTER TABLE Tickets ADD Id_Guia_Categoria INT NULL;

    ALTER TABLE Tickets ADD CONSTRAINT FK_Tickets_GuiaCategoria
        FOREIGN KEY (Id_Guia_Categoria) REFERENCES Guia_Categoria(Id);
END
