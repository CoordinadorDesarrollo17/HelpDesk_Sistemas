using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Services
{
    public class SlaService : ISlaService
    {
        private readonly ISlaRepository slaRepository;
        private static readonly string[] TiposSlaValidos = { "Respuesta", "Resolucion" };

        public SlaService(ISlaRepository slaRepository)
        {
            this.slaRepository = slaRepository;
        }

        // ============================================================
        // CALENDARIO LABORAL
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerCalendarios() => await slaRepository.ObtenerCalendarios();

        public async Task<SlaCalendarioModel?> ObtenerCalendarioPorId(int id) => await slaRepository.ObtenerCalendarioPorId(id);

        public async Task<int> CrearCalendario(SlaCalendarioRequest model, string usuarioCreacion)
            => await slaRepository.CrearCalendario(model, usuarioCreacion);

        public async Task<bool> RenombrarCalendario(int id, string nombre) => await slaRepository.RenombrarCalendario(id, nombre);

        public async Task<bool> CambiarActivoCalendario(int id, bool activo) => await slaRepository.CambiarActivoCalendario(id, activo);

        public async Task<(bool Exito, string? Mensaje)> AgregarHorario(SlaHorarioRequest model)
        {
            if (model.DiaSemana < 1 || model.DiaSemana > 7)
                return (false, "El día de la semana debe estar entre 1 (Domingo) y 7 (Sábado).");

            if (model.HoraInicio >= model.HoraFin)
                return (false, "La hora de inicio debe ser menor a la hora de fin.");

            await slaRepository.AgregarHorario(model);
            return (true, null);
        }

        public async Task<(bool Exito, string? Mensaje)> ActualizarHorario(int id, SlaHorarioRequest model)
        {
            if (model.DiaSemana < 1 || model.DiaSemana > 7)
                return (false, "El día de la semana debe estar entre 1 (Domingo) y 7 (Sábado).");

            if (model.HoraInicio >= model.HoraFin)
                return (false, "La hora de inicio debe ser menor a la hora de fin.");

            var actualizado = await slaRepository.ActualizarHorario(id, model);
            return actualizado ? (true, null) : (false, "No se encontró el horario a actualizar.");
        }

        public async Task<bool> EliminarHorario(int id) => await slaRepository.EliminarHorario(id);

        public async Task<(bool Exito, string? Mensaje)> AgregarFeriado(SlaFeriadoRequest model, string usuarioCreacion)
        {
            await slaRepository.AgregarFeriado(model, usuarioCreacion);
            return (true, null);
        }

        public async Task<(bool Exito, string? Mensaje)> ActualizarFeriado(int id, SlaFeriadoRequest model)
        {
            var actualizado = await slaRepository.ActualizarFeriado(id, model);
            return actualizado ? (true, null) : (false, "No se encontró el feriado a actualizar.");
        }

        public async Task<bool> EliminarFeriado(int id) => await slaRepository.EliminarFeriado(id);

        // ============================================================
        // DEFINICIONES DE SLA
        // ============================================================

        public async Task<List<SlaDefinicionModel>> ObtenerDefiniciones() => await slaRepository.ObtenerDefiniciones();

        public async Task<SlaDefinicionModel?> ObtenerDefinicionPorId(int id) => await slaRepository.ObtenerDefinicionPorId(id);

        public async Task<(bool Exito, string? Mensaje, int IdDefinicion)> CrearDefinicion(SlaDefinicionRequest model, string usuarioCreacion)
        {
            var validacion = ValidarDefinicion(model);
            if (validacion is not null) return (false, validacion, 0);

            var id = await slaRepository.CrearDefinicion(model, usuarioCreacion);
            return (true, null, id);
        }

        public async Task<(bool Exito, string? Mensaje)> ActualizarDefinicion(int id, SlaDefinicionRequest model, string usuarioModificacion)
        {
            var validacion = ValidarDefinicion(model);
            if (validacion is not null) return (false, validacion);

            var exito = await slaRepository.ActualizarDefinicion(id, model, usuarioModificacion);
            return (exito, exito ? null : "No se encontró la definición de SLA a actualizar.");
        }

        public async Task<bool> CambiarActivoDefinicion(int id, bool activo) => await slaRepository.CambiarActivoDefinicion(id, activo);

        // ============================================================
        // CATÁLOGOS AUXILIARES
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerTodasLasCategorias() => await slaRepository.ObtenerTodasLasCategorias();

        public async Task<List<CatalogoModel>> ObtenerTodasLasSociedades() => await slaRepository.ObtenerTodasLasSociedades();

        // ============================================================
        // DASHBOARD DE CUMPLIMIENTO
        // ============================================================

        public async Task<SlaDashboardModel> ObtenerDashboard() => await slaRepository.ObtenerDashboard();

        // ============================================================
        // VALIDACIÓN
        // ============================================================

        private static string? ValidarDefinicion(SlaDefinicionRequest model)
        {
            if (string.IsNullOrWhiteSpace(model.Nombre))
                return "El nombre de la definición es obligatorio.";

            if (!TiposSlaValidos.Contains(model.TipoSla))
                return "tipoSla debe ser 'Respuesta' o 'Resolucion'.";

            if (model.DuracionMinutos <= 0)
                return "La duración objetivo debe ser mayor a 0 minutos.";

            if (model.PorcentajeAdvertencia < 1 || model.PorcentajeAdvertencia > 100)
                return "El porcentaje de advertencia debe estar entre 1 y 100.";

            if (model.IdCalendario <= 0)
                return "Debes seleccionar un calendario laboral.";

            return null;
        }
    }
}
