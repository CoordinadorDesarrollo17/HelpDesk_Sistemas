using Dapper;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;

namespace HelpDesk_Sistemas.Repositories
{
    // Consultas para la API de Power BI (Controllers/PowerBiApiController.cs). Son
    // deliberadamente independientes de TicketsRepository: esas consultas están armadas
    // para "mi cola de tickets" (acotadas por rol/usuario, TOP 200, orden de cola) — acá
    // se necesita el extracto completo de toda la organización, sin esos recortes.
    public class PowerBiRepository : IPowerBiRepository
    {
        private readonly DapperContext dapperContext;

        public PowerBiRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        public async Task<List<PowerBiTicketModel>> ObtenerTickets(DateTime? fechaInicio, DateTime? fechaFin)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var condiciones = new List<string> { "1 = 1" };
            if (fechaInicio.HasValue) condiciones.Add("t.Fecha_Creacion >= @FechaInicio");
            if (fechaFin.HasValue) condiciones.Add("t.Fecha_Creacion < @FechaFinExclusiva");

            var sql = $@"
                SELECT
                    t.Id, t.Codigo_Ticket AS CodigoTicket,
                    soc.Nombre AS Sociedad,
                    a.Nombre AS Area,
                    aSol.Nombre AS AreaSolicitante,
                    tr.Nombre AS TipoAtencion,
                    tr.Flujo,
                    c.Nombre AS Categoria,
                    sis.Nombre AS Sistema,
                    e.Nombre AS Estado,
                    p.Nombre AS Prioridad,
                    imp.Nombre AS Impacto,
                    urg.Nombre AS Urgencia,
                    CONCAT(us.Nombre, ' ', us.Apellido) AS Solicitante,
                    CONCAT(ua.Nombre, ' ', ua.Apellido) AS Asignado,
                    t.Fecha_Creacion AS FechaCreacion,
                    t.Fecha_Asignacion AS FechaAsignacion,
                    t.Fecha_Atencion AS FechaAtencion,
                    t.Fecha_Cierre AS FechaCierre,

                    tsr.Etapa AS SlaRespuestaEtapa,
                    tsr.Incumplido AS SlaRespuestaIncumplido,
                    CASE WHEN tsr.Id IS NULL OR tsr.Minutos_Objetivo = 0 THEN NULL ELSE
                        CAST(dbo.fn_MinutosHabilesEntre(tsr.Fecha_Inicio, ISNULL(tsr.Fecha_Fin, GETDATE()), dsr.Id_Calendario) AS DECIMAL(10,2)) / tsr.Minutos_Objetivo * 100
                    END AS SlaRespuestaPorcentajeConsumido,

                    tso.Etapa AS SlaResolucionEtapa,
                    tso.Incumplido AS SlaResolucionIncumplido,
                    CASE WHEN tso.Id IS NULL OR tso.Minutos_Objetivo = 0 THEN NULL ELSE
                        CAST(dbo.fn_MinutosHabilesEntre(tso.Fecha_Inicio, ISNULL(tso.Fecha_Fin, GETDATE()), dso.Id_Calendario) AS DECIMAL(10,2)) / tso.Minutos_Objetivo * 100
                    END AS SlaResolucionPorcentajeConsumido

                FROM Tickets t
                INNER JOIN Tipo_Requerimiento tr ON tr.Id = t.Id_Tipo_Req
                INNER JOIN Area a               ON a.Id  = t.Id_Area
                LEFT  JOIN Categoria c          ON c.Id  = t.Id_Categoria
                INNER JOIN Estado e             ON e.Id  = t.Id_Estado
                LEFT  JOIN Prioridad p          ON p.Id  = t.Id_Prioridad
                LEFT  JOIN Impacto imp          ON imp.Id = t.Id_Impacto
                LEFT  JOIN Urgencia urg         ON urg.Id = t.Id_Urgencia
                INNER JOIN Usuarios us          ON us.Id = t.Id_Usuario_Solicita
                LEFT  JOIN Area aSol            ON aSol.Id = us.Id_Area
                LEFT  JOIN Usuarios ua          ON ua.Id = t.Id_Usuario_Asignado
                LEFT  JOIN Sociedad soc         ON soc.Id = t.Id_Sociedad
                LEFT  JOIN Sistema sis          ON sis.Id = t.Id_Sistema
                LEFT JOIN Ticket_SLA tsr ON tsr.Id_Ticket = t.Id
                    AND tsr.Id_SLA_Definicion IN (SELECT Id FROM SLA_Definicion WHERE Tipo_SLA = 'Respuesta')
                LEFT JOIN SLA_Definicion dsr ON dsr.Id = tsr.Id_SLA_Definicion
                LEFT JOIN Ticket_SLA tso ON tso.Id_Ticket = t.Id
                    AND tso.Id_SLA_Definicion IN (SELECT Id FROM SLA_Definicion WHERE Tipo_SLA = 'Resolucion')
                LEFT JOIN SLA_Definicion dso ON dso.Id = tso.Id_SLA_Definicion
                WHERE {string.Join(" AND ", condiciones)}
                ORDER BY t.Fecha_Creacion DESC
            ";

