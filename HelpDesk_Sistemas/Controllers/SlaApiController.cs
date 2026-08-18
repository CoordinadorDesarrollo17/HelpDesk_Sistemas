using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    [ApiController]
    [Route("api/sla")]
    [Authorize(Roles = "Administrador")]
    public class SlaApiController : ControllerBase
    {
        private readonly ISlaService slaService;

        public SlaApiController(ISlaService slaService)
        {
            this.slaService = slaService;
        }

        // ======================== CALENDARIO LABORAL ========================

        /// <summary>Lista los calendarios laborales activos (combo).</summary>
        [HttpGet("calendarios")]
        public async Task<IActionResult> ObtenerCalendarios()
        {
            var calendarios = await slaService.ObtenerCalendarios();
            return Ok(calendarios);
        }

        /// <summary>Detalle de un calendario, con sus horarios y feriados.</summary>
        [HttpGet("calendarios/{id}")]
        public async Task<IActionResult> ObtenerCalendarioPorId(int id)
        {
            var calendario = await slaService.ObtenerCalendarioPorId(id);

            if (calendario is null)
            {
                return NotFound(new { mensaje = $"No se encontró el calendario con Id {id}." });
            }

            return Ok(calendario);
        }

        /// <summary>Crea un calendario laboral nuevo.</summary>
        [HttpPost("calendarios")]
        public async Task<IActionResult> CrearCalendario(SlaCalendarioRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Nombre))
            {
                return BadRequest(new { mensaje = "El nombre del calendario es obligatorio." });
            }

            var id = await slaService.CrearCalendario(request, SesionTemporal.UsuarioActualTemporal.ToString());
            return CreatedAtAction(nameof(ObtenerCalendarioPorId), new { id }, new { idCalendario = id });
        }

        /// <summary>Renombra un calendario laboral.</summary>
        [HttpPut("calendarios/{id}")]
        public async Task<IActionResult> RenombrarCalendario(int id, SlaCalendarioRequest request)
        {
            var exito = await slaService.RenombrarCalendario(id, request.Nombre);

            if (!exito)
            {
                return BadRequest(new { mensaje = "No se encontró el calendario a renombrar." });
            }

            return Ok(new { mensaje = "Calendario actualizado." });
        }

        /// <summary>Activa o desactiva un calendario laboral.</summary>
        [HttpPost("calendarios/{id}/activo")]
        public async Task<IActionResult> CambiarActivoCalendario(int id, [FromBody] bool activo)
        {
            var exito = await slaService.CambiarActivoCalendario(id, activo);

            if (!exito)
            {
                return BadRequest(new { mensaje = "No se encontró el calendario indicado." });
            }

            return Ok(new { mensaje = "Calendario actualizado." });
        }

        /// <summary>Agrega una franja horaria (día + hora inicio/fin) a un calendario.</summary>
        [HttpPost("horarios")]
        public async Task<IActionResult> AgregarHorario(SlaHorarioRequest request)
        {
            var (exito, mensaje) = await slaService.AgregarHorario(request);

            if (!exito)
            {
                return BadRequest(new { mensaje });
            }

            return Ok(new { mensaje = "Horario agregado." });
        }

        /// <summary>Elimina una franja horaria de un calendario.</summary>
        [HttpDelete("horarios/{id}")]
        public async Task<IActionResult> EliminarHorario(int id)
        {
            var exito = await slaService.EliminarHorario(id);

            if (!exito)
            {
                return BadRequest(new { mensaje = "No se encontró el horario indicado." });
            }

            return Ok(new { mensaje = "Horario eliminado." });
        }

        /// <summary>Agrega un feriado (fecha excluida del calendario) a un calendario.</summary>
        [HttpPost("feriados")]
        public async Task<IActionResult> AgregarFeriado(SlaFeriadoRequest request)
        {
            var (exito, mensaje) = await slaService.AgregarFeriado(request, SesionTemporal.UsuarioActualTemporal.ToString());

            if (!exito)
            {
                return BadRequest(new { mensaje });
            }

            return Ok(new { mensaje = "Feriado agregado." });
        }

        /// <summary>Elimina un feriado de un calendario.</summary>
        [HttpDelete("feriados/{id}")]
        public async Task<IActionResult> EliminarFeriado(int id)
        {
            var exito = await slaService.EliminarFeriado(id);

            if (!exito)
            {
                return BadRequest(new { mensaje = "No se encontró el feriado indicado." });
            }

            return Ok(new { mensaje = "Feriado eliminado." });
        }

        // ======================== DEFINICIONES DE SLA ========================

        /// <summary>Lista todas las definiciones de SLA (Respuesta y Resolución).</summary>
        [HttpGet("definiciones")]
        public async Task<IActionResult> ObtenerDefiniciones()
        {
            var definiciones = await slaService.ObtenerDefiniciones();
            return Ok(definiciones);
        }

        /// <summary>Detalle de una definición de SLA.</summary>
        [HttpGet("definiciones/{id}")]
        public async Task<IActionResult> ObtenerDefinicionPorId(int id)
        {
            var definicion = await slaService.ObtenerDefinicionPorId(id);

            if (definicion is null)
            {
                return NotFound(new { mensaje = $"No se encontró la definición de SLA con Id {id}." });
            }

            return Ok(definicion);
        }

        /// <summary>Crea una definición de SLA (Respuesta o Resolución) para una combinación de
        /// tipo/categoría/prioridad/sociedad (los campos en null aplican a cualquier valor).</summary>
        [HttpPost("definiciones")]
        public async Task<IActionResult> CrearDefinicion(SlaDefinicionRequest request)
        {
            var (exito, mensaje, idDefinicion) = await slaService.CrearDefinicion(request, SesionTemporal.UsuarioActualTemporal.ToString());

            if (!exito)
            {
                return BadRequest(new { mensaje });
            }

            return CreatedAtAction(nameof(ObtenerDefinicionPorId), new { id = idDefinicion }, new { idDefinicion });
        }

        /// <summary>Actualiza una definición de SLA existente.</summary>
        [HttpPut("definiciones/{id}")]
        public async Task<IActionResult> ActualizarDefinicion(int id, SlaDefinicionRequest request)
        {
            var (exito, mensaje) = await slaService.ActualizarDefinicion(id, request, SesionTemporal.UsuarioActualTemporal.ToString());

            if (!exito)
            {
                return BadRequest(new { mensaje });
            }

            return Ok(new { mensaje = "Definición de SLA actualizada." });
        }

        /// <summary>Activa o desactiva una definición de SLA (las inactivas dejan de aplicarse a tickets nuevos).</summary>
        [HttpPost("definiciones/{id}/activo")]
        public async Task<IActionResult> CambiarActivoDefinicion(int id, [FromBody] bool activo)
        {
            var exito = await slaService.CambiarActivoDefinicion(id, activo);

            if (!exito)
            {
                return BadRequest(new { mensaje = "No se encontró la definición de SLA indicada." });
            }

            return Ok(new { mensaje = "Definición actualizada." });
        }

        // ======================== CATÁLOGOS AUXILIARES ========================

        /// <summary>Todas las categorías activas (con su área), para el formulario de definiciones.</summary>
        [HttpGet("catalogos/categorias")]
        public async Task<IActionResult> ObtenerTodasLasCategorias()
        {
            var categorias = await slaService.ObtenerTodasLasCategorias();
            return Ok(categorias);
        }
    }
}
