namespace HelpDesk_Sistemas.Models
{
    // Info de SLA para mostrar en el listado/detalle de un ticket.
    // Etapa: "EnCurso" | "Pausado" | "Completado" | "Cancelado"
    // Todos los campos son nullable porque este objeto se arma vía LEFT JOIN
    // (un ticket puede no tener SLA todavía, ej. Implementación/Mejora sin prioridad asignada).
    public class TicketSlaModel
    {
        public int Id { get; set; }
        public string? TipoSla { get; set; }
        public string? Etapa { get; set; }
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaObjetivo { get; set; }
        public DateTime? FechaFin { get; set; }
        public bool? Incumplido { get; set; }
        public bool? AdvertenciaActiva { get; set; }
        public bool? CumplidoATiempo { get; set; }

        // 0-100+, calculado en la consulta contra el calendario laboral de la
        // definición (minutos hábiles transcurridos / minutos objetivo).
        public decimal? PorcentajeConsumido { get; set; }
    }
}
