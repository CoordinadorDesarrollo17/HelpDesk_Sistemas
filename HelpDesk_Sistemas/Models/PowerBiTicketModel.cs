namespace HelpDesk_Sistemas.Models
{
    // Fila plana de ticket para la API de Power BI: sin recortes de rol/usuario y con el
    // SLA de Respuesta/Resolución aplanado en la misma fila (nada de objetos anidados),
    // para que se pueda usar directo como tabla de hechos sin expandir columnas.
    public class PowerBiTicketModel
    {
        public int Id { get; set; }
        public string CodigoTicket { get; set; } = string.Empty;
        public string? Sociedad { get; set; }
        public string Area { get; set; } = string.Empty;
        public string? AreaSolicitante { get; set; }
        public string TipoAtencion { get; set; } = string.Empty;
        public string Flujo { get; set; } = string.Empty;
        public string? Categoria { get; set; }
        public string? Sistema { get; set; }
        public string Estado { get; set; } = string.Empty;
        public string? Prioridad { get; set; }
        public string? Impacto { get; set; }
        public string? Urgencia { get; set; }
        public string Solicitante { get; set; } = string.Empty;
        public string? Asignado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime? FechaAsignacion { get; set; }
        public DateTime? FechaAtencion { get; set; }
        public DateTime? FechaCierre { get; set; }

        public string? SlaRespuestaEtapa { get; set; }
        public decimal? SlaRespuestaPorcentajeConsumido { get; set; }
        public bool? SlaRespuestaIncumplido { get; set; }

        public string? SlaResolucionEtapa { get; set; }
        public decimal? SlaResolucionPorcentajeConsumido { get; set; }
        public bool? SlaResolucionIncumplido { get; set; }
    }
}
