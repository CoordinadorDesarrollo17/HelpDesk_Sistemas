namespace HelpDesk_Sistemas.Models
{
    // Body para POST/PUT api/sla/definiciones. Las condiciones en NULL
    // quedan como comodín (aplican a cualquier valor de esa dimensión).
    public class SlaDefinicionRequest
    {
        public string Nombre { get; set; } = string.Empty;
        public string TipoSla { get; set; } = string.Empty; // "Respuesta" | "Resolucion"

        public int? IdTipoReq { get; set; }
        public int? IdCategoria { get; set; }
        public int? IdPrioridad { get; set; }
        public int? IdSociedad { get; set; }

        public int IdCalendario { get; set; }
        public int DuracionMinutos { get; set; }
        public byte PorcentajeAdvertencia { get; set; } = 80;
        public bool Reactivable { get; set; }
    }
}
