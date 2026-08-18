-- ============================================================
-- Motor de SLA — 02: Definiciones de SLA
-- Equivalente a "SLA Definition" de ServiceNow: condición de aplicación
-- (NULL = comodín en esa dimensión) + duración + calendario + umbral de
-- advertencia. Cuando varias definiciones matchean un ticket, se usa la
-- de mayor Especificidad (más condiciones puestas = más específica).
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE SLA_Definicion (
    Id                      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre                  VARCHAR(150)    NOT NULL,
    Tipo_SLA                VARCHAR(20)     NOT NULL,   -- 'Respuesta' | 'Resolucion'

    -- Condición de aplicación: NULL = comodín, aplica a cualquier valor de esa dimensión.
    Id_Tipo_Req             INT             NULL,
    Id_Categoria            INT             NULL,
    Id_Prioridad            INT             NULL,
    Id_Sociedad             INT             NULL,

    Id_Calendario           INT             NOT NULL,
    Duracion_Minutos        INT             NOT NULL,
    Porcentaje_Advertencia  TINYINT         NOT NULL CONSTRAINT DF_SLA_Definicion_PorcAdvertencia DEFAULT (80),
    Reactivable             BIT             NOT NULL CONSTRAINT DF_SLA_Definicion_Reactivable DEFAULT (0),

    -- Cuántas condiciones no son NULL: usado para desempatar cuando varias
    -- definiciones matchean el mismo ticket (gana la más específica).
    Especificidad AS (
        (CASE WHEN Id_Tipo_Req  IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN Id_Categoria IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN Id_Prioridad IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN Id_Sociedad  IS NULL THEN 0 ELSE 1 END)
    ) PERSISTED,

    Activo                  BIT             NOT NULL CONSTRAINT DF_SLA_Definicion_Activo DEFAULT (1),
    Usu_Creacion            VARCHAR(50)     NULL,
    Fecha_Creacion          DATETIME        NOT NULL CONSTRAINT DF_SLA_Definicion_Fecha_Creacion DEFAULT (GETDATE()),
    Usu_Modificacion        VARCHAR(50)     NULL,
    Fecha_Modificacion      DATETIME        NULL,

    CONSTRAINT CK_SLA_Definicion_Tipo CHECK (Tipo_SLA IN ('Respuesta', 'Resolucion')),
    CONSTRAINT CK_SLA_Definicion_PorcAdvertencia CHECK (Porcentaje_Advertencia BETWEEN 1 AND 100),
    CONSTRAINT CK_SLA_Definicion_Duracion CHECK (Duracion_Minutos > 0),

    CONSTRAINT FK_SLA_Definicion_TipoReq   FOREIGN KEY (Id_Tipo_Req)   REFERENCES Tipo_Requerimiento(Id),
    CONSTRAINT FK_SLA_Definicion_Categoria FOREIGN KEY (Id_Categoria)  REFERENCES Categoria(Id),
    CONSTRAINT FK_SLA_Definicion_Prioridad FOREIGN KEY (Id_Prioridad)  REFERENCES Prioridad(Id),
    CONSTRAINT FK_SLA_Definicion_Sociedad  FOREIGN KEY (Id_Sociedad)   REFERENCES Sociedad(Id),
    CONSTRAINT FK_SLA_Definicion_Calendario FOREIGN KEY (Id_Calendario) REFERENCES Calendario_Laboral(Id)
);
GO

CREATE INDEX IX_SLA_Definicion_Match ON SLA_Definicion(Tipo_SLA, Activo, Id_Tipo_Req, Id_Categoria, Id_Prioridad, Id_Sociedad);
GO
