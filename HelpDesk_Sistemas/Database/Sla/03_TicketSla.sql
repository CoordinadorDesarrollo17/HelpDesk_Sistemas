-- ============================================================
-- Motor de SLA — 03: Instancia de SLA por ticket
-- Equivalente a "Task SLA" de ServiceNow: el reloj real de un ticket
-- contra una definición concreta, con su etapa, fecha objetivo y
-- estado de cumplimiento.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE Ticket_SLA (
    Id                          INT IDENTITY(1,1) PRIMARY KEY,
    Id_Ticket                   INT             NOT NULL,
    Id_SLA_Definicion           INT             NOT NULL,

    Fecha_Inicio                DATETIME        NOT NULL,
    Fecha_Objetivo              DATETIME        NOT NULL,  -- due date; se recalcula en cada pausa/reanudación
    Fecha_Fin                   DATETIME        NULL,      -- cuándo se detuvo el reloj (llegó al estado fin)

    Minutos_Objetivo            INT             NOT NULL,
    Minutos_Pausados_Habiles    INT             NOT NULL CONSTRAINT DF_Ticket_SLA_MinPausados DEFAULT (0),

    Etapa                       VARCHAR(20)     NOT NULL CONSTRAINT DF_Ticket_SLA_Etapa DEFAULT ('EnCurso'),
    -- 'EnCurso' | 'Pausado' | 'Completado' | 'Cancelado'

    Incumplido                  BIT             NOT NULL CONSTRAINT DF_Ticket_SLA_Incumplido DEFAULT (0),
    Fecha_Incumplimiento        DATETIME        NULL,
    Advertencia_Activa          BIT             NOT NULL CONSTRAINT DF_Ticket_SLA_Advertencia DEFAULT (0),
    Fecha_Advertencia           DATETIME        NULL,
    Cumplido_A_Tiempo           BIT             NULL,      -- se fija cuando Etapa = 'Completado'

    Fecha_Creacion               DATETIME        NOT NULL CONSTRAINT DF_Ticket_SLA_Fecha_Creacion DEFAULT (GETDATE()),
    Fecha_Modificacion           DATETIME        NULL,

    CONSTRAINT CK_Ticket_SLA_Etapa CHECK (Etapa IN ('EnCurso', 'Pausado', 'Completado', 'Cancelado')),

    CONSTRAINT FK_Ticket_SLA_Ticket     FOREIGN KEY (Id_Ticket)         REFERENCES Tickets(Id),
    CONSTRAINT FK_Ticket_SLA_Definicion FOREIGN KEY (Id_SLA_Definicion) REFERENCES SLA_Definicion(Id)
);
GO

CREATE INDEX IX_Ticket_SLA_Ticket ON Ticket_SLA(Id_Ticket);
GO

-- Índice filtrado: acelera al motor periódico, que solo necesita revisar
-- los SLA que siguen corriendo (los completados/cancelados ya no cambian).
CREATE INDEX IX_Ticket_SLA_Activos ON Ticket_SLA(Etapa)
    WHERE Etapa IN ('EnCurso', 'Pausado');
GO

-- Un ticket no debería tener dos SLA del mismo tipo abiertos a la vez
-- (evita duplicados si sp_SLA_IniciarParaTicket se llamara dos veces).
CREATE UNIQUE INDEX UQ_Ticket_SLA_Abierto ON Ticket_SLA(Id_Ticket, Id_SLA_Definicion)
    WHERE Etapa IN ('EnCurso', 'Pausado');
GO
