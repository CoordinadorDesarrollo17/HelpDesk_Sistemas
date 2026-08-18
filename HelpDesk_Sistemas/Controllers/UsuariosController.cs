using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    [Authorize(Roles = "Administrador")]
    public class UsuariosController : Controller
    {
        private readonly IUsuariosService usuariosService;

        public UsuariosController(IUsuariosService usuariosService)
        {
            this.usuariosService = usuariosService;
        }

        public async Task<IActionResult> Index()
        {
            var usuarios = await usuariosService.ObtenerUsuarios();
            return View(usuarios);
        }

        [HttpGet]
        public async Task<IActionResult> CrearUsuario()
        {
            await CargarCatalogos();
            return PartialView("_CrearUsuario", new CrearUsuarioModel());
        }

        [HttpPost]
        public async Task<IActionResult> CrearUsuario(CrearUsuarioModel model)
        {
            if (!ModelState.IsValid)
            {
                await CargarCatalogos();
                Response.StatusCode = 400;
                return PartialView("_CrearUsuario", model);
            }

            var (exito, mensaje, usuarioGenerado, passwordGenerada) = await usuariosService.CrearUsuario(model, SesionTemporal.UsuarioActual);

            if (!exito)
            {
                ModelState.AddModelError(string.Empty, mensaje ?? "No se pudo crear el usuario.");
                await CargarCatalogos();
                Response.StatusCode = 400;
                return PartialView("_CrearUsuario", model);
            }

            return Json(new { exito = true, usuario = usuarioGenerado, password = passwordGenerada });
        }

        [HttpPost]
        public async Task<IActionResult> CambiarActivo(int id, bool activo)
        {
            var exito = await usuariosService.CambiarActivo(id, activo);
            return Json(new { exito });
        }

        private async Task CargarCatalogos()
        {
            ViewBag.Roles = await usuariosService.ObtenerRoles();
            ViewBag.Areas = await usuariosService.ObtenerTodasLasAreas();
            ViewBag.Supervisores = await usuariosService.ObtenerPosiblesSupervisores();
        }
    }
}
