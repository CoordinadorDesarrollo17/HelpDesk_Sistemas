using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface ISlaService
    {
        // ============================================================
        // CALENDARIO LABORAL
        // ============================================================

        Task<List<CatalogoModel>> ObtenerCalendarios();
        Task<SlaCalendarioModel?> ObtenerCalendarioPorId(int id);
        Task<int> CrearCalendario(SlaCalendarioRequest model, string usuarioCreacion);
        Task<bool> RenombrarCalendario(int id, string nombre);
        Task<bool> CambiarActivoCalendario(int id, bool activo);

        Task<(bool Exito, string? Mensaje)> AgregarHorario(SlaHorarioRequest model);
        Task<(bool Exito, string? Mensaje)> ActualizarHorario(int id, SlaHorarioRequest model);
        Task<bool> EliminarHorario(int id);

        Task<(bool Exito, string? Mensaje)> AgregarFeriado(SlaFeriadoRequest model, string usuarioCreacion);
        Task<(bool Exito, string? Mensaje)> ActualizarFeriado(int id, SlaFeriadoRequest model);
        Task<bool> EliminarFeriado(int id);

        // ============================================================
        // DEFINICIONES DE SLA
        // ============================================================

        Task<List<SlaDefinicionModel>> ObtenerDefiniciones();
        Task<SlaDefinicionModel?> ObtenerDefinicionPorId(int id);
        Task<(bool Exito, string? Mensaje, int IdDefinicion)> CrearDefinicion(SlaDefinicionRequest model, string usuarioCreacion);
        Task<(bool Exito, string? Mensaje)> ActualizarDefinicion(int id, SlaDefinicionRequest model, string usuarioModificacion);
        Task<bool> CambiarActivoDefinicion(int id, bool activo);

        // ============================================================
        // CATÁLOGOS AUXILIARES
        // ============================================================

        Task<List<CatalogoModel>> ObtenerTodasLasCategorias();
        Task<List<CatalogoModel>> ObtenerTodasLasSociedades();

        // ============================================================
        // DASHBOARD DE CUMPLIMIENTO
        // ============================================================

        Task<SlaDashboardModel> ObtenerDashboard();
    }
}
