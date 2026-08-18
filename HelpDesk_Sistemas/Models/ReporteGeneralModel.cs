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
    }

    public class ReporteResumenModel
    {
        public int TotalCreados { get; set; }
        public int TotalCerrados { get; set; }
        public int TicketsActivos { get; set; }
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
        public decimal? TiempoPromedioResolucionHoras { get; set; }
        public int Devoluciones { get; set; }
    }
}
