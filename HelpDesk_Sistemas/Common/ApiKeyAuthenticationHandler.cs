using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Text.Encodings.Web;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace HelpDesk_Sistemas.Common
{
    // Esquema de autenticación separado de la cookie de sesión, para integraciones
    // externas de solo lectura (hoy: la API de Power BI). El cliente manda el header
    // "X-Api-Key" con el valor configurado en appsettings ("PowerBi:ApiKey"); no hay
    // usuario detrás, es una única credencial compartida para esa integración.
    public class ApiKeyAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        public const string SchemeName = "ApiKey";
        private const string HeaderName = "X-Api-Key";

        private readonly IConfiguration configuration;

        public ApiKeyAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            IConfiguration configuration)
            : base(options, logger, encoder)
        {
            this.configuration = configuration;
        }

        protected override Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.TryGetValue(HeaderName, out var valoresHeader))
            {
                return Task.FromResult(AuthenticateResult.Fail($"Falta el header {HeaderName}."));
            }

            var claveEsperada = configuration["PowerBi:ApiKey"];

            if (string.IsNullOrEmpty(claveEsperada) || !ClaveValida(valoresHeader.ToString(), claveEsperada))
            {
                return Task.FromResult(AuthenticateResult.Fail("API key inválida."));
            }

            var claims = new[] { new Claim(ClaimTypes.Name, "PowerBI"), new Claim(ClaimTypes.Role, "PowerBI") };
            var identity = new ClaimsIdentity(claims, SchemeName);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, SchemeName);

            return Task.FromResult(AuthenticateResult.Success(ticket));
        }

        // Comparación en tiempo constante: evita que alguien deduzca la clave midiendo
        // cuánto tarda la respuesta según cuántos caracteres coinciden.
        private static bool ClaveValida(string recibida, string esperada)
        {
            var bytesRecibidos = Encoding.UTF8.GetBytes(recibida);
            var bytesEsperados = Encoding.UTF8.GetBytes(esperada);

            if (bytesRecibidos.Length != bytesEsperados.Length) return false;

            return CryptographicOperations.FixedTimeEquals(bytesRecibidos, bytesEsperados);
        }
    }
}
