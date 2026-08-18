namespace HelpDesk_Sistemas.Models
{
    // Dia_Semana: 1=Domingo, 2=Lunes, 3=Martes, 4=Miércoles, 5=Jueves, 6=Viernes, 7=Sábado
    // (misma convención usada por las funciones de calendario en SQL, independiente de DATEFIRST).
    public class SlaHorarioModel
    {
        public int Id { get; set; }
        public int IdCalendario { get; set; }
        public int DiaSemana { get; set; }
        public TimeSpan HoraInicio { get; set; }
        public TimeSpan HoraFin { get; set; }
        public bool Activo { get; set; }
    }
}
