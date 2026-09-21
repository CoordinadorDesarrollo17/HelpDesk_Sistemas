using ClosedXML.Excel;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Hosting;
using X.PagedList;

namespace HelpDesk_Sistemas.Services
{
    public class TicketsService : ITicketsService
    {
        private readonly ITicketsRepository ticketsRepository;
        private readonly IWebHostEnvironment webHostEnvironment;
        private readonly IConfiguration configuration;
        private readonly ILogger<TicketsService> logger;

        private const long TamanoMaximoBytes = 10 * 1024 * 1024; // 10 MB por archivo
        private static readonly string[] ExtensionesPermitidas = { ".jpg", ".jpeg", ".png", ".pdf", ".docx", ".xlsx", ".ppt", ".pptx", ".mp4" };

        public TicketsService(ITicketsRepository ticketsRepository, IWebHostEnvironment webHostEnvironment, IConfiguration configuration, ILogger<TicketsService> logger)
        {
            this.ticketsRepository = ticketsRepository;
            this.webHostEnvironment = webHostEnvironment;
            this.configuration = configuration;
            this.logger = logger;
        }

        /// <summary>
        /// Carpeta física donde se guardan los adjuntos, configurable por
        /// appsettings.json (Almacenamiento:CarpetaAdjuntos) — así cada servidor puede
        /// apuntar a su propio disco de datos sin tocar código. Si no está configurada,
        /// usa la ruta del servidor de producción como valor por defecto.
        /// </summary>
        private string ObtenerCarpetaAdjuntos()
        {
            return configuration["Almacenamiento:CarpetaAdjuntos"] ?? @"D:\COBEFARWEBFILES\Helpdesk_Adjuntos";
        }

        // ============================================================
        // LISTADO Y FILTROS
        // ============================================================

        public async Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual, string rolActual)
        {
            return await ticketsRepository.ListadoTickets(model, idUsuarioActual, rolActual);
        }

        public async Task<TicketsResumenModel> ObtenerResumen(int idUsuarioActual)
        {
            return await ticketsRepository.ObtenerResumen(idUsuarioActual);
        }

        public async Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(FiltrosTicketsModel model, int idUsuarioActual, string rolActual)
        {
            var lista = await ticketsRepository.ListadoTicketsExcel(model, idUsuarioActual, rolActual);

            using var workbook = new XLWorkbook();
            var ws = workbook.Worksheets.Add("Tickets");

            ws.Cell(1, 1).Value = "Código Ticket";
            ws.Cell(1, 2).Value = "Sociedad";
            ws.Cell(1, 3).Value = "Tipo Atención";
            ws.Cell(1, 4).Value = "Área";
            ws.Cell(1, 5).Value = "Categoría";
            ws.Cell(1, 6).Value = "Estado";
            ws.Cell(1, 7).Value = "Prioridad";
            ws.Cell(1, 8).Value = "Solicitante";
            ws.Cell(1, 9).Value = "Área Solicitante";
            ws.Cell(1, 10).Value = "Asignado";
            ws.Cell(1, 11).Value = "Fecha Creación";

            ws.Range("A1:J1").Style.Font.Bold = true;

            int row = 2;
            foreach (var ticket in lista)
            {
                ws.Cell(row, 1).Value = ticket.CodigoTicket;
                ws.Cell(row, 2).Value = ticket.Sociedad;
                ws.Cell(row, 3).Value = ticket.TipoRequerimiento;
                ws.Cell(row, 4).Value = ticket.Area;
                ws.Cell(row, 5).Value = ticket.Categoria;
                ws.Cell(row, 6).Value = ticket.Estado;
                ws.Cell(row, 7).Value = ticket.Prioridad;
                ws.Cell(row, 8).Value = ticket.Solicitante;
                ws.Cell(row, 9).Value = ticket.AreaSolicitante;
                ws.Cell(row, 10).Value = ticket.Asignado;
                ws.Cell(row, 11).Value = ticket.FechaCreacion.ToString("dd/MM/yyyy HH:mm:ss");
                row++;
            }

            ws.Columns().AdjustToContents();
            ws.SheetView.FreezeRows(1);
            ws.Cells().Style.Border.OutsideBorder = XLBorderStyleValues.None;
            ws.Cells().Style.Border.InsideBorder = XLBorderStyleValues.None;
            ws.ShowGridLines = false;

            using var stream = new MemoryStream();
            workbook.SaveAs(stream);

            var content = stream.ToArray();
            var fileName = $"Tickets_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";
            var contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            return (content, contentType, fileName);
        }

