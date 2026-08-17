namespace HelpDesk_Sistemas.Models
{
    public class SlaCalendarioRequest
    {
        public string Nombre { get; set; } = string.Empty;
    }

    public class SlaHorarioRequest
    {
        public int IdCalendario { get; set; }
        public int DiaSemana { get; set; }
        public TimeSpan HoraInicio { get; set; }
        public TimeSpan HoraFin { get; set; }
    }

    public class SlaFeriadoRequest
    {
        public int IdCalendario { get; set; }
        public DateTime Fecha { get; set; }
        public string? Descripcion { get; set; }
    }
}
