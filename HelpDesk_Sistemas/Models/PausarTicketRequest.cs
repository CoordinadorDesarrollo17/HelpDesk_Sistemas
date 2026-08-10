namespace HelpDesk_Sistemas.Models
{
    // Lo que llega en el body de POST api/tickets/{id}/pausar
    public class PausarTicketRequest
    {
        public string TipoMotivo { get; set; } = string.Empty;
        public int? IdTicketRelacionado { get; set; }
    }
}