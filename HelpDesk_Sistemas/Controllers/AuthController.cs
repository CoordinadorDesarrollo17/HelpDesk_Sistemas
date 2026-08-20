using System.Security.Claims;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    [AllowAnonymous]
    public class AuthController : Controller
    {
        private readonly IUsuariosService usuariosService;

        public AuthController(IUsuariosService usuariosService)
        {
            this.usuariosService = usuariosService;
        }

        [HttpGet]
        public IActionResult Login(string? returnUrl = null)
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                return RedirectToLandingPage(User.IsInRole("Administrador") ? "Administrador" : string.Empty);
            }

            return View(new LoginModel { ReturnUrl = returnUrl });
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var usuario = await usuariosService.ValidarCredenciales(model.Usuario, model.Password);

            if (usuario is null)
            {
                ModelState.AddModelError(string.Empty, "Usuario o contraseña incorrectos.");
                return View(model);
            }

            var claims = new List<Claim>
            {
                new(ClaimTypes.NameIdentifier, usuario.Id.ToString()),
                new(ClaimTypes.Name, usuario.Usuario),
                new(ClaimTypes.Role, usuario.Rol),
                new("NombreCompleto", usuario.NombreCompleto),
                new("IdArea", usuario.IdArea.ToString())
            };

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);

            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal, new AuthenticationProperties
            {
                IsPersistent = true,
                ExpiresUtc = DateTimeOffset.UtcNow.AddHours(8)
            });

            if (!string.IsNullOrEmpty(model.ReturnUrl) && Url.IsLocalUrl(model.ReturnUrl))
            {
                return Redirect(model.ReturnUrl);
            }

            return RedirectToLandingPage(usuario.Rol);
        }

        [HttpPost]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login");
        }

        // Solo Administrador tiene Home/Reportes/SLA; el resto de roles trabaja
        // exclusivamente desde el módulo de Tickets (con su propia bandeja acotada).
        [HttpGet]
        public IActionResult AccesoDenegado()
        {
            if (User.Identity?.IsAuthenticated != true)
            {
                return RedirectToAction("Login");
            }

            return RedirectToLandingPage(User.IsInRole("Administrador") ? "Administrador" : string.Empty);
        }

        private IActionResult RedirectToLandingPage(string rol)
        {
            return rol == "Administrador"
                ? RedirectToAction("Index", "Home")
                : RedirectToAction("ListadoTickets", "Tickets");
        }
    }
}
