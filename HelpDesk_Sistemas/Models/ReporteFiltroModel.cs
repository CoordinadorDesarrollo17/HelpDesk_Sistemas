namespace HelpDesk_Sistemas.Models
{
    public class ReporteFiltroModel
    {
        public DateTime FechaInicio { get; set; } = DateTime.Today.AddDays(-30);
        public DateTime FechaFin { get; set; } = DateTime.Today;
    }
}
