namespace HelpDesk_Sistemas.Models
{
    public class FiltrosClientesModel
    {
        public string Buscar { get; set; }
        public PaginacionModel Paginacion { get; set; } = new();
    }
}
