using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    // Administración de SLA: definiciones (Respuesta/Resolución) y calendario laboral.
    [Authorize(Roles = "Administrador")]
    public class SlaController : Controller
    {
        private readonly ISlaService slaService;
        private readonly ITicketsService ticketsService;

        public SlaController(ISlaService slaService, ITicketsService ticketsService)
        {
            this.slaService = slaService;
            this.ticketsService = ticketsService;
        }

        // ============================================================
        // DASHBOARD DE CUMPLIMIENTO
        // ============================================================

        public async Task<IActionResult> Dashboard()
        {
            var dashboard = await slaService.ObtenerDashboard();
            return View(dashboard);
        }

        // ============================================================
        // DEFINICIONES DE SLA
        // ============================================================

        public async Task<IActionResult> Index()
        {
            var definiciones = await slaService.ObtenerDefiniciones();
            return View(definiciones);
        }

        [HttpGet]
        public async Task<IActionResult> CrearEditarDefinicion(int? id)
        {
            await CargarCatalogosDefinicion();

            if (id.HasValue)
            {
                var definicion = await slaService.ObtenerDefinicionPorId(id.Value);
                if (definicion is null) return NotFound();
                return PartialView("_CrearEditarDefinicion", definicion);
            }

            return PartialView("_CrearEditarDefinicion", null);
        }

        [HttpPost]
        public async Task<IActionResult> GuardarDefinicion(int? id, SlaDefinicionRequest model)
        {
            var usuario = SesionTemporal.UsuarioActualTemporal.ToString();

            if (id.HasValue)
            {
                var (exito, mensaje) = await slaService.ActualizarDefinicion(id.Value, model, usuario);
                return Json(new { exito, mensaje });
            }
            else
            {
                var (exito, mensaje, _) = await slaService.CrearDefinicion(model, usuario);
                return Json(new { exito, mensaje });
            }
        }

        [HttpPost]
        public async Task<IActionResult> CambiarActivoDefinicion(int id, bool activo)
        {
            var exito = await slaService.CambiarActivoDefinicion(id, activo);
            return Json(new { exito });
        }

        private async Task CargarCatalogosDefinicion()
        {
            ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
            ViewBag.Categorias = await slaService.ObtenerTodasLasCategorias();
            ViewBag.Prioridades = await ticketsService.ObtenerPrioridades();
            ViewBag.Sociedades = await slaService.ObtenerTodasLasSociedades();
            ViewBag.Calendarios = await slaService.ObtenerCalendarios();
        }

        // ============================================================
        // CALENDARIO LABORAL
        // ============================================================

        public async Task<IActionResult> Calendario(int? id)
        {
            var calendarios = await slaService.ObtenerCalendarios();
            ViewBag.Calendarios = calendarios;

            var idSeleccionado = id ?? calendarios.FirstOrDefault()?.Id;
            ViewBag.IdCalendarioSeleccionado = idSeleccionado;

            SlaCalendarioModel? calendario = idSeleccionado.HasValue
                ? await slaService.ObtenerCalendarioPorId(idSeleccionado.Value)
                : null;

            return View(calendario);
        }

        [HttpPost]
        public async Task<IActionResult> CrearCalendario(string nombre)
        {
            if (string.IsNullOrWhiteSpace(nombre))
            {
                return Json(new { exito = false, mensaje = "El nombre del calendario es obligatorio." });
            }

            var id = await slaService.CrearCalendario(new SlaCalendarioRequest { Nombre = nombre }, SesionTemporal.UsuarioActualTemporal.ToString());
            return Json(new { exito = true, idCalendario = id });
        }

        [HttpPost]
        public async Task<IActionResult> AgregarHorario(int idCalendario, int diaSemana, TimeSpan horaInicio, TimeSpan horaFin)
        {
            var (exito, mensaje) = await slaService.AgregarHorario(new SlaHorarioRequest
            {
                IdCalendario = idCalendario,
                DiaSemana = diaSemana,
                HoraInicio = horaInicio,
                HoraFin = horaFin
            });

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> ActualizarHorario(int id, int idCalendario, int diaSemana, TimeSpan horaInicio, TimeSpan horaFin)
        {
            var (exito, mensaje) = await slaService.ActualizarHorario(id, new SlaHorarioRequest
            {
                IdCalendario = idCalendario,
                DiaSemana = diaSemana,
                HoraInicio = horaInicio,
                HoraFin = horaFin
            });

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> EliminarHorario(int id)
        {
            var exito = await slaService.EliminarHorario(id);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> AgregarFeriado(int idCalendario, DateTime fecha, string? descripcion)
        {
            var (exito, mensaje) = await slaService.AgregarFeriado(new SlaFeriadoRequest
            {
                IdCalendario = idCalendario,
                Fecha = fecha,
                Descripcion = descripcion
            }, SesionTemporal.UsuarioActualTemporal.ToString());

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> ActualizarFeriado(int id, int idCalendario, DateTime fecha, string? descripcion)
        {
            var (exito, mensaje) = await slaService.ActualizarFeriado(id, new SlaFeriadoRequest
            {
                IdCalendario = idCalendario,
                Fecha = fecha,
                Descripcion = descripcion
            });

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> EliminarFeriado(int id)
        {
            var exito = await slaService.EliminarFeriado(id);
            return Json(new { exito });
        }
    }
}
