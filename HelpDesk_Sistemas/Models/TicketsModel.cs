namespace HelpDesk_Sistemas.Models
{
    public class TicketsModel
    {
        public int IdTicket { get; set; }
        public string CodigoTicket { get; set; }
        public string TipoRequerimiento { get; set; }
        // 'Soporte' (flujo corto) o 'ImplementacionMejora' (flujo largo) — reemplaza
        // el viejo chequeo por nombre "TipoRequerimiento == 'Soporte'" en la vista.
        public string Flujo { get; set; }
        public string Area { get; set; }
        // Área del ticket (a quién va dirigido). Distinta de AreaSolicitante, que es el
        // área propia del usuario que pidió el ticket (puede ser otra área, ej. alguien
        // de Desarrollo pidiendo algo a Soporte TI).
        public string? AreaSolicitante { get; set; }
        public string? Categoria { get; set; }
        public string? Sistema { get; set; }
        public string Estado { get; set; }
        public string? Prioridad { get; set; }
        public int? OrdenAtencion { get; set; }
        public string Solicitante { get; set; }
        public string? Asignado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int CantidadMismaAsignadoPrioridad { get; set; }
        public int IdArea { get; set; }
        public string? Sociedad { get; set; }
        public TicketSlaModel? SlaRespuesta { get; set; }
        public TicketSlaModel? SlaResolucion { get; set; }
    }
}
