namespace HelpDesk_Sistemas.Models
{
    public class ReporteFiltroModel
    {
        public DateTime FechaInicio { get; set; } = DateTime.Today.AddDays(-30);
        public DateTime FechaFin { get; set; } = DateTime.Today;

        /// <summary>Filtra solo la sección "Productividad por agente" por área de soporte (TI/Sistemas/Desarrollo).</summary>
        public int? IdAreaAgente { get; set; }
    }
}
