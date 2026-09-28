using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Common
{
    // Cliente de api/auth/validate en la intranet. HttpClient (BaseAddress = endpoint
    // completo, header X-API-Key y timeout) se configura en Program.cs con AddHttpClient.
    public class IntranetAuthClient : IIntranetAuthClient
    {
        private static readonly JsonSerializerOptions OpcionesLectura = new() { PropertyNameCaseInsensitive = true };

        private readonly HttpClient httpClient;
        private readonly ILogger<IntranetAuthClient> logger;

        public IntranetAuthClient(HttpClient httpClient, ILogger<IntranetAuthClient> logger)
        {
            this.httpClient = httpClient;
            this.logger = logger;
        }

        private class LoginRequestDto
        {
            public string Username { get; set; } = string.Empty;
            public string Password { get; set; } = string.Empty;
        }

        // Nombres tal cual los devuelve AuthApiController.LoginResponse en la intranet.
        private class LoginResponseDto
        {
            public bool Success { get; set; }
            public int DocEntry { get; set; }
            public UserDto? User { get; set; }
            public string? Message { get; set; }
        }

        private class UserDto
        {
            public string? Nombres { get; set; }
            public string? Apellidos { get; set; }
        }

        public async Task<IntranetAuthResultModel?> Validar(string usuario, string password)
        {
            try
            {
                var respuesta = await httpClient.PostAsJsonAsync(string.Empty, new LoginRequestDto { Username = usuario, Password = password });

                // 401 (credenciales inválidas) y 429 (demasiados intentos) son respuestas
                // válidas de la API, no fallas de comunicación — se leen igual que un 200.
                var esRespuestaEsperada = respuesta.IsSuccessStatusCode
                    || respuesta.StatusCode == HttpStatusCode.Unauthorized
                    || (int)respuesta.StatusCode == 429;

                if (!esRespuestaEsperada)
                {
                    // 403 (API key/IP), 400, 500, 404 (endpoint no desplegado aún), etc.: no
                    // se puede confirmar nada — se trata igual que "intranet no disponible".
                    logger.LogWarning("La API de autenticación de la intranet respondió {StatusCode} para el usuario {Usuario}.", respuesta.StatusCode, usuario);
                    return null;
                }

                var dto = await respuesta.Content.ReadFromJsonAsync<LoginResponseDto>(OpcionesLectura);
                if (dto is null) return null;

                return new IntranetAuthResultModel
                {
                    Success = dto.Success,
                    DocEntry = dto.DocEntry,
                    Nombres = dto.User?.Nombres,
                    Apellidos = dto.User?.Apellidos,
                    Message = dto.Message
                };
            }
            catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException or JsonException)
            {
                // Intranet caída, tardó más del timeout, o devolvió algo inesperado: se trata
                // como "no se pudo confirmar" (no como "credenciales inválidas") — quien llama
                // decide si cae al login local en ese caso.
                logger.LogWarning(ex, "No se pudo contactar la API de autenticación de la intranet para el usuario {Usuario}.", usuario);
                return null;
            }
        }
    }
}
