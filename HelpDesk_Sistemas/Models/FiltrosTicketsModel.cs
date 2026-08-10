namespace HelpDesk_Sistemas.Models
{
    public class FiltrosTicketsModel
    {
        public string Buscar { get; set; }
        public int? IdEstado { get; set; }
        public int? IdArea { get; set; }
        public int? IdTipoRequerimiento { get; set; }
        public int? IdPrioridad { get; set; }
        public PaginacionModel Paginacion { get; set; } = new();
    }
}
