namespace HelpDesk_Sistemas.Models
{
    //solo lo que el usuario llenó al crear el ticket: el formulario original
    public class TicketDetalleModel
    {
        public int idTicket { get; set; }
        public string CodigoTicket { get; set; }
        public string TipoRequerimiento { get; set; }
        public string Area { get; set; }
        public string? Categoria { get; set; }
        public string Detalle { get; set; }
        public string? Prioridad { get; set; }

        // Tickets nuevos usan Impacto/Urgencia; los históricos (previos a la matriz
        // de prioridad) solo tienen AfectaFuncionamiento. Se muestran ambos casos.
        public string? Impacto { get; set; }
        public string? Urgencia { get; set; }
        public bool? AfectaFuncionamiento { get; set; }
        public List<TicketAdjuntoModel> Adjuntos { get; set; } = new();
        public List<TicketHistorialModel> Historial { get; set; } = new();
        public string? Sociedad { get; set; }
        public TicketSlaModel? SlaRespuesta { get; set; }
        public TicketSlaModel? SlaResolucion { get; set; }
    }
}
