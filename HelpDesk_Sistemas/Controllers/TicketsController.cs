using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using System.Linq;

namespace HelpDesk_Sistemas.Controllers
{
    public class TicketsController : Controller
    {
        // Implementación/Mejora quedan reservadas a estos roles; el rol "Usuario"
        // (empleado común) solo puede pedir Soporte.
        private static readonly string[] RolesPermitidosImplementacionMejora = { "Supervisor", "Administrador", "Soporte" };

        private readonly ITicketsService ticketsService;
        private readonly IAnexosService anexosService;
        private readonly ILogger<TicketsController> logger;

        public TicketsController(ITicketsService ticketsService, IAnexosService anexosService, ILogger<TicketsController> logger)
        {
            this.ticketsService = ticketsService;
            this.anexosService = anexosService;
            this.logger = logger;
        }

        // ============================================================
        // LISTADO Y FILTROS
        // ============================================================

        public async Task<IActionResult> ListadoTickets(FiltrosTicketsModel model)
        {
            var listaTickets = await ticketsService.ListadoTickets(model, SesionTemporal.UsuarioActualTemporal, SesionTemporal.RolActual);

            ViewBag.Categorias = await ticketsService.ObtenerCategorias();
            ViewBag.Sociedades = await ticketsService.ObtenerSociedades();
            ViewBag.Prioridades = await ticketsService.ObtenerPrioridades();
            ViewBag.Impactos = await ticketsService.ObtenerImpactos();
            ViewBag.Estados = await ticketsService.ObtenerEstados();
            ViewBag.AreasSolicitantes = await ticketsService.ObtenerAreas();
            ViewBag.Areas = await ticketsService.ObtenerAreasSistemas();
            ViewBag.Tipos = await ticketsService.ObtenerTiposRequerimiento();
            ViewBag.Rol = SesionTemporal.RolActual;
            ViewBag.Usuario = SesionTemporal.NombreCompletoActual;
            ViewBag.IdUsuarioActual = SesionTemporal.UsuarioActualTemporal;
            ViewBag.IdAreaUsuario = SesionTemporal.IdAreaActual;
            ViewBag.EsCoordinador = SesionTemporal.EsCoordinadorActual;

            // Solo la carga inicial (no el refresco AJAX) necesita esto: para que el filtro
            // "compuesto" que trae la URL (desde una tarjeta KPI de Home/Reportes) no se
            // pierda en el primer refresco automático de la tabla (ver cargarTabla en JS).
            ViewBag.CategoriaInicial = model.Categoria;
            ViewBag.FechaInicioInicial = model.FechaInicio?.ToString("yyyy-MM-dd");
            ViewBag.FechaFinInicial = model.FechaFin?.ToString("yyyy-MM-dd");

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return PartialView("_TablaListaTickets", listaTickets);
            }

            return View(listaTickets);
        }

        [HttpGet]
        public async Task<IActionResult> ExportarExcel(FiltrosTicketsModel model)
        {
            var file = await ticketsService.ExportarExcelAsync(model, SesionTemporal.UsuarioActualTemporal, SesionTemporal.RolActual);
            return File(file.Content, file.ContentType, file.FileName);
        }

        // ============================================================
        // DETALLE
        // ============================================================

        [HttpGet]
        public async Task<IActionResult> VerDetalle(int id)
        {
            var detalle = await ticketsService.ObtenerDetalleTicket(id);

            if (detalle is null)
            {
                return NotFound();
            }

            detalle.GuiasVinculadas = await anexosService.ObtenerGuiasVinculadas(id);

            return PartialView("_DetalleTicket", detalle);
        }

        // ============================================================
        // CREACIÓN
        // ============================================================

        [HttpGet]
        public async Task<IActionResult> CrearTicket()
        {
            // Tipos y Categoría dependen del Área, que todavía no está elegida —
            // se cargan vía AJAX (TiposPorArea / CategoriasPorTipo) cuando el usuario
            // elige Área y luego Tipo. Sistema es un catálogo fijo, se carga entero.
            ViewBag.Areas = await ticketsService.ObtenerAreasParaCrearTicket();
            ViewBag.Sistemas = await ticketsService.ObtenerSistemas();
            ViewBag.Sociedades = await ticketsService.ObtenerSociedadesPorUsuario(SesionTemporal.UsuarioActualTemporal);
            ViewBag.Impactos = await ticketsService.ObtenerImpactos();
            ViewBag.Urgencias = await ticketsService.ObtenerUrgencias();
            ViewBag.Matriz = await ticketsService.ObtenerMatrizPrioridad();
            // Temporal, solo para pruebas (ver CrearTicketModel.IdAreaSolicitante).
            ViewBag.AreasSolicitantes = await ticketsService.ObtenerAreas();

            return PartialView("_CrearTicket");
        }

