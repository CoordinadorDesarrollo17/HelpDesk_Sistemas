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

            var wsResumen = workbook.Worksheets.Add("Resumen");
            wsResumen.Cell(1, 1).Value = "Período";
            wsResumen.Cell(1, 2).Value = $"{filtro.FechaInicio:dd/MM/yyyy} - {filtro.FechaFin:dd/MM/yyyy}";
            wsResumen.Cell(2, 1).Value = "Tickets creados";
            wsResumen.Cell(2, 2).Value = reporte.Resumen.TotalCreados;
            wsResumen.Cell(3, 1).Value = "Tickets cerrados";
            wsResumen.Cell(3, 2).Value = reporte.Resumen.TotalCerrados;
            wsResumen.Cell(4, 1).Value = "Tickets activos";
            wsResumen.Cell(4, 2).Value = reporte.Resumen.TicketsActivos;
            wsResumen.Cell(5, 1).Value = "Tiempo promedio de resolución (horas)";
            wsResumen.Cell(5, 2).Value = reporte.Resumen.TiempoPromedioResolucionHoras.HasValue ? Math.Round(reporte.Resumen.TiempoPromedioResolucionHoras.Value, 1).ToString() : "-";
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
            wsAgentes.Cell(1, 5).Value = "Tiempo promedio resolución (h)";
            wsAgentes.Cell(1, 6).Value = "Devoluciones";
            wsAgentes.Range("A1:F1").Style.Font.Bold = true;

            var filaAgente = 2;
            foreach (var a in reporte.PorAgente)
            {
                wsAgentes.Cell(filaAgente, 1).Value = a.Agente;
                wsAgentes.Cell(filaAgente, 2).Value = a.Asignados;
                wsAgentes.Cell(filaAgente, 3).Value = a.Cerrados;
                wsAgentes.Cell(filaAgente, 4).Value = a.Activos;
                wsAgentes.Cell(filaAgente, 5).Value = a.TiempoPromedioResolucionHoras.HasValue ? Math.Round(a.TiempoPromedioResolucionHoras.Value, 1).ToString() : "-";
                wsAgentes.Cell(filaAgente, 6).Value = a.Devoluciones;
                filaAgente++;
            }
            wsAgentes.Columns().AdjustToContents();
            wsAgentes.SheetView.FreezeRows(1);

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
    }
}