        public async Task<TicketsModel?> ObtenerTicketPorId(int id)
        {
            return await ticketsRepository.ObtenerTicketPorId(id);
        }

        // ============================================================
        // CATÁLOGOS
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerSociedades()
        {
            return await ticketsRepository.ObtenerSociedades();
        }

        public async Task<List<CatalogoModel>> ObtenerCategorias()
        {
            return await ticketsRepository.ObtenerCategorias();
        }

        public async Task<List<CatalogoModel>> ObtenerEstados()
        {
            return await ticketsRepository.ObtenerEstados();
        }

        public async Task<List<CatalogoModel>> ObtenerAreas()
        {
            return await ticketsRepository.ObtenerAreas();
        }
        public async Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimiento()
        {
            return await ticketsRepository.ObtenerTiposRequerimiento();
        }

        public async Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimientoPorArea(int idArea)
        {
            return await ticketsRepository.ObtenerTiposRequerimientoPorArea(idArea);
        }

        public async Task<List<CatalogoModel>> ObtenerAreasSistemas()
        {
            return await ticketsRepository.ObtenerAreasSistemas();
        }

        public async Task<List<AreaModel>> ObtenerAreasParaCrearTicket()
        {
            return await ticketsRepository.ObtenerAreasParaCrearTicket();
        }

        public async Task<List<CatalogoModel>> ObtenerCategoriasPorTipo(int idTipoReq)
        {
            return await ticketsRepository.ObtenerCategoriasPorTipo(idTipoReq);
        }

        public async Task<List<CatalogoModel>> ObtenerSistemas()
        {
            return await ticketsRepository.ObtenerSistemas();
        }

        public async Task<List<CatalogoModel>> ObtenerPrioridades()
        {
            return await ticketsRepository.ObtenerPrioridades();
        }

        public async Task<bool> TipoRequiereCategoria(int idTipoRequerimiento)
        {
            return await ticketsRepository.TipoRequiereCategoria(idTipoRequerimiento);
        }

        public async Task<TipoRequerimientoModel?> ObtenerTipoRequerimientoPorId(int idTipoRequerimiento)
        {
            return await ticketsRepository.ObtenerTipoRequerimientoPorId(idTipoRequerimiento);
        }

        public async Task<bool> AreaRequiereSistema(int idArea)
        {
            return await ticketsRepository.AreaRequiereSistema(idArea);
        }

        public async Task<List<CatalogoModel>> ObtenerSociedadesPorUsuario(int idUsuario)
        {
            return await ticketsRepository.ObtenerSociedadesPorUsuario(idUsuario);
        }

        public async Task<List<CatalogoModel>> ObtenerImpactos()
        {
            return await ticketsRepository.ObtenerImpactos();
        }

        public async Task<List<CatalogoModel>> ObtenerUrgencias()
        {
            return await ticketsRepository.ObtenerUrgencias();
        }

        public async Task<List<MatrizPrioridadModel>> ObtenerMatrizPrioridad()
        {
            return await ticketsRepository.ObtenerMatrizPrioridad();
        }

        // ============================================================
        // DETALLE
        // ============================================================

        public async Task<TicketDetalleModel?> ObtenerDetalleTicket(int idTicket)
        {
            return await ticketsRepository.ObtenerDetalleTicket(idTicket);
        }

        public async Task<TicketSolucionModel?> ObtenerSolucion(int idTicket)
        {
            return await ticketsRepository.ObtenerSolucion(idTicket);
        }

        // ============================================================
        // CREACIÓN
        // ============================================================

