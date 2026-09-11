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
        // Impacto reportado al crear el ticket (NULL para Implementación/Mejora, que no usa
        // la matriz Impacto × Urgencia). Editable por Soporte/Administrador mientras el
        // ticket está Pendiente: el usuario que reporta puede elegir uno que no corresponde.
        public string? Impacto { get; set; }
        public int? IdImpacto { get; set; }
        public int? OrdenAtencion { get; set; }
        public string Solicitante { get; set; }
        public string? Asignado { get; set; }
        // Id del agente que tiene el ticket (NULL si aún nadie lo tomó). Se usa en el
        // listado para decidir qué acciones puede ejecutar el usuario logueado: solo
        // quien lo tiene asignado (o nadie todavía) puede operarlo; un coordinador que
        // ve el ticket de otro agente únicamente puede reasignarlo.
        public int? IdUsuarioAsignado { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int CantidadMismaAsignadoPrioridad { get; set; }
        public int IdArea { get; set; }
        public string? Sociedad { get; set; }
        public TicketSlaModel? SlaRespuesta { get; set; }
        public TicketSlaModel? SlaResolucion { get; set; }
    }
}
