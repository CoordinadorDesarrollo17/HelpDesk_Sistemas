using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    public class TicketsController : Controller
    {
        private readonly ITicketsService ticketsService;

        //aqui se elije el id del usuario que esta logueado, por ahora es temporal
        private const int UsuarioActualTemporal = 3; // TODO: reemplazar cuando exista login/autenticación

        public TicketsController(ITicketsService ticketsService)
        {
            this.ticketsService = ticketsService;
        }

        public async Task<IActionResult> ListadoTickets(FiltrosTicketsModel model)
        {
            var listaTickets = await ticketsService.ListadoTickets(model, UsuarioActualTemporal);

            ViewBag.Prioridades = await ticketsService.ObtenerPrioridades();
            ViewBag.Estados = await ticketsService.ObtenerEstados();
            ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();
            ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return PartialView("_TablaListaTickets", listaTickets);
            }

            return View(listaTickets);
        }

        [HttpGet]
        public async Task<IActionResult> ExportarExcel(FiltrosTicketsModel model)
        {
            var file = await ticketsService.ExportarExcelAsync(model, UsuarioActualTemporal);
            return File(file.Content, file.ContentType, file.FileName);
        }

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

        [HttpGet]
        public async Task<IActionResult> CrearTicket()
        {
            ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
            ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();

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

                if (requiereCategoria && model.AfectaFuncionamiento is null)
                {
                    ModelState.AddModelError(nameof(model.AfectaFuncionamiento), "Indica si el inconveniente detiene tus funciones o procesos.");
                }

                if (!requiereCategoria)
                {
                    model.IdCategoria = null;
                    model.AfectaFuncionamiento = null;
                }
            }

            if (!ModelState.IsValid)
            {
                ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
                ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();

                Response.StatusCode = 400;
                return PartialView("_CrearTicket", model);
            }

            var (idTicket, errores) = await ticketsService.CrearTicket(model, UsuarioActualTemporal, requiereCategoria);

            if (errores.Count > 0)
            {
                foreach (var error in errores)
                {
                    ModelState.AddModelError(nameof(model.Archivos), error);
                }

                ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
                ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();

                Response.StatusCode = 400;
                return PartialView("_CrearTicket", model);
            }

            return Content("OK");
        }

        [HttpPost]
        public async Task<IActionResult> TomarTicket(int id)
        {
            var exito = await ticketsService.TomarTicket(id, UsuarioActualTemporal);
            var mensaje = exito ? null : "Este ticket necesita una prioridad asignada antes de poder tomarlo, o ya fue tomado por otro usuario.";

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> AnularTicket(int id, string motivo)
        {
            if (string.IsNullOrWhiteSpace(motivo))
            {
                return Json(new { exito = false, mensaje = "Debes indicar un motivo de anulación." });
            }

            var exito = await ticketsService.AnularTicket(id, UsuarioActualTemporal, motivo);
            var mensaje = exito ? null : "El ticket ya no estaba disponible para anular.";

            return Json(new { exito, mensaje });
        }

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

        [HttpPost]
        public async Task<IActionResult> AtenderTicket(int id)
        {
            var exito = await ticketsService.AtenderTicket(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpGet]
        public async Task<IActionResult> MisTicketsPropios(int idTicketActual)
        {
            var tickets = await ticketsService.ObtenerMisTicketsPropios(UsuarioActualTemporal, idTicketActual);
            return Json(tickets);
        }

        [HttpPost]
        public async Task<IActionResult> PausarTicket(int id, string tipoMotivo, int? idTicketRelacionado)
        {
            if(tipoMotivo != "Reunion" && tipoMotivo != "AtencionOtroTicket")
            {
                return Json(new { exito = false, mensaje = "Motivo inválido." });
            }

            if(tipoMotivo == "AtenciónOtroTicket" && idTicketRelacionado is null)
            {
                return Json(new { exito = false, mensaje = "Selecciona el ticket que vas a atender." });
            }

            var exito = await ticketsService.PausarTicket(id, UsuarioActualTemporal, tipoMotivo, idTicketRelacionado);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ReanudarTicket(int id)
        {
            var exito = await ticketsService.ReanudarTicket(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ValidarTicket(int id, string solucion)
        {
            if (string.IsNullOrWhiteSpace(solucion))
            {
                return Json(new { exito = false, mensaje = "Debes registrar la solución del ticket." });
            }
            ///CONTINUAR AQUI
            var exito = await ticketsService.ValidarTicket(id, UsuarioActualTemporal, solucion);
            var mensaje = exito ? null : "El ticket ya no está disponible para validar.";

            return Json(new {exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarSolucion (int id)
        {
            var exito = await ticketsService.ConfirmarSolucion(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> DevolverTicket(int id, string motivo)
        {
            if (string.IsNullOrWhiteSpace(motivo))
            {
                return Json(new { exito = false, mensaje = "Debes indicar el motivo por el cual devuelves el ticket." });
            }

            var exito = await ticketsService.DevolverTicket(id, UsuarioActualTemporal, motivo);
            var mensaje = exito ? null : "El ticket ya no está disponible apra devolver.";

            return Json(new { exito, mensaje });
        }

        //IMPLEMENTACION Y MEJORA
        [HttpPost]
        public async Task<IActionResult> TomarLevantamiento(int id)
        {
            var exito = await ticketsService.TomarLevantamiento(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> IniciarDesarrollo(int id)
        {
            var exito = await ticketsService.IniciarDesarrollo(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> EnviarAPruebas(int id)
        {
            var exito = await ticketsService.EnviarAPruebas(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarPruebas(int id)
        {
            var exito = await ticketsService.ConfirmarPruebas(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> CerrarImplementacion(int id)
        {
            var exito = await ticketsService.CerrarImplementacion(id, UsuarioActualTemporal);
            return Json(new { exito });
        }

        //REASGINAR USUARIO TICKET
        [HttpGet]
        public async Task<IActionResult> UsuariosSoportePorArea(int idArea)
        {
            var usuarios = await ticketsService.ObtenerUsuariosSoportePorArea(idArea);
            return Json(usuarios);
        }

        [HttpPost]
        public async Task<IActionResult> ReasignarTicket(int id, int idNuevoUsuario)
        {
            if(idNuevoUsuario <= 0)
            {
                return Json(new { exito = false, mensaje = "Selecciona a quién reasignar el ticket." });
            }

            var exito = await ticketsService.ReasignarTicket(id, idNuevoUsuario, UsuarioActualTemporal);
            var mensaje = exito ? null : "El ticket no está disponible para reasignar.";

            return Json(new { exito, mensaje });
        }
    }
}
