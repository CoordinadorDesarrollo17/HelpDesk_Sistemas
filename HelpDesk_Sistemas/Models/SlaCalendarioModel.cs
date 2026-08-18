namespace HelpDesk_Sistemas.Models
{
    public class SlaCalendarioModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public bool Activo { get; set; }
        public List<SlaHorarioModel> Horarios { get; set; } = new();
        public List<SlaFeriadoModel> Feriados { get; set; } = new();
    }
}
