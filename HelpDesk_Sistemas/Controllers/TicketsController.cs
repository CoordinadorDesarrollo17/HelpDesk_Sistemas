using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace HelpDesk_Sistemas.Controllers
{
    public class TicketsController : Controller
    {
        // Implementación/Mejora quedan reservadas a estos roles; el rol "Usuario"
        // (empleado común) solo puede pedir Soporte.
        private static readonly string[] RolesPermitidosImplementacionMejora = { "Supervisor", "Administrador", "Soporte" };

        private readonly ITicketsService ticketsService;
        private readonly ILogger<TicketsController> logger;

        public TicketsController(ITicketsService ticketsService, ILogger<TicketsController> logger)
        {
            this.ticketsService = ticketsService;
            this.logger = logger;
        }

        // ============================================================
        // LISTADO Y FILTROS
        // ============================================================

        public async Task<IActionResult> ListadoTickets(FiltrosTicketsModel model)
        {
            var listaTickets = await ticketsService.ListadoTickets(model, SesionTemporal.UsuarioActualTemporal, SesionTemporal.RolActual);

            ViewBag.Prioridades = await ticketsService.ObtenerPrioridades();
            ViewBag.Estados = await ticketsService.ObtenerEstados();
            ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();
            ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
            ViewBag.Rol = SesionTemporal.RolActual;
            ViewBag.Usuario = SesionTemporal.NombreCompletoActual;
            ViewBag.IdAreaUsuario = SesionTemporal.IdAreaActual;

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return PartialView("_TablaListaTickets", listaTickets);
            }

            return View(listaTickets);
        }

        [HttpGet]
        public async Task<IActionResult> ExportarExcel(FiltrosTicketsModel model)
        {
            var file = await ticketsService.ExportarExcelAsync(model, SesionTemporal.UsuarioActualTemporal, SesionTemporal.RolActual);
            return File(file.Content, file.ContentType, file.FileName);
        }

        // ============================================================
        // DETALLE
        // ============================================================

        [HttpGet]
        public async Task<IActionResult> VerDetalle(int id)
        {
            var detalle = await ticketsService.ObtenerDetalleTicket(id);

            if (detalle is null)
            {
                return NotFound();
            }

            return PartialView("_DetalleTicket", detalle);
        }

        // ============================================================
        // CREACIÓN
        // ============================================================

        [HttpGet]
        public async Task<IActionResult> CrearTicket()
        {
            ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
            ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();
            ViewBag.Sociedades = await ticketsService.ObtenerSociedadesPorUsuario(SesionTemporal.UsuarioActualTemporal);
            ViewBag.Impactos = await ticketsService.ObtenerImpactos();
            ViewBag.Urgencias = await ticketsService.ObtenerUrgencias();
            ViewBag.Matriz = await ticketsService.ObtenerMatrizPrioridad();

            return PartialView("_CrearTicket");
        }

        [HttpGet]
        public async Task<IActionResult> CategoriasPorArea(int idArea)
        {
            var categorias = await ticketsService.ObtenerCategoriasPorArea(idArea);
            return Json(categorias);
        }

        [HttpPost]
        public async Task<IActionResult> CrearTicket(CrearTicketModel model)
        {
            var requiereCategoria = true; // valor por defecto si el tipo no se pudo determinar

            if (model.IdTipoRequerimiento.GetValueOrDefault() > 0)
            {
                requiereCategoria = await ticketsService.TipoRequiereCategoria(model.IdTipoRequerimiento!.Value);

                if (requiereCategoria && model.IdCategoria is null)
                {
                    ModelState.AddModelError(nameof(model.IdCategoria), "Selecciona una categoría para este tipo de requerimiento.");
                }

                if (requiereCategoria && model.IdImpacto is null)
                {
                    ModelState.AddModelError(nameof(model.IdImpacto), "Indica el impacto del inconveniente.");
                }

                if (requiereCategoria && model.IdUrgencia is null)
                {
                    ModelState.AddModelError(nameof(model.IdUrgencia), "Indica la urgencia del inconveniente.");
                }

                if (!requiereCategoria)
                {
                    model.IdCategoria = null;
                    model.IdImpacto = null;
                    model.IdUrgencia = null;

                    if (!RolesPermitidosImplementacionMejora.Contains(SesionTemporal.RolActual))
                    {
                        ModelState.AddModelError(nameof(model.IdTipoRequerimiento), "Solo Soporte, Supervisor o Administrador pueden crear tickets de Implementación/Mejora.");
                    }
                }
            }

            if (model.IdSociedad.HasValue && !await ticketsService.UsuarioPerteneceSociedad(SesionTemporal.UsuarioActualTemporal, model.IdSociedad.Value))
            {
                ModelState.AddModelError(nameof(model.IdSociedad), "La sociedad seleccionada no es válida para tu usuario.");
            }

            if (!ModelState.IsValid)
            {
                ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
                ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();
                ViewBag.Sociedades = await ticketsService.ObtenerSociedadesPorUsuario(SesionTemporal.UsuarioActualTemporal);
                ViewBag.Impactos = await ticketsService.ObtenerImpactos();
                ViewBag.Urgencias = await ticketsService.ObtenerUrgencias();
                ViewBag.Matriz = await ticketsService.ObtenerMatrizPrioridad();

                Response.StatusCode = 400;
                return PartialView("_CrearTicket", model);
            }

            var (idTicket, errores) = await ticketsService.CrearTicket(model, SesionTemporal.UsuarioActualTemporal, requiereCategoria);

            if (errores.Count > 0)
            {
                foreach (var error in errores)
                {
                    ModelState.AddModelError(nameof(model.Archivos), error);
                }

                ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
                ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();
                ViewBag.Sociedades = await ticketsService.ObtenerSociedadesPorUsuario(SesionTemporal.UsuarioActualTemporal);
                ViewBag.Impactos = await ticketsService.ObtenerImpactos();
                ViewBag.Urgencias = await ticketsService.ObtenerUrgencias();
                ViewBag.Matriz = await ticketsService.ObtenerMatrizPrioridad();

                Response.StatusCode = 400;
                return PartialView("_CrearTicket", model);
            }

            return Content("OK");
        }

        // ============================================================
        // FLUJO CONSULTA / SOPORTE
        // ============================================================

        [HttpPost]
        public async Task<IActionResult> TomarTicket(int id)
        {
            var exito = await ticketsService.TomarTicket(id, SesionTemporal.UsuarioActualTemporal);
            var mensaje = exito ? null : "Este ticket necesita una prioridad asignada antes de poder tomarlo, o ya fue tomado por otro usuario.";

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> AtenderTicket(int id)
        {
            var exito = await ticketsService.AtenderTicket(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpGet]
        public async Task<IActionResult> MisTicketsPropios(int idTicketActual)
        {
            var tickets = await ticketsService.ObtenerMisTicketsPropios(SesionTemporal.UsuarioActualTemporal, idTicketActual);
            return Json(tickets);
        }

        [HttpPost]
        public async Task<IActionResult> PausarTicket(int id, string tipoMotivo, int? idTicketRelacionado)
        {
            if (tipoMotivo != "Reunion" && tipoMotivo != "AtencionOtroTicket")
            {
                return Json(new { exito = false, mensaje = "Motivo inválido." });
            }

            if (tipoMotivo == "AtencionOtroTicket" && idTicketRelacionado is null)
            {
                return Json(new { exito = false, mensaje = "Selecciona el ticket que vas a atender." });
            }

            var exito = await ticketsService.PausarTicket(id, SesionTemporal.UsuarioActualTemporal, tipoMotivo, idTicketRelacionado);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ReanudarTicket(int id)
        {
            var exito = await ticketsService.ReanudarTicket(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ValidarTicket(int id, string solucion)
        {
            if (string.IsNullOrWhiteSpace(solucion))
            {
                return Json(new { exito = false, mensaje = "Debes registrar la solución del ticket." });
            }

            var exito = await ticketsService.ValidarTicket(id, SesionTemporal.UsuarioActualTemporal, solucion);
            var mensaje = exito ? null : "El ticket ya no está disponible para validar.";

            return Json(new { exito, mensaje });
        }

        /// <summary>Solución registrada por Soporte, para mostrarla antes de confirmar o devolver.</summary>
        [HttpGet]
        public async Task<IActionResult> ObtenerSolucion(int id)
        {
            var solucion = await ticketsService.ObtenerSolucion(id);

            if (solucion is null)
            {
                return NotFound();
            }

            return Json(new
            {
                codigoTicket = solucion.CodigoTicket,
                solucion = solucion.Solucion,
                resueltoPor = solucion.ResueltoPor,
                fechaSolucion = solucion.FechaSolucion?.ToString("dd/MM/yyyy HH:mm")
            });
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarSolucion(int id)
        {
            var exito = await ticketsService.ConfirmarSolucion(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> DevolverTicket(int id, string motivo)
        {
            if (string.IsNullOrWhiteSpace(motivo))
            {
                return Json(new { exito = false, mensaje = "Debes indicar el motivo por el cual devuelves el ticket." });
            }

            var exito = await ticketsService.DevolverTicket(id, SesionTemporal.UsuarioActualTemporal, motivo);
            var mensaje = exito ? null : "El ticket ya no está disponible para devolver.";

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> AnularTicket(int id, string motivo)
        {
            if (string.IsNullOrWhiteSpace(motivo))
            {
                return Json(new { exito = false, mensaje = "Debes indicar un motivo de anulación." });
            }

            var exito = await ticketsService.AnularTicket(id, SesionTemporal.UsuarioActualTemporal, motivo);
            var mensaje = exito ? null : "El ticket ya no estaba disponible para anular.";

            return Json(new { exito, mensaje });
        }

        // ============================================================
        // PRIORIDAD Y ORDEN DE ATENCIÓN (ambos flujos)
        // ============================================================

        [HttpPost]
        public async Task<IActionResult> AsignarPrioridad(int id, int idPrioridad)
        {
            var exito = await ticketsService.AsignarPrioridad(id, idPrioridad);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> AsignarOrdenAtencion(int id, int orden)
        {
            var (exito, mensaje) = await ticketsService.AsignarOrdenAtencion(id, orden);
            return Json(new { exito, mensaje });
        }

        // ============================================================
        // FLUJO IMPLEMENTACIÓN Y MEJORA
        // ============================================================

        [HttpPost]
        public async Task<IActionResult> TomarLevantamiento(int id)
        {
            var exito = await ticketsService.TomarLevantamiento(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> IniciarDesarrollo(int id)
        {
            var exito = await ticketsService.IniciarDesarrollo(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> EnviarAPruebas(int id)
        {
            var exito = await ticketsService.EnviarAPruebas(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarPruebas(int id)
        {
            var exito = await ticketsService.ConfirmarPruebas(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> CerrarImplementacion(int id)
        {
            var exito = await ticketsService.CerrarImplementacion(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        // ============================================================
        // REASIGNACIÓN (ambos flujos)
        // ============================================================

        [HttpGet]
        public async Task<IActionResult> UsuariosSoportePorArea(int idArea)
        {
            var usuarios = await ticketsService.ObtenerUsuariosSoportePorArea(idArea);
            return Json(usuarios);
        }

        [HttpPost]
        public async Task<IActionResult> ReasignarTicket(int id, int idNuevoUsuario)
        {
            if (idNuevoUsuario <= 0)
            {
                return Json(new { exito = false, mensaje = "Selecciona a quién reasignar el ticket." });
            }

            var exito = await ticketsService.ReasignarTicket(id, idNuevoUsuario, SesionTemporal.UsuarioActualTemporal);
            var mensaje = exito ? null : "El ticket no está disponible para reasignar.";

            return Json(new { exito, mensaje });
        }
    }
}