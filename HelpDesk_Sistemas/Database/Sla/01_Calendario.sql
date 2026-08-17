-- ============================================================
-- Motor de SLA — 01: Calendario laboral
-- Define en qué horarios y qué días corre el reloj de un SLA.
-- Ejecutar contra HELPDESK_V1 (o HELPDESK_V1_SLA_DEV para pruebas).
-- ============================================================

CREATE TABLE Calendario_Laboral (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    Nombre          VARCHAR(100)    NOT NULL,
    Activo          BIT             NOT NULL CONSTRAINT DF_Calendario_Laboral_Activo DEFAULT (1),
    Usu_Creacion    VARCHAR(50)     NULL,
    Fecha_Creacion  DATETIME        NOT NULL CONSTRAINT DF_Calendario_Laboral_Fecha_Creacion DEFAULT (GETDATE())
);
GO

-- Franjas horarias por día de semana. Dia_Semana sigue la convención de
-- DATEPART(WEEKDAY, ...) con SET DATEFIRST 7 (1=Domingo … 7=Sábado), para
-- poder comparar directo contra DATEPART(WEEKDAY, @Fecha) en las funciones.
CREATE TABLE Calendario_Horario (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    Id_Calendario   INT             NOT NULL,
    Dia_Semana      TINYINT         NOT NULL,  -- 1=Domingo, 2=Lunes, ... 7=Sábado
    Hora_Inicio     TIME(0)         NOT NULL,
    Hora_Fin        TIME(0)         NOT NULL,
    Activo          BIT             NOT NULL CONSTRAINT DF_Calendario_Horario_Activo DEFAULT (1),

    CONSTRAINT FK_Calendario_Horario_Calendario FOREIGN KEY (Id_Calendario)
        REFERENCES Calendario_Laboral(Id),
    CONSTRAINT CK_Calendario_Horario_Dia CHECK (Dia_Semana BETWEEN 1 AND 7),
    CONSTRAINT CK_Calendario_Horario_Rango CHECK (Hora_Inicio < Hora_Fin)
);
GO

CREATE INDEX IX_Calendario_Horario_Calendario ON Calendario_Horario(Id_Calendario, Dia_Semana);
GO

CREATE TABLE Calendario_Feriado (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    Id_Calendario   INT             NOT NULL,
    Fecha           DATE            NOT NULL,
    Descripcion     VARCHAR(200)    NULL,
    Usu_Creacion    VARCHAR(50)     NULL,
    Fecha_Creacion  DATETIME        NOT NULL CONSTRAINT DF_Calendario_Feriado_Fecha_Creacion DEFAULT (GETDATE()),

    CONSTRAINT FK_Calendario_Feriado_Calendario FOREIGN KEY (Id_Calendario)
        REFERENCES Calendario_Laboral(Id),
    CONSTRAINT UQ_Calendario_Feriado UNIQUE (Id_Calendario, Fecha)
);
GO
