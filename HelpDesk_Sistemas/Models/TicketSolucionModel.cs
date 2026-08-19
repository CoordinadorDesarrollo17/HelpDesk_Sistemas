namespace HelpDesk_Sistemas.Models
{
    /// <summary>
    /// Solución registrada por Soporte, que el solicitante revisa antes de
    /// confirmar o devolver el ticket.
    /// </summary>
    public class TicketSolucionModel
    {
        public string CodigoTicket { get; set; } = string.Empty;
        public string? Solucion { get; set; }
        public string? ResueltoPor { get; set; }
        public DateTime? FechaSolucion { get; set; }
    }
}
