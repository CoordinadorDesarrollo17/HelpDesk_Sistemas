namespace HelpDesk_Sistemas.Models
{
    // Pausa por refrigerio abierta hace más de 1 hora, pendiente de reanudar automáticamente.
    public class PausaVencidaModel
    {
        public int IdTicket { get; set; }
        public int IdUsuarioAccion { get; set; }
    }
}
