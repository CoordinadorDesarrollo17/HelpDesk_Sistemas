namespace HelpDesk_Sistemas.Models
{
    // Una fila de Matriz_Prioridad, para calcular en vivo (JS) la prioridad
    // estimada mientras el usuario llena Impacto/Urgencia en el formulario.
    public class MatrizPrioridadModel
    {
        public int IdTipoReq { get; set; }
        public int IdImpacto { get; set; }
        public int IdUrgencia { get; set; }
        public string Prioridad { get; set; } = string.Empty;
    }
}
