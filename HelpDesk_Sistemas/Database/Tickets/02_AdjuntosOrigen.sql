-- Permite adjuntar archivos también a la SOLUCIÓN de un ticket (imágenes, videos, etc.),
-- no solo al reporte original.
--
-- Se reutiliza Ticket_Adjuntos: la columna Origen indica de dónde viene cada archivo
-- ('Solicitud' = lo subió el solicitante al crear el ticket, 'Solucion' = lo subió
-- Soporte al registrar la solución), para poder mostrarlos por separado.
-- Los adjuntos que ya existen quedan como 'Solicitud', que es lo que son.

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('dbo.Ticket_Adjuntos') AND name = 'Origen'
)
BEGIN
    ALTER TABLE Ticket_Adjuntos
        ADD Origen VARCHAR(20) NOT NULL
            CONSTRAINT DF_Ticket_Adjuntos_Origen DEFAULT 'Solicitud'
            CONSTRAINT CK_Ticket_Adjuntos_Origen CHECK (Origen IN ('Solicitud', 'Solucion'));
END
