namespace HelpDesk_Sistemas.Models
{
    // Agrupa los datos que arma el dashboard del Home.
    public class HomeIndexModel
    {
        public TicketsResumenModel Tickets { get; set; } = new();
        public SlaResumenModel Sla { get; set; } = new();
        public List<TicketSlaRiesgoModel> SlaEnRiesgo { get; set; } = new();
    }
}