        [HttpGet]
        public async Task<IActionResult> TiposPorArea(int idArea)
        {
            var tipos = await ticketsService.ObtenerTiposRequerimientoPorArea(idArea);
            return Json(tipos);
        }

        [HttpGet]
        public async Task<IActionResult> CategoriasPorTipo(int idTipoReq)
        {
            var categorias = await ticketsService.ObtenerCategoriasPorTipo(idTipoReq);
            return Json(categorias);
        }

        [HttpPost]
        public async Task<IActionResult> CrearTicket(CrearTicketModel model)
        {
            var requiereCategoria = true; // valor por defecto si el tipo no se pudo determinar
            var flujo = "Soporte";

            if (model.IdTipoRequerimiento.GetValueOrDefault() > 0)
            {
                var tipo = await ticketsService.ObtenerTipoRequerimientoPorId(model.IdTipoRequerimiento!.Value);
                requiereCategoria = tipo?.RequiereCategoria ?? true;
                flujo = tipo?.Flujo ?? "Soporte";
                var usaImpactoUrgencia = tipo?.UsaImpactoUrgencia ?? false;

                if (requiereCategoria && model.IdCategoria is null)
                {
                    ModelState.AddModelError(nameof(model.IdCategoria), "Selecciona una categoría para este tipo de atención.");
                }

                if (usaImpactoUrgencia)
                {
                    if (model.IdImpacto is null)
                        ModelState.AddModelError(nameof(model.IdImpacto), "Indica el impacto del inconveniente.");

                    if (model.IdUrgencia is null)
                        ModelState.AddModelError(nameof(model.IdUrgencia), "Indica la urgencia del inconveniente.");
                }
                else
                {
                    model.IdImpacto = null;
                    model.IdUrgencia = null;
                }

                if (flujo == "ImplementacionMejora" && !RolesPermitidosImplementacionMejora.Contains(SesionTemporal.RolActual))
                {
                    ModelState.AddModelError(nameof(model.IdTipoRequerimiento), "Solo Soporte, Supervisor o Administrador pueden crear tickets de este tipo de atención.");
                }
            }

            if (model.IdArea.GetValueOrDefault() > 0)
            {
                var requiereSistema = await ticketsService.AreaRequiereSistema(model.IdArea!.Value);

                if (requiereSistema && model.IdSistema is null)
                {
                    ModelState.AddModelError(nameof(model.IdSistema), "Selecciona en qué sistema es el inconveniente.");
                }
                else if (!requiereSistema)
                {
                    model.IdSistema = null;
                }
            }

            if (model.IdSociedad.HasValue && !await ticketsService.UsuarioPerteneceSociedad(SesionTemporal.UsuarioActualTemporal, model.IdSociedad.Value))
            {
                ModelState.AddModelError(nameof(model.IdSociedad), "La sociedad seleccionada no es válida para tu usuario.");
            }

            if (!ModelState.IsValid)
            {
                ViewBag.Areas = await ticketsService.ObtenerAreasParaCrearTicket();
                ViewBag.Sistemas = await ticketsService.ObtenerSistemas();
                ViewBag.Tipos = model.IdArea.GetValueOrDefault() > 0 ? await ticketsService.ObtenerTiposRequerimientoPorArea(model.IdArea!.Value) : new List<TipoRequerimientoModel>();
                ViewBag.Categorias = model.IdTipoRequerimiento.GetValueOrDefault() > 0 ? await ticketsService.ObtenerCategoriasPorTipo(model.IdTipoRequerimiento!.Value) : new List<CatalogoModel>();
                ViewBag.Sociedades = await ticketsService.ObtenerSociedadesPorUsuario(SesionTemporal.UsuarioActualTemporal);
                ViewBag.Impactos = await ticketsService.ObtenerImpactos();
                ViewBag.Urgencias = await ticketsService.ObtenerUrgencias();
                ViewBag.Matriz = await ticketsService.ObtenerMatrizPrioridad();
                ViewBag.AreasSolicitantes = await ticketsService.ObtenerAreas();

                Response.StatusCode = 400;
                return PartialView("_CrearTicket", model);
            }

            var (idTicket, errores) = await ticketsService.CrearTicket(model, SesionTemporal.UsuarioActualTemporal);

            if (errores.Count > 0)
            {
                foreach (var error in errores)
                {
                    ModelState.AddModelError(nameof(model.Archivos), error);
                }

                ViewBag.Areas = await ticketsService.ObtenerAreasParaCrearTicket();
                ViewBag.Sistemas = await ticketsService.ObtenerSistemas();
                ViewBag.Tipos = model.IdArea.GetValueOrDefault() > 0 ? await ticketsService.ObtenerTiposRequerimientoPorArea(model.IdArea!.Value) : new List<TipoRequerimientoModel>();
                ViewBag.Categorias = model.IdTipoRequerimiento.GetValueOrDefault() > 0 ? await ticketsService.ObtenerCategoriasPorTipo(model.IdTipoRequerimiento!.Value) : new List<CatalogoModel>();
                ViewBag.Sociedades = await ticketsService.ObtenerSociedadesPorUsuario(SesionTemporal.UsuarioActualTemporal);
                ViewBag.Impactos = await ticketsService.ObtenerImpactos();
                ViewBag.Urgencias = await ticketsService.ObtenerUrgencias();
                ViewBag.Matriz = await ticketsService.ObtenerMatrizPrioridad();
                ViewBag.AreasSolicitantes = await ticketsService.ObtenerAreas();

                Response.StatusCode = 400;
                return PartialView("_CrearTicket", model);
            }

            return Content("OK");
        }

