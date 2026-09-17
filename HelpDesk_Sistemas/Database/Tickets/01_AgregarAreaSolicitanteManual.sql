-- Agrega la posibilidad de indicar manualmente el "área solicitante" de un ticket,
-- en vez de que siempre se derive del área propia de quien lo crea.
--
-- Motivo: durante pruebas, todos los tickets los crean las mismas cuentas de prueba
-- (manager1..manager6), así que el área solicitante real siempre termina siendo la
-- misma y no hay trazabilidad de qué área originó cada reporte.
--
-- Diseño pensado para no requerir revertir nada al pasar a producción: la columna
-- es NULL por defecto, y toda la lectura (ObtenerTickets, PowerBI) usa
-- COALESCE(Id_Area_Solicitante, Usuarios.Id_Area) — si nunca se llena (como pasará
-- con usuarios reales creando sus propios tickets), el comportamiento es idéntico
-- al actual.

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('dbo.Tickets') AND name = 'Id_Area_Solicitante'
)
BEGIN
    ALTER TABLE Tickets ADD Id_Area_Solicitante INT NULL;

    ALTER TABLE Tickets ADD CONSTRAINT FK_Tickets_AreaSolicitante
        FOREIGN KEY (Id_Area_Solicitante) REFERENCES Area(Id);
END
