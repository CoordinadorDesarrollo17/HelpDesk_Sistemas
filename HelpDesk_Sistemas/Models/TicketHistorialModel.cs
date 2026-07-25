namespace HelpDesk_Sistemas.Models
{
    public class TicketHistorialModel
    {
        public string? EstadoAnterior { get; set; }
        public string EstadoNuevo { get; set; }
        public string UsuarioAccion { get; set; }
        public string? Comentario { get; set; }
        public DateTime FechaCambio { get; set; }
        public List<TicketHistorialModel> Historial { get; set; } = new();
    }
}
