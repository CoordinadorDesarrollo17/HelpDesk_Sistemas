namespace HelpDesk_Sistemas.Models
{
    // TipoSla: "Respuesta" | "Resolucion"
    public class SlaDefinicionModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string TipoSla { get; set; }

        public int? IdTipoReq { get; set; }
        public string? TipoRequerimiento { get; set; }   // NULL = aplica a cualquier tipo (comodín)

        public int? IdCategoria { get; set; }
        public string? Categoria { get; set; }            // NULL = aplica a cualquier categoría

        public int? IdPrioridad { get; set; }
        public string? Prioridad { get; set; }             // NULL = aplica a cualquier prioridad

        public int? IdSociedad { get; set; }
        public string? Sociedad { get; set; }               // NULL = aplica a cualquier sociedad

        public int IdCalendario { get; set; }
        public string Calendario { get; set; }

        public int DuracionMinutos { get; set; }
        public byte PorcentajeAdvertencia { get; set; }
        public bool Reactivable { get; set; }
        public int Especificidad { get; set; }
        public bool Activo { get; set; }
    }
}
