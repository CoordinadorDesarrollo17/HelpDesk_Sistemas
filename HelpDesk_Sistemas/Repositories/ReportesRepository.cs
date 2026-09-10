using Dapper;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;

namespace HelpDesk_Sistemas.Repositories
{
    public class ReportesRepository : IReportesRepository
    {
        private readonly DapperContext dapperContext;

        public ReportesRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        public async Task<ReporteGeneralModel> ObtenerReporteGeneral(ReporteFiltroModel filtro)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                -- 1) Resumen general (según fecha de creación). Los 3 tiempos son horas
                --    corridas (wall-clock) y forman una descomposición coherente: se
                --    promedian sobre el MISMO conjunto (tickets ya cerrados y asignados),
                --    así Cola + TrabajoAgente ~= Resolucion total.
                --      Cola          = creación -> asignación
                --      TrabajoAgente = asignación -> cierre
                --      Resolucion    = creación -> cierre
                SELECT
                    COUNT(*) AS TotalCreados,
                    SUM(CASE WHEN e.Nombre IN ('Cerrado', 'Cierre') THEN 1 ELSE 0 END) AS TotalCerrados,
                    SUM(CASE WHEN e.Nombre NOT IN ('Cerrado', 'Cierre', 'Anulado') THEN 1 ELSE 0 END) AS TicketsActivos,
                    AVG(CASE WHEN t.Fecha_Cierre IS NOT NULL AND t.Fecha_Asignacion IS NOT NULL
                             THEN CAST(DATEDIFF(MINUTE, t.Fecha_Creacion, t.Fecha_Asignacion) AS DECIMAL(10,2)) / 60.0 END) AS TiempoPromedioColaHoras,
                    AVG(CASE WHEN t.Fecha_Cierre IS NOT NULL AND t.Fecha_Asignacion IS NOT NULL
                             THEN CAST(DATEDIFF(MINUTE, t.Fecha_Asignacion, t.Fecha_Cierre) AS DECIMAL(10,2)) / 60.0 END) AS TiempoPromedioTrabajoAgenteHoras,
                    AVG(CASE WHEN t.Fecha_Cierre IS NOT NULL AND t.Fecha_Asignacion IS NOT NULL
                             THEN CAST(DATEDIFF(MINUTE, t.Fecha_Creacion, t.Fecha_Cierre) AS DECIMAL(10,2)) / 60.0 END) AS TiempoPromedioResolucionHoras
                FROM Tickets t
                INNER JOIN Estado e ON e.Id = t.Id_Estado
                WHERE t.Fecha_Creacion >= @FechaInicio AND t.Fecha_Creacion < @FechaFinExclusiva;

