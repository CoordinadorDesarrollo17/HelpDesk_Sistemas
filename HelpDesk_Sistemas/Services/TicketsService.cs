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

        private const long TamanoMaximoBytes = 10 * 1024 * 1024; // 10 MB por archivo
        private static readonly string[] ExtensionesPermitidas = { ".jpg", ".jpeg", ".png", ".pdf", ".docx", ".xlsx", ".ppt", ".pptx", ".mp4" };

        public TicketsService(ITicketsRepository ticketsRepository, IWebHostEnvironment webHostEnvironment)
        {
            this.ticketsRepository = ticketsRepository;
            this.webHostEnvironment = webHostEnvironment;
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
            ws.Cell(1, 2).Value = "Tipo Requerimiento";
            ws.Cell(1, 3).Value = "Área";
            ws.Cell(1, 4).Value = "Categoría";
            ws.Cell(1, 5).Value = "Estado";
            ws.Cell(1, 6).Value = "Prioridad";
            ws.Cell(1, 7).Value = "Solicitante";
            ws.Cell(1, 8).Value = "Área Solicitante";
            ws.Cell(1, 9).Value = "Asignado";
            ws.Cell(1, 10).Value = "Fecha Creación";

            ws.Range("A1:J1").Style.Font.Bold = true;

            int row = 2;
            foreach (var ticket in lista)
            {
                ws.Cell(row, 1).Value = ticket.CodigoTicket;
                ws.Cell(row, 2).Value = ticket.TipoRequerimiento;
                ws.Cell(row, 3).Value = ticket.Area;
                ws.Cell(row, 4).Value = ticket.Categoria;
                ws.Cell(row, 5).Value = ticket.Estado;
                ws.Cell(row, 6).Value = ticket.Prioridad;
                ws.Cell(row, 7).Value = ticket.Solicitante;
                ws.Cell(row, 8).Value = ticket.AreaSolicitante;
                ws.Cell(row, 9).Value = ticket.Asignado;
                ws.Cell(row, 10).Value = ticket.FechaCreacion.ToString("dd/MM/yyyy HH:mm:ss");
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

        public async Task<List<CatalogoModel>> ObtenerEstados()
        {
            return await ticketsRepository.ObtenerEstados();
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
        /// falla, no se crea el ticket ni se guarda ningún archivo). Si todo está
        /// bien, crea el ticket y luego guarda cada adjunto en wwwroot/uploads con
        /// un nombre único para evitar colisiones entre archivos del mismo nombre.
        /// </summary>
        public async Task<(int IdTicket, List<string> Errores)> CrearTicket(CrearTicketModel model, int idUsuarioSolicita)
        {
            var errores = new List<string>();

            if (model.Archivos != null)
            {
                foreach (var archivo in model.Archivos)
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
            }

            if (errores.Count > 0)
            {
                return (0, errores);
            }

            var idTicket = await ticketsRepository.CrearTicket(model, idUsuarioSolicita);

            if (model.Archivos != null && model.Archivos.Count > 0)
            {
                var carpetaUploads = Path.Combine(webHostEnvironment.WebRootPath, "uploads");

                if (!Directory.Exists(carpetaUploads))
                {
                    Directory.CreateDirectory(carpetaUploads);
                }

                foreach (var archivo in model.Archivos)
                {
                    if (archivo.Length == 0) continue;

                    var nombreUnico = $"{Guid.NewGuid()}_{archivo.FileName}";
                    var rutaFisica = Path.Combine(carpetaUploads, nombreUnico);

                    using (var stream = new FileStream(rutaFisica, FileMode.Create))
                    {
                        await archivo.CopyToAsync(stream);
                    }

                    var rutaRelativa = $"/uploads/{nombreUnico}";
                    var pesoKB = (int)(archivo.Length / 1024);

                    await ticketsRepository.GuardarAdjunto(idTicket, archivo.FileName, rutaRelativa, pesoKB, idUsuarioSolicita);
                }
            }

            return (idTicket, errores);
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

        public async Task<bool> ValidarTicket(int idTicket, int idUsuarioAccion, string solucion)
        {
            return await ticketsRepository.ValidarTicket(idTicket, idUsuarioAccion, solucion);
        }

        public async Task<bool> ConfirmarSolucion(int idTicket, int idUsuarioAccion)
        {
            return await ticketsRepository.ConfirmarSolucion(idTicket, idUsuarioAccion);
        }

        public async Task<bool> DevolverTicket(int idTicket, int idUsuarioAccion, string motivo)
        {
            return await ticketsRepository.DevolverTicket(idTicket, idUsuarioAccion, motivo);
        }

        public async Task<bool> AnularTicket(int idTicket, int idUsuarioAccion, string motivo)
        {
            return await ticketsRepository.AnularTicket(idTicket, idUsuarioAccion, motivo);
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

        public async Task<(bool Exito, string? Mensaje)> AsignarOrdenAtencion(int idTicket, int orden, int idUsuarioActual, int idAreaUsuarioActual)
        {
            return await ticketsRepository.AsignarOrdenAtencion(idTicket, orden, idUsuarioActual, idAreaUsuarioActual);
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