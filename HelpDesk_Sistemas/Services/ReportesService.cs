using ClosedXML.Excel;
using HelpDesk_Sistemas.Common;
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
            wsResumen.Cell(6, 1).Value = "Tiempos promedio (tiempo real: cuenta noches, fines de semana y feriados)";
            wsResumen.Cell(6, 1).Style.Font.Italic = true;
            wsResumen.Cell(7, 1).Value = "  En cola  (creación → asignación)";
            wsResumen.Cell(7, 2).Value = FormatoDuracion.DesdeHoras(reporte.Resumen.TiempoPromedioColaHoras);
            wsResumen.Cell(8, 1).Value = "  Trabajo del asesor  (asignación → cierre)";
            wsResumen.Cell(8, 2).Value = FormatoDuracion.DesdeHoras(reporte.Resumen.TiempoPromedioTrabajoAgenteHoras);
            wsResumen.Cell(9, 1).Value = "  Resolución total  (creación → cierre)";
            wsResumen.Cell(9, 2).Value = FormatoDuracion.DesdeHoras(reporte.Resumen.TiempoPromedioResolucionHoras);
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
            wsAgentes.Cell(1, 5).Value = "Prom. en cola";
            wsAgentes.Cell(1, 6).Value = "Prom. trabajo del asesor";
            wsAgentes.Cell(1, 7).Value = "Devoluciones";
            wsAgentes.Range("A1:G1").Style.Font.Bold = true;

            var filaAgente = 2;
            foreach (var a in reporte.PorAgente)
            {
                wsAgentes.Cell(filaAgente, 1).Value = a.Agente;
                wsAgentes.Cell(filaAgente, 2).Value = a.Asignados;
                wsAgentes.Cell(filaAgente, 3).Value = a.Cerrados;
                wsAgentes.Cell(filaAgente, 4).Value = a.Activos;
                wsAgentes.Cell(filaAgente, 5).Value = FormatoDuracion.DesdeHoras(a.TiempoPromedioColaHoras);
                wsAgentes.Cell(filaAgente, 6).Value = FormatoDuracion.DesdeHoras(a.TiempoPromedioResolucionHoras);
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

        // Una fila por ticket: fechas y horas por separado (creación / toma / resolución)
        // y sus 3 tramos, en tiempo real (fórmulas de Excel que restan las fechas, así se
        // pueden sumar/promediar) y en horario laboral (como el SLA). "-" -> aún no ocurrió.
        private static void AgregarHojaDetalleTiempos(XLWorkbook workbook, List<ReporteTiempoTicketModel> tickets)
        {
            var ws = workbook.Worksheets.Add("Detalle por ticket");
            string[] encabezados =
            {
                "Ticket", "Estado", "Área", "Prioridad", "Asesor asignado",
                "Fecha creación", "Hora creación", "Fecha toma", "Hora toma", "Fecha resolución", "Hora resolución",
                "Tiempo en tomar el ticket", "Tiempo total del ticket", "Tiempo del asesor en resolver",
                "Tiempo en tomar (horario laboral)", "Tiempo total (horario laboral)", "Tiempo del asesor (horario laboral)"
            };
            for (var i = 0; i < encabezados.Length; i++)
            {
                ws.Cell(1, i + 1).Value = encabezados[i];
            }

            // Nota en cada encabezado de tiempo, visible al pasar el mouse en Excel.
            string[] notas =
            {
                "Toma − Creación: desde que se crea el ticket hasta que un asesor lo toma.",
                "Resolución − Creación: desde que se crea el ticket hasta que se resuelve.",
                "Resolución − Toma: desde que el asesor lo toma hasta que lo resuelve.",
            };
            const string notaReal = " Tiempo real: cuenta todo lo transcurrido en el reloj, incluidas noches, fines de semana y feriados.";
            const string notaLaboral = " Solo cuenta el horario de atención (sin noches, fines de semana ni feriados). Es el mismo cálculo que usa el SLA.";
            for (var i = 0; i < notas.Length; i++)
            {
                ws.Cell(1, 12 + i).CreateComment().AddText(notas[i] + notaReal);
                ws.Cell(1, 15 + i).CreateComment().AddText(notas[i] + notaLaboral);
            }
            ws.Range(1, 1, 1, encabezados.Length).Style.Font.Bold = true;

            // Duración que puede pasar de 24h, mostrada como "26h 05m".
            const string formatoDuracion = "[h]\"h \"mm\"m\"";

            // Fecha y hora en columnas separadas; sin segundos, para que la resta
            // coincida con el conteo por minutos del SLA. Las fórmulas redondean al
            // minuto porque la resta de fechas en Excel arrastra decimales (64h 11,99m).
            void FechaHora(int fila, int columna, DateTime? valor)
            {
                if (!valor.HasValue)
                {
                    ws.Cell(fila, columna).Value = "-";
                    ws.Cell(fila, columna + 1).Value = "-";
                    return;
                }
                var v = valor.Value;
                ws.Cell(fila, columna).Value = v.Date;
                ws.Cell(fila, columna).Style.DateFormat.Format = "dd/MM/yyyy";
                ws.Cell(fila, columna + 1).Value = new TimeSpan(v.Hour, v.Minute, 0);
                ws.Cell(fila, columna + 1).Style.DateFormat.Format = "HH:mm";
            }

            void MinutosHabiles(int fila, int columna, int? minutos)
            {
                if (minutos.HasValue) ws.Cell(fila, columna).Value = minutos.Value / 1440.0;
                else ws.Cell(fila, columna).Value = "-";
            }

            var fila = 2;
            foreach (var t in tickets)
            {
                ws.Cell(fila, 1).Value = t.CodigoTicket;
                ws.Cell(fila, 2).Value = t.EstadoActual ?? "-";
                ws.Cell(fila, 3).Value = t.Area ?? "-";
                ws.Cell(fila, 4).Value = t.Prioridad ?? "-";
                ws.Cell(fila, 5).Value = string.IsNullOrWhiteSpace(t.AsesorAsignado) ? "-" : t.AsesorAsignado;
                FechaHora(fila, 6, t.FechaCreacion);   // F, G
                FechaHora(fila, 8, t.FechaToma);       // H, I
                FechaHora(fila, 10, t.FechaResolucion); // J, K

                var r = fila;
                ws.Cell(fila, 12).FormulaA1 = $"IF(H{r}=\"-\",\"-\",ROUND(((H{r}+I{r})-(F{r}+G{r}))*1440,0)/1440)";
                ws.Cell(fila, 13).FormulaA1 = $"IF(J{r}=\"-\",\"-\",ROUND(((J{r}+K{r})-(F{r}+G{r}))*1440,0)/1440)";
                ws.Cell(fila, 14).FormulaA1 = $"IF(OR(H{r}=\"-\",J{r}=\"-\"),\"-\",ROUND(((J{r}+K{r})-(H{r}+I{r}))*1440,0)/1440)";

                MinutosHabiles(fila, 15, t.MinColaHabil);
                MinutosHabiles(fila, 16, t.MinResolucionTotalHabil);
                MinutosHabiles(fila, 17, t.MinTrabajoAsesorHabil);
                fila++;
            }

            if (fila > 2)
            {
                var tiempos = ws.Range(2, 12, fila - 1, 17);
                tiempos.Style.NumberFormat.Format = formatoDuracion;
                tiempos.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
            }
            ws.Columns().AdjustToContents();
            ws.SheetView.FreezeRows(1);
        }
    }
}