        /// <summary>
        /// Sirve el archivo físico de un adjunto (ver TicketsService.ObtenerAdjuntoParaDescarga).
        /// No hay más regla de acceso que estar logueado (igual que ver el detalle del
        /// ticket): cualquier usuario autenticado con el Id del adjunto puede descargarlo.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> DescargarAdjunto(int id)
        {
            var adjunto = await ticketsService.ObtenerAdjuntoParaDescarga(id);

            if (adjunto is null)
            {
                return NotFound();
            }

            var proveedorTipoContenido = new FileExtensionContentTypeProvider();
            if (!proveedorTipoContenido.TryGetContentType(adjunto.Value.NombreArchivo, out var tipoContenido))
            {
                tipoContenido = "application/octet-stream";
            }

            // enableRangeProcessing: sin esto un video adjunto (visto en el propio detalle o
            // en el modal de la solución) se reproduce pero no deja adelantar/retroceder.
            return PhysicalFile(adjunto.Value.RutaFisica, tipoContenido, adjunto.Value.NombreArchivo, enableRangeProcessing: true);
        }

        // ============================================================
        // FLUJO CONSULTA / SOPORTE
        // ============================================================

        [HttpPost]
        public async Task<IActionResult> TomarTicket(int id)
        {
            var exito = await ticketsService.TomarTicket(id, SesionTemporal.UsuarioActualTemporal);
            var mensaje = exito ? null : "Este ticket necesita una prioridad asignada antes de poder tomarlo, o ya fue tomado por otro usuario.";

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> AtenderTicket(int id)
        {
            var exito = await ticketsService.AtenderTicket(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpGet]
        public async Task<IActionResult> MisTicketsPropios(int idTicketActual)
        {
            var tickets = await ticketsService.ObtenerMisTicketsPropios(SesionTemporal.UsuarioActualTemporal, idTicketActual);
            return Json(tickets);
        }

        [HttpPost]
        public async Task<IActionResult> PausarTicket(int id, string tipoMotivo, int? idTicketRelacionado)
        {
            if (tipoMotivo != "Reunion" && tipoMotivo != "AtencionOtroTicket" && tipoMotivo != "Refrigerio")
            {
                return Json(new { exito = false, mensaje = "Motivo inválido." });
            }

            if (tipoMotivo == "AtencionOtroTicket" && idTicketRelacionado is null)
            {
                return Json(new { exito = false, mensaje = "Selecciona el ticket que vas a atender." });
            }

            var exito = await ticketsService.PausarTicket(id, SesionTemporal.UsuarioActualTemporal, tipoMotivo, idTicketRelacionado);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ReanudarTicket(int id)
        {
            var exito = await ticketsService.ReanudarTicket(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ValidarTicket(int id, string solucion, List<IFormFile>? archivos)
        {
            if (string.IsNullOrWhiteSpace(solucion))
            {
                return Json(new { exito = false, mensaje = "Debes registrar la solución del ticket." });
            }

            var (exito, mensaje) = await ticketsService.ValidarTicket(id, SesionTemporal.UsuarioActualTemporal, solucion, archivos);

            return Json(new { exito, mensaje });
        }

        /// <summary>Solución registrada por Soporte, para mostrarla antes de confirmar o devolver.</summary>
        [HttpGet]
        public async Task<IActionResult> ObtenerSolucion(int id)
        {
            var solucion = await ticketsService.ObtenerSolucion(id);

            if (solucion is null)
            {
                return NotFound();
            }

            var guias = await anexosService.ObtenerGuiasVinculadas(id);

            return Json(new
            {
                codigoTicket = solucion.CodigoTicket,
                solucion = solucion.Solucion,
                resueltoPor = solucion.ResueltoPor,
                fechaSolucion = solucion.FechaSolucion?.ToString("dd/MM/yyyy HH:mm"),
                adjuntos = solucion.Adjuntos.Select(a => new
                {
                    id = a.Id,
                    nombre = a.NombreArchivo,
                    pesoKB = a.PesoKB,
                    url = Url.Action("DescargarAdjunto", "Tickets", new { id = a.Id })
                }),
                // Guía de apoyo que Soporte vinculó al registrar la solución (puede no haber ninguna).
                guias = guias.Select(g => new { id = g.Id, titulo = g.Titulo, nombre = g.NombreArchivo })
            });
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarSolucion(int id)
        {
            var exito = await ticketsService.ConfirmarSolucion(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> DevolverTicket(int id, string motivo)
        {
            if (string.IsNullOrWhiteSpace(motivo))
            {
                return Json(new { exito = false, mensaje = "Debes indicar el motivo por el cual devuelves el ticket." });
            }

            var exito = await ticketsService.DevolverTicket(id, SesionTemporal.UsuarioActualTemporal, motivo);
            var mensaje = exito ? null : "El ticket ya no está disponible para devolver.";

            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> AnularTicket(int id, string motivo)
        {
            if (string.IsNullOrWhiteSpace(motivo))
            {
                return Json(new { exito = false, mensaje = "Debes indicar un motivo de anulación." });
            }

            var exito = await ticketsService.AnularTicket(id, SesionTemporal.UsuarioActualTemporal, motivo, SesionTemporal.IdAreaActual);
            var mensaje = exito ? null : "El ticket ya no estaba disponible para anular.";

            return Json(new { exito, mensaje });
        }

        // ============================================================
        // PRIORIDAD Y ORDEN DE ATENCIÓN (ambos flujos)
        // ============================================================

        [HttpPost]
        public async Task<IActionResult> AsignarPrioridad(int id, int idPrioridad)
        {
            // La prioridad la define quien trabaja la cola (Soporte/Administrador), nunca
            // quien solicitó el ticket — misma regla que AsignarOrdenAtencion.
            var puedeAsignarPrioridad = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";

            if (!puedeAsignarPrioridad)
            {
                return Json(new { exito = false, mensaje = "Solo Soporte o un administrador puede definir la prioridad." });
            }

            var (exito, mensaje) = await ticketsService.AsignarPrioridad(id, idPrioridad, SesionTemporal.UsuarioActualTemporal, SesionTemporal.IdAreaActual);
            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> CorregirImpacto(int id, int idImpacto)
        {
            // Mismo criterio que AsignarPrioridad: lo corrige quien trabaja la cola
            // (Soporte/Administrador), nunca quien solicitó el ticket.
            var puedeCorregirImpacto = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";

            if (!puedeCorregirImpacto)
            {
                return Json(new { exito = false, mensaje = "Solo Soporte o un administrador puede corregir el impacto." });
            }

            var (exito, mensaje) = await ticketsService.CorregirImpacto(id, idImpacto, SesionTemporal.UsuarioActualTemporal, SesionTemporal.IdAreaActual);
            return Json(new { exito, mensaje });
        }

        [HttpPost]
        public async Task<IActionResult> AsignarOrdenAtencion(int id, int orden)
        {
            // El orden de atención lo define quien trabaja la cola (Soporte/Administrador),
            // nunca quien solicitó el ticket (ver también la validación de "solicitante propio"
            // dentro del servicio, misma regla que el resto de acciones sobre tickets).
            var puedeAsignarOrden = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";

            if (!puedeAsignarOrden)
            {
                return Json(new { exito = false, mensaje = "Solo Soporte o un administrador puede definir el orden de atención." });
            }

            var (exito, mensaje) = await ticketsService.AsignarOrdenAtencion(id, orden, SesionTemporal.UsuarioActualTemporal, SesionTemporal.IdAreaActual);
            return Json(new { exito, mensaje });
        }

        /// <summary>
        /// Corrige el área solicitante de un ticket ya creado. Temporal mientras el sistema
        /// está en pruebas: todos los tickets los crean las mismas cuentas de prueba, así
        /// que se necesita poder ajustar a mano de qué área es cada reporte para tener
        /// trazabilidad. idAreaSolicitante en 0 o vacío limpia la corrección manual (vuelve
        /// a usar el área propia de quien solicitó el ticket).
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CorregirAreaSolicitante(int id, int? idAreaSolicitante)
        {
            var puedeCorregir = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";

            if (!puedeCorregir)
            {
                return Json(new { exito = false, mensaje = "Solo Soporte o un administrador puede corregir el área solicitante." });
            }

            if (idAreaSolicitante <= 0)
            {
                idAreaSolicitante = null;
            }

            var exito = await ticketsService.CorregirAreaSolicitante(id, idAreaSolicitante);
            return Json(new { exito });
        }

        // ============================================================
        // MÓDULO DE ANEXOS — vincular una guía a la solución de un ticket
        // ============================================================

        /// <summary>Vincula una guía del módulo de Anexos a la solución del ticket. Misma
        /// regla que el resto de acciones "de cola": solo Soporte/Administrador.</summary>
        [HttpPost]
        public async Task<IActionResult> VincularGuia(int id, int idGuia)
        {
            var puedeVincular = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";

            if (!puedeVincular)
            {
                return Json(new { exito = false, mensaje = "Solo Soporte o un administrador puede vincular una guía." });
            }

            await anexosService.VincularGuiaATicket(id, idGuia, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito = true });
        }

        /// <summary>
        /// Recategoriza el ticket según la categoría de la guía usada para resolverlo,
        /// para que las estadísticas reflejen el problema real (ver Fase 9 del módulo de
        /// Anexos: recategorización obligatoria antes de vincular).
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CorregirCategoriaGuia(int id, int idGuiaCategoria)
        {
            var puedeCorregir = SesionTemporal.RolActual == "Administrador" || SesionTemporal.RolActual == "Soporte";

            if (!puedeCorregir)
            {
                return Json(new { exito = false, mensaje = "Solo Soporte o un administrador puede recategorizar el ticket." });
            }

            var exito = await ticketsService.CorregirCategoriaGuia(id, idGuiaCategoria);
            return Json(new { exito });
        }

        // ============================================================
        // FLUJO IMPLEMENTACIÓN Y MEJORA
        // ============================================================

        [HttpPost]
        public async Task<IActionResult> TomarLevantamiento(int id)
        {
            var exito = await ticketsService.TomarLevantamiento(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> IniciarDesarrollo(int id)
        {
            var exito = await ticketsService.IniciarDesarrollo(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> EnviarAPruebas(int id)
        {
            var exito = await ticketsService.EnviarAPruebas(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarPruebas(int id)
        {
            var exito = await ticketsService.ConfirmarPruebas(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> DevolverPruebas(int id, string feedback)
        {
            if (string.IsNullOrWhiteSpace(feedback))
            {
                return Json(new { exito = false, mensaje = "Debes indicar qué encontraste en las pruebas." });
            }

            var exito = await ticketsService.DevolverPruebas(id, SesionTemporal.UsuarioActualTemporal, feedback);
            return Json(new { exito });
        }

        [HttpPost]
        public async Task<IActionResult> CerrarImplementacion(int id)
        {
            var exito = await ticketsService.CerrarImplementacion(id, SesionTemporal.UsuarioActualTemporal);
            return Json(new { exito });
        }

        // ============================================================
        // REASIGNACIÓN (ambos flujos)
        // ============================================================

        [HttpGet]
        public async Task<IActionResult> UsuariosSoportePorArea(int idArea)
        {
            var usuarios = await ticketsService.ObtenerUsuariosSoportePorArea(idArea);
            return Json(usuarios);
        }

        [HttpPost]
        public async Task<IActionResult> ReasignarTicket(int id, int idNuevoUsuario)
        {
            if (idNuevoUsuario <= 0)
            {
                return Json(new { exito = false, mensaje = "Selecciona a quién reasignar el ticket." });
            }

            // Reasignar es una acción de coordinación: solo Administrador o un Soporte
            // marcado como coordinador de su área pueden mover un ticket a otro agente.
            var puedeReasignar = SesionTemporal.RolActual == "Administrador"
                || (SesionTemporal.RolActual == "Soporte" && SesionTemporal.EsCoordinadorActual);

            if (!puedeReasignar)
            {
                return Json(new { exito = false, mensaje = "Solo un coordinador de área o un administrador puede reasignar tickets." });
            }

            var exito = await ticketsService.ReasignarTicket(id, idNuevoUsuario, SesionTemporal.UsuarioActualTemporal);
            var mensaje = exito ? null : "El ticket no está disponible para reasignar.";

            return Json(new { exito, mensaje });
        }
    }
}