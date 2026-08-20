using System.Security.Claims;

namespace HelpDesk_Sistemas.Common
{
    // Expone el usuario autenticado actual (vía cookie de sesión, ver AuthController).
    // Se conserva el nombre "SesionTemporal"/"UsuarioActualTemporal" para no tener que
    // tocar cada punto del código que ya los usa — ya no es temporal, ahora lee la
    // sesión real en vez de un usuario fijo.
    public static class SesionTemporal
    {
        private static IHttpContextAccessor? httpContextAccessor;

        public static void Configurar(IHttpContextAccessor accessor)
        {
            httpContextAccessor = accessor;
        }

        public static int UsuarioActualTemporal
        {
            get
            {
                var claim = httpContextAccessor?.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier);
                return claim != null && int.TryParse(claim.Value, out var id) ? id : 0;
            }
        }

        public static string RolActual =>
            httpContextAccessor?.HttpContext?.User.FindFirst(ClaimTypes.Role)?.Value ?? string.Empty;

        public static string NombreCompletoActual =>
            httpContextAccessor?.HttpContext?.User.FindFirst("NombreCompleto")?.Value ?? string.Empty;

        public static int IdAreaActual
        {
            get
            {
                var claim = httpContextAccessor?.HttpContext?.User.FindFirst("IdArea");
                return claim != null && int.TryParse(claim.Value, out var idArea) ? idArea : 0;
            }
        }

        public static string UsuarioActual =>
            httpContextAccessor?.HttpContext?.User.Identity?.Name ?? string.Empty;
    }
}