                -- 2) Tendencia diaria: creados vs cerrados
                SELECT Fecha, SUM(Creados) AS Creados, SUM(Cerrados) AS Cerrados
                FROM (
                    SELECT CAST(Fecha_Creacion AS DATE) AS Fecha, 1 AS Creados, 0 AS Cerrados
                    FROM Tickets
                    WHERE Fecha_Creacion >= @FechaInicio AND Fecha_Creacion < @FechaFinExclusiva

                    UNION ALL

                    SELECT CAST(Fecha_Cierre AS DATE) AS Fecha, 0 AS Creados, 1 AS Cerrados
                    FROM Tickets
                    WHERE Fecha_Cierre >= @FechaInicio AND Fecha_Cierre < @FechaFinExclusiva
                ) x
                GROUP BY Fecha
                ORDER BY Fecha;

                -- 3) Distribución por tipo de atención
                SELECT tr.Nombre AS Etiqueta, COUNT(*) AS Cantidad
                FROM Tickets t
                INNER JOIN Tipo_Requerimiento tr ON tr.Id = t.Id_Tipo_Req
                WHERE t.Fecha_Creacion >= @FechaInicio AND t.Fecha_Creacion < @FechaFinExclusiva
                GROUP BY tr.Nombre
                ORDER BY Cantidad DESC;

                -- 4) Distribución por área
                SELECT a.Nombre AS Etiqueta, COUNT(*) AS Cantidad
                FROM Tickets t
                INNER JOIN Area a ON a.Id = t.Id_Area
                WHERE t.Fecha_Creacion >= @FechaInicio AND t.Fecha_Creacion < @FechaFinExclusiva
                GROUP BY a.Nombre
                ORDER BY Cantidad DESC;

                -- 5) Distribución por prioridad
                SELECT ISNULL(p.Nombre, 'Sin prioridad') AS Etiqueta, COUNT(*) AS Cantidad
                FROM Tickets t
                LEFT JOIN Prioridad p ON p.Id = t.Id_Prioridad
                WHERE t.Fecha_Creacion >= @FechaInicio AND t.Fecha_Creacion < @FechaFinExclusiva
                GROUP BY p.Nombre, p.Orden
                ORDER BY p.Orden;

                -- 6) Productividad por agente asignado. Cola = horas corridas que sus
                --    tickets esperaron antes de que él los tomara (creación->asignación);
                --    Resolucion = horas corridas ya trabajándolo (asignación->cierre).
                SELECT
                    CONCAT(u.Nombre, ' ', u.Apellido) AS Agente,
                    COUNT(*) AS Asignados,
                    SUM(CASE WHEN e.Nombre IN ('Cerrado', 'Cierre') THEN 1 ELSE 0 END) AS Cerrados,
                    SUM(CASE WHEN e.Nombre NOT IN ('Cerrado', 'Cierre', 'Anulado') THEN 1 ELSE 0 END) AS Activos,
                    AVG(CASE WHEN t.Fecha_Asignacion IS NOT NULL
                             THEN CAST(DATEDIFF(MINUTE, t.Fecha_Creacion, t.Fecha_Asignacion) AS DECIMAL(10,2)) / 60.0 END) AS TiempoPromedioColaHoras,
                    AVG(CASE WHEN t.Fecha_Cierre IS NOT NULL AND t.Fecha_Asignacion IS NOT NULL
                             THEN CAST(DATEDIFF(MINUTE, t.Fecha_Asignacion, t.Fecha_Cierre) AS DECIMAL(10,2)) / 60.0 END) AS TiempoPromedioResolucionHoras,
                    (
                        SELECT COUNT(*)
                        FROM Ticket_Historial h
                        INNER JOIN Tickets t2 ON t2.Id = h.Id_Ticket
                        WHERE t2.Id_Usuario_Asignado = u.Id
                          AND h.Id_Estado_Anterior = (SELECT Id FROM Estado WHERE Nombre = 'En validación')
                          AND h.Id_Estado_Nuevo = (SELECT Id FROM Estado WHERE Nombre = 'En atención')
                          AND t2.Fecha_Creacion >= @FechaInicio AND t2.Fecha_Creacion < @FechaFinExclusiva
                    ) AS Devoluciones
                FROM Tickets t
                INNER JOIN Usuarios u ON u.Id = t.Id_Usuario_Asignado
                INNER JOIN Estado e ON e.Id = t.Id_Estado
                WHERE t.Fecha_Creacion >= @FechaInicio AND t.Fecha_Creacion < @FechaFinExclusiva
                  AND (@IdAreaAgente IS NULL OR t.Id_Area = @IdAreaAgente)
                GROUP BY u.Id, u.Nombre, u.Apellido
                ORDER BY Cerrados DESC, Asignados DESC;

                -- 7) Detalle por ticket: los 3 tramos ya calculados (vista vw_TiemposTicket).
                --    Trae horas hábiles (como el SLA) y horas corridas. Solo se usa para la
                --    hoja de detalle del Excel.
                SELECT
                    v.CodigoTicket, v.EstadoActual, v.Area, v.Prioridad, v.AsesorAsignado,
                    v.FechaCreacion, v.FechaToma, v.FechaResolucion,
                    v.MinCola_Habil            AS MinColaHabil,
                    v.MinTrabajoAsesor_Habil   AS MinTrabajoAsesorHabil,
                    v.MinResolucionTotal_Habil AS MinResolucionTotalHabil,
                    v.MinCola_Reloj            AS MinColaReloj,
                    v.MinTrabajoAsesor_Reloj   AS MinTrabajoAsesorReloj,
                    v.MinResolucionTotal_Reloj AS MinResolucionTotalReloj
                FROM vw_TiemposTicket v
                WHERE v.FechaCreacion >= @FechaInicio AND v.FechaCreacion < @FechaFinExclusiva
                  AND (@IdAreaAgente IS NULL OR v.IdArea = @IdAreaAgente)
                ORDER BY v.FechaCreacion DESC;
            ";

            var parametros = new
            {
                filtro.FechaInicio,
                FechaFinExclusiva = filtro.FechaFin.Date.AddDays(1),
                filtro.IdAreaAgente
            };

            using var multi = await xCon.QueryMultipleAsync(sql, parametros);

            var resumen = await multi.ReadFirstOrDefaultAsync<ReporteResumenModel>() ?? new ReporteResumenModel();
            var tendencia = (await multi.ReadAsync<ReporteTendenciaPuntoModel>()).ToList();
            var porTipo = (await multi.ReadAsync<ReporteDistribucionModel>()).ToList();
            var porArea = (await multi.ReadAsync<ReporteDistribucionModel>()).ToList();
            var porPrioridad = (await multi.ReadAsync<ReporteDistribucionModel>()).ToList();
            var porAgente = (await multi.ReadAsync<ReporteAgenteModel>()).ToList();
            var detalleTiempos = (await multi.ReadAsync<ReporteTiempoTicketModel>()).ToList();

            return new ReporteGeneralModel
            {
                Resumen = resumen,
                Tendencia = tendencia,
                PorTipo = porTipo,
                PorArea = porArea,
                PorPrioridad = porPrioridad,
                PorAgente = porAgente,
                DetalleTiempos = detalleTiempos
            };
        }
    }
}