        /// <summary>
        /// Valida tamaño y extensión de cada archivo antes de crear nada (si algo
        /// falla, no se crea el ticket ni se guarda ningún archivo). También comprueba
        /// ANTES de crear el ticket que la carpeta de adjuntos sea escribible: si el
        /// disco/carpeta no está disponible (falta el drive, permisos del pool de
        /// aplicaciones, etc.) el ticket no debe llegar a crearse — de lo contrario el
        /// ticket queda guardado pero la petición termina en una excepción no controlada
        /// (error genérico al usuario) y cada reintento crea un ticket duplicado más,
        /// porque desde el navegador no hay forma de saber que ya se había creado.
        /// Si todo está bien, crea el ticket y luego guarda cada adjunto con un nombre
        /// único para evitar colisiones entre archivos del mismo nombre.
        /// </summary>
        public async Task<(int IdTicket, List<string> Errores)> CrearTicket(CrearTicketModel model, int idUsuarioSolicita)
        {
            var errores = ValidarArchivos(model.Archivos);
            var hayArchivos = model.Archivos != null && model.Archivos.Any(a => a.Length > 0);

            var carpetaUploads = hayArchivos ? PrepararCarpetaAdjuntos(errores) : null;

            if (errores.Count > 0)
            {
                return (0, errores);
            }

            var idTicket = await ticketsRepository.CrearTicket(model, idUsuarioSolicita);

            if (hayArchivos)
            {
                // El ticket ya existe en este punto: si algún archivo no se puede guardar solo
                // se registra en el log (ver GuardarArchivos), no se tira abajo la respuesta.
                await GuardarArchivos(idTicket, model.Archivos!, carpetaUploads!, idUsuarioSolicita, "Solicitud");
            }

            return (idTicket, errores);
        }

        /// <summary>
        /// Valida tamaño y extensión de cada archivo. Devuelve la lista de errores (vacía
        /// si todo está bien). Compartido por la creación del ticket y el registro de la
        /// solución, para que ambos acepten exactamente los mismos archivos.
        /// </summary>
        private static List<string> ValidarArchivos(IEnumerable<IFormFile>? archivos)
        {
            var errores = new List<string>();

            if (archivos == null) return errores;

            foreach (var archivo in archivos)
            {
                if (archivo.Length == 0) continue;

                if (archivo.Length > TamanoMaximoBytes)
                {
                    errores.Add($"El archivo '{archivo.FileName}' supera el tamaño máximo de 10 MB.");
                }

                var extension = Path.GetExtension(archivo.FileName).ToLower();
                if (!ExtensionesPermitidas.Contains(extension))
                {
                    errores.Add($"El archivo '{archivo.FileName}' tiene un formato no permitido.");
                }
            }

            return errores;
        }

        /// <summary>
        /// Asegura que la carpeta de adjuntos exista y sea accesible ANTES de crear o
        /// modificar nada. Si no lo es, agrega el error y devuelve la ruta igual (el
        /// llamador debe revisar errores antes de continuar).
        /// </summary>
        private string PrepararCarpetaAdjuntos(List<string> errores)
        {
            var carpeta = ObtenerCarpetaAdjuntos();

            try
            {
                Directory.CreateDirectory(carpeta); // no hace nada si ya existe
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "No se pudo acceder/crear la carpeta de adjuntos '{Carpeta}'.", carpeta);
                errores.Add("No se pudo acceder a la carpeta de adjuntos del servidor. Avisa a soporte antes de reintentar (revisa la ruta configurada en Almacenamiento:CarpetaAdjuntos y sus permisos).");
            }

