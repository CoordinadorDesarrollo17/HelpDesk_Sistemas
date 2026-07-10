using ClosedXML.Excel;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using HelpDesk_Sistemas.Services;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    public class ClientesController : Controller
    {
        private readonly IClientesService clientesService;

        public ClientesController(IClientesService clientesService)
        {
            this.clientesService = clientesService;
        }
        public async Task<IActionResult> ListadoClientes(FiltrosClientesModel model)
        {

            var listaClientes = await clientesService.ListadoClientes(model);

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest") //nos dice si es una peticion AJAX
            {
                return PartialView("_TablaListaClientes", listaClientes);
            }

            return View(listaClientes);
        }

        [HttpGet]
        public async Task<IActionResult> ExportarExcel(FiltrosClientesModel model)
        {
            var file = await clientesService.ExportarExcelAsync(model);
            return File(file.Content, file.ContentType, file.FileName);
        }

        [HttpGet]
        public IActionResult CrearCliente()
        {
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> CrearCliente(ClientesModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var creado = await clientesService.CrearCliente(model);
            if (creado)
            {
                return RedirectToAction("ListadoClientes");
            }

            ModelState.AddModelError(string.Empty, "No se pudo crear el cliente. Inténtelo de nuevo.");
            return View(model);
        }
    }
}
