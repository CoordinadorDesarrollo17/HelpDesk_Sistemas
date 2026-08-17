using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    [ApiController]                    // Habilita validaciones automáticas y respuestas JSON por defecto
    [Route("api/tickets")]             // Ruta explícita: no depende del nombre de la clase ni de convenciones
    public class TicketsApiController : ControllerBase   // ControllerBase, NO Controller: sin soporte de Vistas
    {
        private readonly ITicketsService ticketsService;

        public TicketsApiController(ITicketsService ticketsService)
        {
            this.ticketsService = ticketsService;
        }

        // ======================== LECTURA Y CREACIÓN ======================

        /// <summary>Obtiene el detalle de un ticket por su Id.</summary>
        /// <param name="id">Id numérico del ticket.</param>
        /// <response code="200">El ticket fue encontrado.</response>
        /// <response code="404">No existe un ticket con ese Id.</response>
        [HttpGet("{id}")]
        public async Task<IActionResult> ObtenerPorId(int id)
        {
            var ticket = await ticketsService.ObtenerTicketPorId(id);

            if (ticket is null)
            {
                return NotFound(new { mensaje = $"No se encontró el ticket con Id {id}." });
            }

            return Ok(ticket);
        }

        /// <summary>Lista tickets con filtros y paginación.</summary>
        /// <remarks>Ejemplo: GET /api/tickets?Buscar=impresora&amp;Paginacion.Page=1&amp;Paginacion.PageSize=10</remarks>
        [HttpGet]
        public async Task<IActionResult> ListadoFiltrado([FromQuery] FiltrosTicketsModel model)
        {
            var listado = await ticketsService.ListadoTickets(model, SesionTemporal.UsuarioActualTemporal);

            var respuesta = new
            {
                totalRegistros = listado.TotalItemCount,
                paginaActual = listado.PageNumber,
                totalPaginas = listado.PageCount,
                datos = listado
            };

            return Ok(respuesta);
        }

        /// <summary>Crea un ticket nuevo (Consulta, Soporte, Implementación o Mejora).</summary>
        /// <remarks>
        /// Para Consulta/Soporte, idCategoria, idImpacto e idUrgencia son obligatorios y la prioridad
        /// se calcula automáticamente vía la matriz Impacto × Urgencia. Para Implementación/Mejora,
        /// los tres se ignoran y la prioridad queda pendiente hasta usar POST /api/tickets/{id}/prioridad.
        /// </remarks>
        /// <response code="201">Ticket creado. El header Location apunta a su detalle.</response>
        /// <response code="400">Datos inválidos (categoría/sociedad faltante o incorrecta).</response>
        [HttpPost]
        public async Task<IActionResult> CrearTicket([FromForm] CrearTicketModel model)
        {
            // [ApiController] ya validó los [Required]/[MinLength] del modelo antes
            // de llegar aquí. Si algo falló, el cliente ya recibió un 400 automático.

            var requiereCategoria = true; // valor por defecto si el tipo no se pudo determinar

            if (model.IdTipoRequerimiento.GetValueOrDefault() > 0)
            {
                requiereCategoria = await ticketsService.TipoRequiereCategoria(model.IdTipoRequerimiento!.Value);

                if (requiereCategoria && model.IdCategoria is null)
                {
                    return BadRequest(new { mensaje = "Selecciona una categoría para este tipo de requerimiento." });
                }

                if (requiereCategoria && model.IdImpacto is null)
                {
                    return BadRequest(new { mensaje = "Indica el impacto del inconveniente (idImpacto)." });
                }

                if (requiereCategoria && model.IdUrgencia is null)
                {
                    return BadRequest(new { mensaje = "Indica la urgencia del inconveniente (idUrgencia)." });
                }

                if (!requiereCategoria)
                {
                    model.IdCategoria = null;
                    model.IdImpacto = null;
                    model.IdUrgencia = null;
                }
            }

            if (model.IdSociedad.HasValue &&
                !await ticketsService.UsuarioPerteneceSociedad(SesionTemporal.UsuarioActualTemporal, model.IdSociedad.Value))
            {
                return BadRequest(new { mensaje = "La sociedad seleccionada no es válida para este usuario." });
            }

            var (idTicket, errores) = await ticketsService.CrearTicket(model, SesionTemporal.UsuarioActualTemporal, requiereCategoria);

            if (errores.Count > 0)
            {
                return BadRequest(new { errores });
            }

            return CreatedAtAction(nameof(ObtenerPorId), new { id = idTicket }, new { idTicket });
        }

        /// <summary>Asigna prioridad a un ticket Pendiente (obligatorio para Implementación/Mejora antes de tomarlo).</summary>
        /// <param name="id">Id del ticket.</param>
        /// <param name="request">Id de la prioridad a asignar (ver catálogo Prioridad).</param>
        [HttpPost("{id}/prioridad")]
        public async Task<IActionResult> AsignarPrioridad(int id, [FromBody] AsignarPrioridadRequest request)
        {
            if (request.IdPrioridad == 0)
            {
                return BadRequest(new { mensaje = "El ticket no cuenta con prioridad." });
            }

            var exito = await ticketsService.AsignarPrioridad(id, request.IdPrioridad);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para asignar prioridad o ya tiene una asignada." });
            }

            return Ok(new { mensaje = "Prioridad asignada." });
        }

        // ======================== CONSULTA Y SOPORTE =======================
        // Pendiente -> En revisión -> En atención -> [En pausa] -> En validación -> Cerrado / Anulado

        /// <summary>Toma un ticket Pendiente y lo pasa a "En revisión" (requiere prioridad ya asignada).</summary>
        [HttpPost("{id}/tomar")]
        public async Task<IActionResult> Tomar(int id)
        {
            var exito = await ticketsService.TomarTicket(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no tiene prioridad asignada o ya fue tomado por otro usuario." });
            }

            return Ok(new { mensaje = "Ticket tomado." });
        }

        /// <summary>Pasa el ticket de "En revisión" a "En atención".</summary>
        [HttpPost("{id}/atender")]
        public async Task<IActionResult> Atender(int id)
        {
            var exito = await ticketsService.AtenderTicket(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para pasar a atención (verifica su estado actual)." });
            }

            return Ok(new { mensaje = "Ticket puesto en atención." });
        }

        /// <summary>Pausa un ticket "En atención" por reunión u otro ticket propio.</summary>
        /// <param name="id">Id del ticket a pausar.</param>
        /// <param name="request">Motivo de la pausa (Reunion o AtencionOtroTicket) y, si aplica, el ticket relacionado.</param>
        [HttpPost("{id}/pausar")]
        public async Task<IActionResult> Pausar(int id, [FromBody] PausarTicketRequest request)
        {
            if (request.TipoMotivo != "Reunion" && request.TipoMotivo != "AtencionOtroTicket")
            {
                return BadRequest(new { mensaje = "tipoMotivo debe ser 'Reunion' o 'AtencionOtroTicket'." });
            }

            if (request.TipoMotivo == "AtencionOtroTicket" && request.IdTicketRelacionado is null)
            {
                return BadRequest(new { mensaje = "Indica idTicketRelacionado cuando el motivo es AtencionOtroTicket." });
            }

            var exito = await ticketsService.PausarTicket(id, SesionTemporal.UsuarioActualTemporal, request.TipoMotivo, request.IdTicketRelacionado);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para pausar (verifica que esté En atención)." });
            }

            return Ok(new { mensaje = "Ticket pausado." });
        }

        /// <summary>Reanuda un ticket "En pausa" y lo regresa a "En atención".</summary>
        [HttpPost("{id}/reanudar")]
        public async Task<IActionResult> ReanudarTicket(int id)
        {
            var exito = await ticketsService.ReanudarTicket(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no se ha pausado, y no es posible reanudar." });
            }

            return Ok(new { mensaje = "Ticket reanudado." });
        }

        /// <summary>Registra la solución de un ticket "En atención" y lo pasa a "En validación".</summary>
        /// <param name="id">Id del ticket.</param>
        /// <param name="request">Texto de la solución registrada por Soporte.</param>
        [HttpPost("{id}/validar")]
        public async Task<IActionResult> Validar(int id, [FromBody] ValidarTicketRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Solucion))
            {
                return BadRequest(new { mensaje = "El ticket no cuenta con una solución." });
            }

            var exito = await ticketsService.ValidarTicket(id, SesionTemporal.UsuarioActualTemporal, request.Solucion);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para validar (verifica que esté en atención)." });
            }

            return Ok(new { mensaje = "Ticket validado." });
        }

        /// <summary>El solicitante da conformidad a la solución: "En validación" -> "Cerrado".</summary>
        [HttpPost("{id}/confirmar-solucion")]
        public async Task<IActionResult> ConfirmarSolucion(int id)
        {
            var exito = await ticketsService.ConfirmarSolucion(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no se ha confirmado, es posible que no esté en estado 'En validación'" });
            }

            return Ok(new { mensaje = "Solucion confirmada." });
        }

        /// <summary>El solicitante rechaza la solución: "En validación" -> "En atención" nuevamente.</summary>
        /// <param name="id">Id del ticket.</param>
        /// <param name="request">Motivo por el cual se devuelve el ticket.</param>
        [HttpPost("{id}/devolver")]
        public async Task<IActionResult> DevolverTicket(int id, [FromBody] DevolverTicketRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Motivo))
            {
                return BadRequest(new { mensaje = "Debes indicar el motivo por el cual devuelves el ticket." });
            }

            var exito = await ticketsService.DevolverTicket(id, SesionTemporal.UsuarioActualTemporal, request.Motivo);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket ya no está disponible para devolver." });
            }

            return Ok(new { mensaje = "Ticket devuelto." });
        }

        /// <summary>Anula un ticket que aún no ha sido Cerrado.</summary>
        /// <param name="id">Id del ticket.</param>
        /// <param name="request">Motivo de la anulación.</param>
        [HttpPost("{id}/anular")]
        public async Task<IActionResult> AnularTicket(int id, [FromBody] AnularTicketRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Motivo))
            {
                return BadRequest(new { mensaje = "Debes indicar un motivo de anulación." });
            }

            var exito = await ticketsService.AnularTicket(id, SesionTemporal.UsuarioActualTemporal, request.Motivo);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket ya no estaba disponible para anular." });
            }

            return Ok(new { mensaje = "Ticket anulado." });
        }

        // ==================== IMPLEMENTACIÓN Y MEJORA ======================
        // Pendiente -> Levantamiento -> Desarrollo -> Pruebas -> Pase a producción -> Cierre / Anulado

        /// <summary>Toma un ticket Pendiente para levantamiento (requiere prioridad ya asignada).</summary>
        [HttpPost("{id}/tomar-levantamiento")]
        public async Task<IActionResult> TomarLevantamiento(int id)
        {
            var exito = await ticketsService.TomarLevantamiento(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para tomar levantamiendo." });
            }

            return Ok(new { mensaje = "Ticket tomado para levantamiento." });
        }

        /// <summary>Pasa el ticket de "Levantamiento" a "Desarrollo".</summary>
        [HttpPost("{id}/iniciar-desarrollo")]
        public async Task<IActionResult> IniciarDesarrollo(int id)
        {
            var exito = await ticketsService.IniciarDesarrollo(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para iniciar desarrollo." });
            }

            return Ok(new { mensaje = "Se inició el desarrollo del ticket." });
        }

        /// <summary>Pasa el ticket de "Desarrollo" a "Pruebas".</summary>
        [HttpPost("{id}/enviar-a-pruebas")]
        public async Task<IActionResult> EnviarAPruebas(int id)
        {
            var exito = await ticketsService.EnviarAPruebas(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para enviar a pruebas." });
            }

            return Ok(new { mensaje = "El ticket pasó a etapa de pruebas." });
        }

        /// <summary>El solicitante confirma que las pruebas salieron bien: "Pruebas" -> "Pase a producción".</summary>
        [HttpPost("{id}/confirmar-pruebas")]
        public async Task<IActionResult> ConfirmarPruebas(int id)
        {
            var exito = await ticketsService.ConfirmarPruebas(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para confirmar las pruebas." });
            }

            return Ok(new { mensaje = "Se dió el visto bueno de las pruebas." });
        }

        /// <summary>Cierra el ticket: "Pase a producción" -> "Cierre".</summary>
        [HttpPost("{id}/cerrar-implementacion")]
        public async Task<IActionResult> CerrarImplementacion(int id)
        {
            var exito = await ticketsService.CerrarImplementacion(id, SesionTemporal.UsuarioActualTemporal);

            if (!exito)
            {
                return BadRequest(new { mensaje = "El ticket no está disponible para cerrar." });
            }

            return Ok(new { mensaje = "El ticket se cerró satisfactoriamente." });
        }
    }
}