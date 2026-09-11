namespace HelpDesk_Sistemas.Models
{
    public class ReporteGeneralModel
    {
        public ReporteResumenModel Resumen { get; set; } = new();
        public List<ReporteTendenciaPuntoModel> Tendencia { get; set; } = new();
        public List<ReporteDistribucionModel> PorTipo { get; set; } = new();
        public List<ReporteDistribucionModel> PorArea { get; set; } = new();
        public List<ReporteDistribucionModel> PorPrioridad { get; set; } = new();
        public List<ReporteAgenteModel> PorAgente { get; set; } = new();
        public List<ReporteTiempoTicketModel> DetalleTiempos { get; set; } = new();
    }

    public class ReporteResumenModel
    {
        public int TotalCreados { get; set; }
        public int TotalCerrados { get; set; }
        public int TicketsActivos { get; set; }

        // Tiempo corrido (wall-clock), en horas. Los 3 tramos de la resolución de un ticket:
        //   Cola          = creación -> asignación   (lo que el ticket esperó antes de ser tomado)
        //   TrabajoAgente = asignación -> cierre     (lo que tardó el asesor ya trabajándolo)
        //   Resolucion    = creación -> cierre       ( = Cola + TrabajoAgente )
        public decimal? TiempoPromedioColaHoras { get; set; }
        public decimal? TiempoPromedioTrabajoAgenteHoras { get; set; }
        public decimal? TiempoPromedioResolucionHoras { get; set; }
    }

    // Un punto de la serie de tendencia (Fecha -> Creados/Cerrados ese día).
    public class ReporteTendenciaPuntoModel
    {
        public DateTime Fecha { get; set; }
        public int Creados { get; set; }
        public int Cerrados { get; set; }
    }

    // Fila genérica de distribución (por tipo, área o prioridad).
    public class ReporteDistribucionModel
    {
        public string Etiqueta { get; set; } = string.Empty;
        public int Cantidad { get; set; }
    }

    public class ReporteAgenteModel
    {
        public string Agente { get; set; } = string.Empty;
        public int Asignados { get; set; }
        public int Cerrados { get; set; }
        public int Activos { get; set; }

        // Promedio de horas corridas que los tickets de este agente esperaron en cola
        // (creación -> asignación) antes de que él los tomara.
        public decimal? TiempoPromedioColaHoras { get; set; }

        // Promedio de horas corridas que el agente tardó ya trabajándolo (asignación -> cierre).
        public decimal? TiempoPromedioResolucionHoras { get; set; }

        public int Devoluciones { get; set; }
    }

    // Una fila por ticket con sus tres tramos, en horas hábiles (mismo cálculo que el SLA)
    // y en horas corridas. Se arma desde la vista vw_TiemposTicket; solo para la hoja de
    // detalle del Excel.
    public class ReporteTiempoTicketModel
    {
        public string CodigoTicket { get; set; } = string.Empty;
        public string? EstadoActual { get; set; }
        public string? Area { get; set; }
        public string? Prioridad { get; set; }
        public string? AsesorAsignado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime? FechaToma { get; set; }
        public DateTime? FechaResolucion { get; set; }
        public int? MinColaHabil { get; set; }
        public int? MinTrabajoAsesorHabil { get; set; }
        public int? MinResolucionTotalHabil { get; set; }
        public int? MinColaReloj { get; set; }
        public int? MinTrabajoAsesorReloj { get; set; }
        public int? MinResolucionTotalReloj { get; set; }
    }
}
