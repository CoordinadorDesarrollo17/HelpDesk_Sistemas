using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;

namespace HelpDesk_Sistemas.Controllers
{
    public class AnexosController : Controller
    {
        private readonly IAnexosService anexosService;

        public AnexosController(IAnexosService anexosService)
        {
            this.anexosService = anexosService;
        }

        // Todos los roles autenticados pueden ver el listado — no hay chequeo de rol aquí.
        public async Task<IActionResult> Index(int? idCategoria, int? idSubcategoria, string? buscar)
        {
            ViewBag.Categorias = await anexosService.ObtenerCategorias();
            ViewBag.PuedeAdministrar = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";
            var guias = await anexosService.ObtenerGuias(idCategoria, idSubcategoria, buscar);

            // Mismo patrón que TicketsController.ListadoTickets: el refresco de filtros
            // llega por AJAX y solo necesita la lista de tarjetas, no la página completa.
            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return PartialView("_ListaGuias", guias);
            }

            return View(guias);
        }

        [HttpGet]
        public async Task<IActionResult> SubcategoriasPorCategoria(int idCategoria)
        {
            var subcategorias = await anexosService.ObtenerSubcategorias(idCategoria);
            return Json(subcategorias);
        }

        [HttpGet]
        public async Task<IActionResult> CrearGuia()
        {
            if (SesionTemporal.RolActual != "Administrador" && SesionTemporal.RolActual != "Soporte")
            {
                return Forbid();
            }

            ViewBag.Categorias = await anexosService.ObtenerCategorias();
            return PartialView("_CrearGuia", new CrearGuiaModel());
        }

        [HttpPost]
        public async Task<IActionResult> CrearGuia(CrearGuiaModel model)
        {
            if (SesionTemporal.RolActual != "Administrador" && SesionTemporal.RolActual != "Soporte")
            {
                return Forbid();
            }

            if (!ModelState.IsValid)
            {
                ViewBag.Categorias = await anexosService.ObtenerCategorias();
                Response.StatusCode = 400;
                return PartialView("_CrearGuia", model);
            }

            var (exito, mensaje) = await anexosService.CrearGuia(model, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                ModelState.AddModelError(nameof(model.Archivo), mensaje ?? "No se pudo crear la guía.");
                ViewBag.Categorias = await anexosService.ObtenerCategorias();
                Response.StatusCode = 400;
                return PartialView("_CrearGuia", model);
            }

            return Content("OK");
        }

        [HttpPost]
        public async Task<IActionResult> EliminarGuia(int id)
        {
            if (SesionTemporal.RolActual != "Administrador" && SesionTemporal.RolActual != "Soporte")
            {
                return Json(new { exito = false, mensaje = "No tienes permiso para eliminar guías." });
            }

            var exito = await anexosService.EliminarGuia(id);
            return Json(new { exito });
        }

        [HttpGet]
        public async Task<IActionResult> DescargarGuia(int id)
        {
            var archivo = await anexosService.ObtenerArchivoParaDescarga(id);
            if (archivo is null) return NotFound();

            var proveedor = new FileExtensionContentTypeProvider();
            if (!proveedor.TryGetContentType(archivo.Value.NombreArchivo, out var tipoContenido))
            {
                tipoContenido = "application/octet-stream";
            }

            return PhysicalFile(archivo.Value.RutaFisica, tipoContenido, archivo.Value.NombreArchivo, enableRangeProcessing: true);
        }

        [HttpGet]
        public async Task<IActionResult> BuscarGuias(string buscar, int? idCategoria, int? idSubcategoria)
        {
            var guias = await anexosService.ObtenerGuias(idCategoria, idSubcategoria, buscar);
            return Json(guias);
        }
    }
}
