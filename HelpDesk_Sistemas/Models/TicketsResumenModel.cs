namespace HelpDesk_Sistemas.Models
{
    // Conteos para las tarjetas KPI del Home.
    public class TicketsResumenModel
    {
        public int Pendientes { get; set; }
        public int EnCurso { get; set; }
        public int EnPausa { get; set; }
        public int MisAsignados { get; set; }
    }
}