            var result = await xCon.QueryAsync<PowerBiTicketModel>(sql, new
            {
                FechaInicio = fechaInicio,
                FechaFinExclusiva = fechaFin?.AddDays(1)
            });

            return result.ToList();
        }

        public async Task<List<PowerBiDepartamentoModel>> ObtenerDepartamentos()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre, Prefijo FROM Departamento WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<PowerBiDepartamentoModel>(sql);
            return result.ToList();
        }

        public async Task<List<PowerBiAreaModel>> ObtenerAreas()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                SELECT
                    a.Id, a.Nombre, a.Id_Departamento AS IdDepartamento, d.Nombre AS Departamento,
                    a.Es_Area_Sistemas AS EsAreaSistemas, a.Requiere_Sistema AS RequiereSistema
                FROM Area a
                LEFT JOIN Departamento d ON d.Id = a.Id_Departamento
                WHERE a.Activo = 1
                ORDER BY a.Nombre
            ";
            var result = await xCon.QueryAsync<PowerBiAreaModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerSociedades()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Sociedad WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<PowerBiTipoAtencionModel>> ObtenerTiposAtencion()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                SELECT tr.Id, tr.Nombre, a.Nombre AS Area, tr.Flujo, tr.Usa_Impacto_Urgencia AS UsaImpactoUrgencia
                FROM Tipo_Requerimiento tr
                INNER JOIN Area a ON a.Id = tr.Id_Area
                WHERE tr.Activo = 1
                ORDER BY a.Nombre, tr.Nombre
            ";
            var result = await xCon.QueryAsync<PowerBiTipoAtencionModel>(sql);
            return result.ToList();
        }

        public async Task<List<PowerBiCategoriaModel>> ObtenerCategorias()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                SELECT c.Id, c.Nombre, tr.Nombre AS TipoAtencion, a.Nombre AS Area
                FROM Categoria c
                INNER JOIN Tipo_Requerimiento tr ON tr.Id = c.Id_Tipo_Req
                INNER JOIN Area a ON a.Id = tr.Id_Area
                WHERE c.Activo = 1
                ORDER BY a.Nombre, tr.Nombre, c.Nombre
            ";
            var result = await xCon.QueryAsync<PowerBiCategoriaModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerSistemas()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Sistema WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerEstados()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Estado WHERE Activo = 1 ORDER BY Orden";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerPrioridades()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Prioridad WHERE Activo = 1 ORDER BY Orden";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<PowerBiUsuarioModel>> ObtenerUsuarios()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            // Sociedades por sub-query concatenado (igual que UsuariosRepository.ObtenerUsuarios):
            // con JOIN directo, un usuario con N sociedades saldría repetido N veces.
            var sql = @"
                SELECT
                    u.Id, u.Nombre, u.Apellido, u.Usuario, r.Nombre AS Rol,
                    a.Nombre AS Area, d.Nombre AS Departamento, u.Activo,
                    (
                        SELECT STRING_AGG(s.Nombre, ', ') WITHIN GROUP (ORDER BY s.Nombre)
                        FROM Usuario_Sociedad us2
                        INNER JOIN Sociedad s ON s.Id = us2.Id_Sociedad
                        WHERE us2.Id_Usuario = u.Id
                    ) AS Sociedades
                FROM Usuarios u
                INNER JOIN Rol r ON r.Id = u.IdRol
                INNER JOIN Area a ON a.Id = u.Id_Area
                LEFT JOIN Departamento d ON d.Id = a.Id_Departamento
                ORDER BY u.Nombre, u.Apellido
            ";

            var result = await xCon.QueryAsync<PowerBiUsuarioModel>(sql);
            return result.ToList();
        }
    }
}
