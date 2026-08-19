namespace HelpDesk_Sistemas.Models
{
    public class SlaDashboardModel
    {
        public SlaResumenModel Resumen { get; set; } = new();
        public List<SlaResumenPorGrupoModel> PorPrioridad { get; set; } = new();
        public List<SlaResumenPorGrupoModel> PorAgente { get; set; } = new();
        public List<TicketSlaRiesgoModel> EnRiesgoOIncumplidos { get; set; } = new();
    }

    public class SlaResumenModel
    {
        public int TotalCompletados { get; set; }
        public int CumplidosATiempo { get; set; }
        public int IncumplidosCompletados { get; set; }
        public int EnCursoActivos { get; set; }
        public int EnRiesgo { get; set; }
        public int IncumplidosEnCurso { get; set; }

        public decimal PorcentajeCumplimiento => TotalCompletados == 0
            ? 0
            : Math.Round(100m * CumplidosATiempo / TotalCompletados, 1);
    }

    // Fila agregada por prioridad o por agente (Grupo = nombre de la prioridad/agente).
    public class SlaResumenPorGrupoModel
    {
        public string Grupo { get; set; } = string.Empty;
        public int Completados { get; set; }
        public int CumplidosATiempo { get; set; }
        public int Incumplidos { get; set; }

        public decimal PorcentajeCumplimiento => Completados == 0
            ? 0
            : Math.Round(100m * CumplidosATiempo / Completados, 1);
    }

    public class TicketSlaRiesgoModel
    {
        public int IdTicket { get; set; }
        public string CodigoTicket { get; set; } = string.Empty;
        public string TipoSla { get; set; } = string.Empty;
        public string Estado { get; set; } = string.Empty;
        public string? Prioridad { get; set; }
        public string? Asignado { get; set; }
        public DateTime FechaObjetivo { get; set; }
        public bool Incumplido { get; set; }
        public bool AdvertenciaActiva { get; set; }

        /// <summary>Etapa del SLA: "EnCurso"/"Pausado" (todavía corriendo) o "Completado" (ya terminó).</summary>
        public string Etapa { get; set; } = string.Empty;

        /// <summary>"en-riesgo" | "incumplido-activo" | "incumplido-finalizado" — para filtrar y pintar la fila.</summary>
        public string Categoria => Etapa == "Completado"
            ? "incumplido-finalizado"
            : Incumplido ? "incumplido-activo" : "en-riesgo";
    }
}
