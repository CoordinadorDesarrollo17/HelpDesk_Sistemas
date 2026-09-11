using ClosedXML.Excel;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Services
{
    public class ReportesService : IReportesService
    {
        private readonly IReportesRepository reportesRepository;

        public ReportesService(IReportesRepository reportesRepository)
        {
            this.reportesRepository = reportesRepository;
        }

        public async Task<ReporteGeneralModel> ObtenerReporteGeneral(ReporteFiltroModel filtro)
        {
            return await reportesRepository.ObtenerReporteGeneral(filtro);
        }

        public async Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(ReporteFiltroModel filtro)
        {
            var reporte = await reportesRepository.ObtenerReporteGeneral(filtro);

            using var workbook = new XLWorkbook();

            string Horas(decimal? h) => h.HasValue ? Math.Round(h.Value, 1).ToString() : "-";

            var wsResumen = workbook.Worksheets.Add("Resumen");
            wsResumen.Cell(1, 1).Value = "Período";
            wsResumen.Cell(1, 2).Value = $"{filtro.FechaInicio:dd/MM/yyyy} - {filtro.FechaFin:dd/MM/yyyy}";
            wsResumen.Cell(2, 1).Value = "Tickets creados";
            wsResumen.Cell(2, 2).Value = reporte.Resumen.TotalCreados;
            wsResumen.Cell(3, 1).Value = "Tickets cerrados";
            wsResumen.Cell(3, 2).Value = reporte.Resumen.TotalCerrados;
            wsResumen.Cell(4, 1).Value = "Tickets activos";
            wsResumen.Cell(4, 2).Value = reporte.Resumen.TicketsActivos;
            wsResumen.Cell(6, 1).Value = "Tiempos promedio (horas corridas)";
            wsResumen.Cell(6, 1).Style.Font.Italic = true;
            wsResumen.Cell(7, 1).Value = "  En cola  (creación → asignación)";
            wsResumen.Cell(7, 2).Value = Horas(reporte.Resumen.TiempoPromedioColaHoras);
            wsResumen.Cell(8, 1).Value = "  Trabajo del asesor  (asignación → cierre)";
            wsResumen.Cell(8, 2).Value = Horas(reporte.Resumen.TiempoPromedioTrabajoAgenteHoras);
            wsResumen.Cell(9, 1).Value = "  Resolución total  (creación → cierre)";
            wsResumen.Cell(9, 2).Value = Horas(reporte.Resumen.TiempoPromedioResolucionHoras);
            wsResumen.Column(1).Style.Font.Bold = true;
            wsResumen.Columns().AdjustToContents();

            AgregarHojaDistribucion(workbook, "Tendencia diaria", reporte.Tendencia);
            AgregarHojaDistribucionGenerica(workbook, "Por tipo", reporte.PorTipo);
            AgregarHojaDistribucionGenerica(workbook, "Por área", reporte.PorArea);
            AgregarHojaDistribucionGenerica(workbook, "Por prioridad", reporte.PorPrioridad);

            var wsAgentes = workbook.Worksheets.Add("Por agente");
            wsAgentes.Cell(1, 1).Value = "Agente";
            wsAgentes.Cell(1, 2).Value = "Asignados";
            wsAgentes.Cell(1, 3).Value = "Cerrados";
            wsAgentes.Cell(1, 4).Value = "Activos";
            wsAgentes.Cell(1, 5).Value = "Prom. en cola (h)";
            wsAgentes.Cell(1, 6).Value = "Prom. trabajo del asesor (h)";
            wsAgentes.Cell(1, 7).Value = "Devoluciones";
            wsAgentes.Range("A1:G1").Style.Font.Bold = true;

            var filaAgente = 2;
            foreach (var a in reporte.PorAgente)
            {
                wsAgentes.Cell(filaAgente, 1).Value = a.Agente;
                wsAgentes.Cell(filaAgente, 2).Value = a.Asignados;
                wsAgentes.Cell(filaAgente, 3).Value = a.Cerrados;
                wsAgentes.Cell(filaAgente, 4).Value = a.Activos;
                wsAgentes.Cell(filaAgente, 5).Value = Horas(a.TiempoPromedioColaHoras);
                wsAgentes.Cell(filaAgente, 6).Value = Horas(a.TiempoPromedioResolucionHoras);
                wsAgentes.Cell(filaAgente, 7).Value = a.Devoluciones;
                filaAgente++;
            }
            wsAgentes.Columns().AdjustToContents();
            wsAgentes.SheetView.FreezeRows(1);

            AgregarHojaDetalleTiempos(workbook, reporte.DetalleTiempos);

            foreach (var ws in workbook.Worksheets)
            {
                ws.Cells().Style.Border.OutsideBorder = XLBorderStyleValues.None;
                ws.Cells().Style.Border.InsideBorder = XLBorderStyleValues.None;
                ws.ShowGridLines = false;
            }

            using var stream = new MemoryStream();
            workbook.SaveAs(stream);

            var content = stream.ToArray();
            var fileName = $"Reporte_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";
            var contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            return (content, contentType, fileName);
        }

        private static void AgregarHojaDistribucion(XLWorkbook workbook, string nombreHoja, List<ReporteTendenciaPuntoModel> puntos)
        {
            var ws = workbook.Worksheets.Add(nombreHoja);
            ws.Cell(1, 1).Value = "Fecha";
            ws.Cell(1, 2).Value = "Creados";
            ws.Cell(1, 3).Value = "Cerrados";
            ws.Range("A1:C1").Style.Font.Bold = true;

            var fila = 2;
            foreach (var p in puntos)
            {
                ws.Cell(fila, 1).Value = p.Fecha;
                ws.Cell(fila, 1).Style.DateFormat.Format = "dd/MM/yyyy";
                ws.Cell(fila, 2).Value = p.Creados;
                ws.Cell(fila, 3).Value = p.Cerrados;
                fila++;
            }
            ws.Columns().AdjustToContents();
            ws.SheetView.FreezeRows(1);
        }

        private static void AgregarHojaDistribucionGenerica(XLWorkbook workbook, string nombreHoja, List<ReporteDistribucionModel> filas)
        {
            var ws = workbook.Worksheets.Add(nombreHoja);
            ws.Cell(1, 1).Value = "Etiqueta";
            ws.Cell(1, 2).Value = "Cantidad";
            ws.Range("A1:B1").Style.Font.Bold = true;

            var fila = 2;
            foreach (var f in filas)
            {
                ws.Cell(fila, 1).Value = f.Etiqueta;
                ws.Cell(fila, 2).Value = f.Cantidad;
                fila++;
            }
            ws.Columns().AdjustToContents();
            ws.SheetView.FreezeRows(1);
        }

        // Una fila por ticket con sus 3 tramos (cola / trabajo del asesor / total), en horas
        // hábiles (como el SLA) y en horas corridas. Vacío -> el tramo aún no ocurrió.
        private static void AgregarHojaDetalleTiempos(XLWorkbook workbook, List<ReporteTiempoTicketModel> tickets)
        {
            var ws = workbook.Worksheets.Add("Detalle por ticket");
            string[] encabezados =
            {
                "Ticket", "Estado", "Área", "Prioridad", "Asesor asignado",
                "Creación", "Toma", "Resolución",
                "Cola háb. (h)", "Trabajo asesor háb. (h)", "Total háb. (h)",
                "Cola corr. (h)", "Trabajo asesor corr. (h)", "Total corr. (h)"
            };
            for (var i = 0; i < encabezados.Length; i++)
            {
                ws.Cell(1, i + 1).Value = encabezados[i];
            }
            ws.Range(1, 1, 1, encabezados.Length).Style.Font.Bold = true;

            static string Horas(int? minutos) => minutos.HasValue ? Math.Round(minutos.Value / 60.0, 1).ToString() : "-";

            var fila = 2;
            foreach (var t in tickets)
            {
                ws.Cell(fila, 1).Value = t.CodigoTicket;
                ws.Cell(fila, 2).Value = t.EstadoActual ?? "-";
                ws.Cell(fila, 3).Value = t.Area ?? "-";
                ws.Cell(fila, 4).Value = t.Prioridad ?? "-";
                ws.Cell(fila, 5).Value = string.IsNullOrWhiteSpace(t.AsesorAsignado) ? "-" : t.AsesorAsignado;
                ws.Cell(fila, 6).Value = t.FechaCreacion;
                ws.Cell(fila, 6).Style.DateFormat.Format = "dd/MM/yyyy HH:mm";
                if (t.FechaToma.HasValue) { ws.Cell(fila, 7).Value = t.FechaToma.Value; ws.Cell(fila, 7).Style.DateFormat.Format = "dd/MM/yyyy HH:mm"; }
                else { ws.Cell(fila, 7).Value = "-"; }
                if (t.FechaResolucion.HasValue) { ws.Cell(fila, 8).Value = t.FechaResolucion.Value; ws.Cell(fila, 8).Style.DateFormat.Format = "dd/MM/yyyy HH:mm"; }
                else { ws.Cell(fila, 8).Value = "-"; }
                ws.Cell(fila, 9).Value = Horas(t.MinColaHabil);
                ws.Cell(fila, 10).Value = Horas(t.MinTrabajoAsesorHabil);
                ws.Cell(fila, 11).Value = Horas(t.MinResolucionTotalHabil);
                ws.Cell(fila, 12).Value = Horas(t.MinColaReloj);
                ws.Cell(fila, 13).Value = Horas(t.MinTrabajoAsesorReloj);
                ws.Cell(fila, 14).Value = Horas(t.MinResolucionTotalReloj);
                fila++;
            }
            ws.Columns().AdjustToContents();
            ws.SheetView.FreezeRows(1);
        }
    }
}
