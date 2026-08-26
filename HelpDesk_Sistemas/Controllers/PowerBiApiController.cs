using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    // API de solo lectura para integraciones externas de reportes (Power BI). Separada
    // de TicketsApiController/SlaApiController: esta no depende de la cookie de sesión ni
    // de "quién soy" — se autentica con el header X-Api-Key (ver ApiKeyAuthenticationHandler)
    // y devuelve el extracto completo de la organización, sin los recortes de la bandeja de
    // trabajo de un usuario (sin TOP, sin filtro por rol). Ver Docs/Conexion_PowerBI.md.
    [ApiController]
    [Route("api/powerbi")]
    [Authorize(AuthenticationSchemes = ApiKeyAuthenticationHandler.SchemeName)]
    public class PowerBiApiController : ControllerBase
    {
        private readonly IPowerBiService powerBiService;

        public PowerBiApiController(IPowerBiService powerBiService)
        {
            this.powerBiService = powerBiService;
        }

        /// <summary>Tabla de hechos: un ticket por fila, con su SLA de Respuesta/Resolución aplanado.</summary>
        [HttpGet("tickets")]
        public async Task<IActionResult> Tickets(DateTime? fechaInicio, DateTime? fechaFin)
        {
            return Ok(await powerBiService.ObtenerTickets(fechaInicio, fechaFin));
        }

        [HttpGet("departamentos")]
        public async Task<IActionResult> Departamentos() => Ok(await powerBiService.ObtenerDepartamentos());

        [HttpGet("areas")]
        public async Task<IActionResult> Areas() => Ok(await powerBiService.ObtenerAreas());

        [HttpGet("sociedades")]
        public async Task<IActionResult> Sociedades() => Ok(await powerBiService.ObtenerSociedades());

        [HttpGet("tipos-atencion")]
        public async Task<IActionResult> TiposAtencion() => Ok(await powerBiService.ObtenerTiposAtencion());

        [HttpGet("categorias")]
        public async Task<IActionResult> Categorias() => Ok(await powerBiService.ObtenerCategorias());

        [HttpGet("sistemas")]
        public async Task<IActionResult> Sistemas() => Ok(await powerBiService.ObtenerSistemas());

        [HttpGet("estados")]
        public async Task<IActionResult> Estados() => Ok(await powerBiService.ObtenerEstados());

        [HttpGet("prioridades")]
        public async Task<IActionResult> Prioridades() => Ok(await powerBiService.ObtenerPrioridades());

        /// <summary>Nunca incluye password/hash.</summary>
        [HttpGet("usuarios")]
        public async Task<IActionResult> Usuarios() => Ok(await powerBiService.ObtenerUsuarios());
    }
}
