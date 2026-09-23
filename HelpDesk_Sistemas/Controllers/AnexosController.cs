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
        public async Task<IActionResult> Index(int? idCategoria, int? idSubcategoria, string? buscar, int? resaltar)
        {
            // Viene del botón "Ir a la guía" (validación / detalle del ticket): se busca por el
            // título y se marca la tarjeta exacta, porque varios títulos pueden parecerse.
            ViewBag.IdGuiaResaltada = resaltar;
            ViewBag.BuscarInicial = buscar;
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

            return PhysicalFile(archivo.Value.RutaFisica, ObtenerTipoContenido(archivo.Value.NombreArchivo), archivo.Value.NombreArchivo, enableRangeProcessing: true);
        }

        /// <summary>
        /// Sirve el archivo "en línea" (sin Content-Disposition: attachment), para verlo dentro
        /// del propio sistema —imagen, PDF o video— sin obligar a descargarlo. Solo se usa
        /// desde la vista previa; el resto de formatos (Word, Excel, PowerPoint) el navegador
        /// no los sabe mostrar y se ofrecen solo para descargar.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> VerGuia(int id)
        {
            var archivo = await anexosService.ObtenerArchivoParaDescarga(id);
            if (archivo is null) return NotFound();

            // nosniff: el navegador debe respetar el tipo declarado y no adivinar otro a
            // partir del contenido de un archivo subido por un usuario.
            Response.Headers["X-Content-Type-Options"] = "nosniff";

            return PhysicalFile(archivo.Value.RutaFisica, ObtenerTipoContenido(archivo.Value.NombreArchivo), enableRangeProcessing: true);
        }

        private static string ObtenerTipoContenido(string nombreArchivo)
        {
            var proveedor = new FileExtensionContentTypeProvider();
            return proveedor.TryGetContentType(nombreArchivo, out var tipoContenido)
                ? tipoContenido
                : "application/octet-stream";
        }

        [HttpGet]
        public async Task<IActionResult> BuscarGuias(string buscar, int? idCategoria, int? idSubcategoria, bool priorizarSubcategoria = false)
        {
            var guias = await anexosService.ObtenerGuias(idCategoria, idSubcategoria, buscar, priorizarSubcategoria);
            return Json(guias);
        }
    }
}