            return carpeta;
        }

        /// <summary>
        /// Guarda cada archivo en disco con un nombre único (evita colisiones entre archivos
        /// del mismo nombre) y lo registra en Ticket_Adjuntos con su origen. Si uno falla
        /// se registra en el log y se sigue con el resto — el ticket/solución ya existe y
        /// no se puede deshacer sin dejar SLA/historial a medias. Devuelve los nombres de
        /// los archivos que no se pudieron guardar.
        /// </summary>
        private async Task<List<string>> GuardarArchivos(int idTicket, IEnumerable<IFormFile> archivos, string carpeta, int idUsuario, string origen)
        {
            var fallidos = new List<string>();

            foreach (var archivo in archivos)
            {
                if (archivo.Length == 0) continue;

                var nombreUnico = $"{Guid.NewGuid()}_{archivo.FileName}";
                var rutaFisica = Path.Combine(carpeta, nombreUnico);

                try
                {
                    using (var stream = new FileStream(rutaFisica, FileMode.Create))
                    {
                        await archivo.CopyToAsync(stream);
                    }
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "No se pudo guardar el adjunto '{Archivo}' del ticket {IdTicket}.", archivo.FileName, idTicket);
                    fallidos.Add(archivo.FileName);
                    continue;
                }

                // Se guarda solo el nombre físico (no una URL): el archivo se sirve por
                // TicketsController.DescargarAdjunto, que resuelve la ruta real contra
                // ObtenerCarpetaAdjuntos() — así el valor no queda atado a dónde vive el
                // disco en cada servidor.
                var pesoKB = (int)(archivo.Length / 1024);

                await ticketsRepository.GuardarAdjunto(idTicket, archivo.FileName, nombreUnico, pesoKB, idUsuario, origen);
            }

            return fallidos;
        }

        /// <summary>
        /// Resuelve un adjunto a su archivo físico real, para que el controlador lo sirva.
        /// Usa Path.GetFileName sobre lo guardado en Ruta_Archivo (por si quedó algún
        /// registro viejo con el formato "/uploads/xxx" de antes de tener esta descarga)
        /// para no arrastrar ningún segmento de ruta hacia Path.Combine.
        /// </summary>
        public async Task<(string RutaFisica, string NombreArchivo)?> ObtenerAdjuntoParaDescarga(int idAdjunto)
        {
            var (nombreArchivo, rutaGuardada) = await ticketsRepository.ObtenerAdjuntoPorId(idAdjunto);
            if (nombreArchivo is null || rutaGuardada is null) return null;

            var nombreFisico = Path.GetFileName(rutaGuardada);
            var rutaFisica = Path.Combine(ObtenerCarpetaAdjuntos(), nombreFisico);

            if (!System.IO.File.Exists(rutaFisica)) return null;

            return (rutaFisica, nombreArchivo);
        }

        // ============================================================
        // FLUJO CONSULTA / SOPORTE
        // ============================================================

        public async Task<bool> TomarTicket(int idTicket, int idUsuarioAsignado)
        {
            return await ticketsRepository.TomarTicket(idTicket, idUsuarioAsignado);
        }

        public async Task<bool> AtenderTicket(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.AtenderTicket(idTicket, idUsuarioAccion);
        }

        public async Task<bool> PausarTicket(int idTicket, int idUsuarioAccion, string tipoMotivo, int? idTicketRelacionado)
        {
            return await ticketsRepository.PausarTicket(idTicket, idUsuarioAccion, tipoMotivo, idTicketRelacionado);
        }

        public async Task<bool> ReanudarTicket(int idTicket, int idUsuarioAccion, string comentario = "Ticket reanudado")
        {
            return await ticketsRepository.ReanudarTicket(idTicket, idUsuarioAccion, comentario);
        }

        public async Task<List<PausaVencidaModel>> ObtenerPausasRefrigerioVencidas()
        {
            return await ticketsRepository.ObtenerPausasRefrigerioVencidas();
        }

        /// <summary>
        /// Registra la solución (texto + archivos opcionales) y pasa el ticket a "En
        /// validación". Igual que en la creación, primero se valida todo —archivos y
        /// carpeta de adjuntos— y solo si está bien se cambia el estado: no puede quedar
        /// una solución registrada a medias por un archivo inválido. Devuelve un mensaje
        /// cuando algo falla o, con Exito = true, cuando algún archivo no se pudo guardar.
        /// </summary>
        public async Task<(bool Exito, string? Mensaje)> ValidarTicket(int idTicket, int idUsuarioAccion, string solucion, List<IFormFile>? archivos = null)
        {
            var errores = ValidarArchivos(archivos);
            var hayArchivos = archivos != null && archivos.Any(a => a.Length > 0);

            var carpeta = hayArchivos ? PrepararCarpetaAdjuntos(errores) : null;

            if (errores.Count > 0)
            {
                return (false, string.Join(" ", errores));
            }

            var exito = await ticketsRepository.ValidarTicket(idTicket, idUsuarioAccion, solucion);

            if (!exito)
            {
                return (false, "El ticket ya no está disponible para validar.");
            }

            if (hayArchivos)
            {
                var fallidos = await GuardarArchivos(idTicket, archivos!, carpeta!, idUsuarioAccion, "Solucion");

                if (fallidos.Count > 0)
                {
                    return (true, $"La solución se registró, pero no se pudieron guardar estos archivos: {string.Join(", ", fallidos)}. Avisa al Área de Sistemas.");
                }
            }

            return (true, null);
        }

        public async Task<bool> ConfirmarSolucion(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.ConfirmarSolucion(idTicket, idUsuarioAccion);
        }

        public async Task<bool> DevolverTicket(int idTicket, int idUsuarioAccion, string motivo)
        {
            return await ticketsRepository.DevolverTicket(idTicket, idUsuarioAccion, motivo);
        }

        public async Task<bool> AnularTicket(int idTicket, int idUsuarioAccion, string motivo, int idAreaUsuarioActual)
        {
            return await ticketsRepository.AnularTicket(idTicket, idUsuarioAccion, motivo, idAreaUsuarioActual);
        }

        public async Task<bool> UsuarioPerteneceSociedad(int idUsuario, int idSociedad)
        {
            return await ticketsRepository.UsuarioPerteneceSociedad(idUsuario, idSociedad);
        }

        // ============================================================
        // PRIORIDAD Y ORDEN DE ATENCIÓN (ambos flujos)
        // ============================================================

        public async Task<(bool Exito, string? Mensaje)> AsignarPrioridad(int idTicket, int idPrioridad, int idUsuarioActual, int idAreaUsuarioActual)
        {
            return await ticketsRepository.AsignarPrioridad(idTicket, idPrioridad, idUsuarioActual, idAreaUsuarioActual);
        }

        public async Task<(bool Exito, string? Mensaje)> CorregirImpacto(int idTicket, int idImpacto, int idUsuarioActual, int idAreaUsuarioActual)
        {
            return await ticketsRepository.CorregirImpacto(idTicket, idImpacto, idUsuarioActual, idAreaUsuarioActual);
        }

        public async Task<(bool Exito, string? Mensaje)> AsignarOrdenAtencion(int idTicket, int orden, int idUsuarioActual, int idAreaUsuarioActual)
        {
            return await ticketsRepository.AsignarOrdenAtencion(idTicket, orden, idUsuarioActual, idAreaUsuarioActual);
        }

        public async Task<bool> CorregirAreaSolicitante(int idTicket, int? idAreaSolicitante)
        {
            return await ticketsRepository.CorregirAreaSolicitante(idTicket, idAreaSolicitante);
        }

        public async Task<List<CatalogoModel>> ObtenerMisTicketsPropios(int idUsuario, int idTicketActual)
        {
            return await ticketsRepository.ObtenerMisTicketsPropios(idUsuario, idTicketActual);
        }

        // ============================================================
        // FLUJO IMPLEMENTACIÓN Y MEJORA
        // ============================================================

        public async Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado)
        {
            return await ticketsRepository.TomarLevantamiento(idTicket, idUsuarioAsignado);
        }

        public async Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.IniciarDesarrollo(idTicket, idUsuarioAccion);
        }

        public async Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.EnviarAPruebas(idTicket, idUsuarioAccion);
        }

        public async Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.ConfirmarPruebas(idTicket, idUsuarioAccion);
        }

        public async Task<bool> DevolverPruebas(int idTicket, int idUsuarioAccion, string feedback)
        {
            return await ticketsRepository.DevolverPruebas(idTicket, idUsuarioAccion, feedback);
        }

        public async Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.CerrarImplementacion(idTicket, idUsuarioAccion);
        }

        // ============================================================
        // REASIGNACIÓN (ambos flujos)
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerUsuariosSoportePorArea(int idArea)
        {
            return await ticketsRepository.ObtenerUsuariosSoportePorArea(idArea);
        }

        public async Task<bool> ReasignarTicket(int idTicket, int idNuevoUsuario, int idUsuarioAccion)
        {
            return await ticketsRepository.ReasignarTicket(idTicket, idNuevoUsuario, idUsuarioAccion);
        }
    }
}