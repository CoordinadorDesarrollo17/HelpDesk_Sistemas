-- ============================================================
-- Motor de SLA — 07: Matriz de prioridad (Impacto × Urgencia)
--
-- Reemplaza el Sí/No "¿Afecta funcionamiento?" (que solo producía Alta/Baja)
-- por una matriz configurable Impacto × Urgencia → Prioridad, con topes
-- distintos por Tipo_Requerimiento (ej. Consulta nunca pasa de Media,
-- Soporte puede llegar a Urgente). No se toca ni se elimina la columna
-- Tickets.Afecta_Funcionamiento — se conserva por los tickets históricos
-- que ya la tienen; simplemente deja de usarse para tickets nuevos.
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE Impacto (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  VARCHAR(50) NOT NULL,
    Orden   INT         NOT NULL,
    Activo  BIT         NOT NULL CONSTRAINT DF_Impacto_Activo DEFAULT (1)
);
GO

CREATE TABLE Urgencia (
    Id      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre  VARCHAR(50) NOT NULL,
    Orden   INT         NOT NULL,
    Activo  BIT         NOT NULL CONSTRAINT DF_Urgencia_Activo DEFAULT (1)
);
GO

-- Una fila por combinación (Tipo_Req, Impacto, Urgencia) → Prioridad resultante.
-- Id_Tipo_Req es obligatorio (no comodín): la matriz solo aplica a los tipos que
-- piden Impacto/Urgencia (Consulta, Soporte). Implementación/Mejora siguen con
-- asignación manual de prioridad, como ya funcionaba.
CREATE TABLE Matriz_Prioridad (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    Id_Tipo_Req     INT NOT NULL,
    Id_Impacto      INT NOT NULL,
    Id_Urgencia     INT NOT NULL,
    Id_Prioridad    INT NOT NULL,

    CONSTRAINT FK_Matriz_Prioridad_TipoReq  FOREIGN KEY (Id_Tipo_Req)  REFERENCES Tipo_Requerimiento(Id),
    CONSTRAINT FK_Matriz_Prioridad_Impacto  FOREIGN KEY (Id_Impacto)   REFERENCES Impacto(Id),
    CONSTRAINT FK_Matriz_Prioridad_Urgencia FOREIGN KEY (Id_Urgencia)  REFERENCES Urgencia(Id),
    CONSTRAINT FK_Matriz_Prioridad_Prioridad FOREIGN KEY (Id_Prioridad) REFERENCES Prioridad(Id),
    CONSTRAINT UQ_Matriz_Prioridad UNIQUE (Id_Tipo_Req, Id_Impacto, Id_Urgencia)
);
GO

ALTER TABLE Tickets ADD Id_Impacto INT NULL;
ALTER TABLE Tickets ADD Id_Urgencia INT NULL;
GO

ALTER TABLE Tickets ADD CONSTRAINT FK_Tickets_Impacto FOREIGN KEY (Id_Impacto) REFERENCES Impacto(Id);
ALTER TABLE Tickets ADD CONSTRAINT FK_Tickets_Urgencia FOREIGN KEY (Id_Urgencia) REFERENCES Urgencia(Id);
GO
