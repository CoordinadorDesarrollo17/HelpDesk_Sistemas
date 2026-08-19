using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface ISlaRepository
    {
        // ============================================================
        // CALENDARIO LABORAL
        // ============================================================

        Task<List<CatalogoModel>> ObtenerCalendarios();
        Task<SlaCalendarioModel?> ObtenerCalendarioPorId(int id);
        Task<int> CrearCalendario(SlaCalendarioRequest model, string usuarioCreacion);
        Task<bool> RenombrarCalendario(int id, string nombre);
        Task<bool> CambiarActivoCalendario(int id, bool activo);

        Task<int> AgregarHorario(SlaHorarioRequest model);
        Task<bool> ActualizarHorario(int id, SlaHorarioRequest model);
        Task<bool> EliminarHorario(int id);

        Task<int> AgregarFeriado(SlaFeriadoRequest model, string usuarioCreacion);
        Task<bool> ActualizarFeriado(int id, SlaFeriadoRequest model);
        Task<bool> EliminarFeriado(int id);

        // ============================================================
        // DEFINICIONES DE SLA
        // ============================================================

        Task<List<SlaDefinicionModel>> ObtenerDefiniciones();
        Task<SlaDefinicionModel?> ObtenerDefinicionPorId(int id);
        Task<int> CrearDefinicion(SlaDefinicionRequest model, string usuarioCreacion);
        Task<bool> ActualizarDefinicion(int id, SlaDefinicionRequest model, string usuarioModificacion);
        Task<bool> CambiarActivoDefinicion(int id, bool activo);

        // ============================================================
        // CATÁLOGOS AUXILIARES PARA EL FORMULARIO DE DEFINICIONES
        // ============================================================

        /// <summary>Todas las categorías activas, con el nombre de su área para distinguirlas en el combo.</summary>
        Task<List<CatalogoModel>> ObtenerTodasLasCategorias();

        /// <summary>Todas las sociedades activas (sin filtrar por usuario, a diferencia de ObtenerSociedadesPorUsuario).</summary>
        Task<List<CatalogoModel>> ObtenerTodasLasSociedades();

        // ============================================================
        // DASHBOARD DE CUMPLIMIENTO
        // ============================================================

        Task<SlaDashboardModel> ObtenerDashboard();
    }
}
