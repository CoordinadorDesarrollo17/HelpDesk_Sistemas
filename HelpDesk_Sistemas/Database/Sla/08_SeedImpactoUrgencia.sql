-- ============================================================
-- Motor de SLA — 08: Datos iniciales de Impacto/Urgencia/Matriz_Prioridad
-- AJUSTAR según el criterio real de triage del equipo; esto deja la matriz
-- operativa con un criterio razonable por defecto:
--   Soporte  puede llegar hasta Urgente (incidentes reales).
--   Consulta tiene tope Media (una pregunta no debería marcarse Urgente).
-- ============================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

INSERT INTO Impacto (Nombre, Orden) VALUES
    ('Individual', 1),
    ('Área', 2),
    ('Organización', 3);

INSERT INTO Urgencia (Nombre, Orden) VALUES
    ('Baja', 1),
    ('Media', 2),
    ('Alta', 3);
GO

DECLARE @IdConsulta INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Consulta');
DECLARE @IdSoporte  INT = (SELECT Id FROM Tipo_Requerimiento WHERE Nombre = 'Soporte');

DECLARE @Individual INT = (SELECT Id FROM Impacto WHERE Nombre = 'Individual');
DECLARE @Area       INT = (SELECT Id FROM Impacto WHERE Nombre = 'Área');
DECLARE @Org        INT = (SELECT Id FROM Impacto WHERE Nombre = 'Organización');

DECLARE @UBaja  INT = (SELECT Id FROM Urgencia WHERE Nombre = 'Baja');
DECLARE @UMedia INT = (SELECT Id FROM Urgencia WHERE Nombre = 'Media');
DECLARE @UAlta  INT = (SELECT Id FROM Urgencia WHERE Nombre = 'Alta');

DECLARE @PBaja    INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Baja');
DECLARE @PMedia   INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Media');
DECLARE @PAlta    INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Alta');
DECLARE @PUrgente INT = (SELECT Id FROM Prioridad WHERE Nombre = 'Urgente');

-- Soporte: rango completo hasta Urgente
INSERT INTO Matriz_Prioridad (Id_Tipo_Req, Id_Impacto, Id_Urgencia, Id_Prioridad) VALUES
    (@IdSoporte, @Individual, @UBaja,  @PBaja),
    (@IdSoporte, @Individual, @UMedia, @PBaja),
    (@IdSoporte, @Individual, @UAlta,  @PMedia),
    (@IdSoporte, @Area,       @UBaja,  @PBaja),
    (@IdSoporte, @Area,       @UMedia, @PMedia),
    (@IdSoporte, @Area,       @UAlta,  @PAlta),
    (@IdSoporte, @Org,        @UBaja,  @PMedia),
    (@IdSoporte, @Org,        @UMedia, @PAlta),
    (@IdSoporte, @Org,        @UAlta,  @PUrgente);

-- Consulta: tope Media (una pregunta no bloquea nada, nunca debería marcarse Urgente)
INSERT INTO Matriz_Prioridad (Id_Tipo_Req, Id_Impacto, Id_Urgencia, Id_Prioridad) VALUES
    (@IdConsulta, @Individual, @UBaja,  @PBaja),
    (@IdConsulta, @Individual, @UMedia, @PBaja),
    (@IdConsulta, @Individual, @UAlta,  @PBaja),
    (@IdConsulta, @Area,       @UBaja,  @PBaja),
    (@IdConsulta, @Area,       @UMedia, @PBaja),
    (@IdConsulta, @Area,       @UAlta,  @PMedia),
    (@IdConsulta, @Org,        @UBaja,  @PBaja),
    (@IdConsulta, @Org,        @UMedia, @PMedia),
    (@IdConsulta, @Org,        @UAlta,  @PMedia);
GO
