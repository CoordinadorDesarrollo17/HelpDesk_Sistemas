namespace HelpDesk_Sistemas.Models
{
    public class SlaFeriadoModel
    {
        public int Id { get; set; }
        public int IdCalendario { get; set; }
        public DateTime Fecha { get; set; }
        public string? Descripcion { get; set; }
    }
}
