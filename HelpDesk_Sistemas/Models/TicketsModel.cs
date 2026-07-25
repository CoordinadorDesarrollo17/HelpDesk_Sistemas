namespace HelpDesk_Sistemas.Models
{
    public class TicketsModel
    {
        public int IdTicket { get; set; }
        public string CodigoTicket { get; set; }
        public string TipoRequerimiento { get; set; }
        public string Area { get; set; }
        public string? Categoria { get; set; }
        public string Estado { get; set; }
        public string? Prioridad { get; set; }
        public int? OrdenAtencion { get; set; }
        public string Solicitante { get; set; }
        public string? Asignado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public bool? AfectaFuncionamiento { get; set; }
        public int CantidadMismaAsignadoPrioridad { get; set; }
        public int IdArea { get; set; }
    }
}
