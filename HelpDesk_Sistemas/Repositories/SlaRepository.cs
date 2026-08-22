using Dapper;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;

namespace HelpDesk_Sistemas.Repositories
{
    public class SlaRepository : ISlaRepository
    {
        private readonly DapperContext dapperContext;

        public SlaRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        // ============================================================
        // CALENDARIO LABORAL
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerCalendarios()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Calendario_Laboral WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<SlaCalendarioModel?> ObtenerCalendarioPorId(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sqlCalendario = "SELECT Id, Nombre, Activo FROM Calendario_Laboral WHERE Id = @Id";
            var calendario = await xCon.QueryFirstOrDefaultAsync<SlaCalendarioModel>(sqlCalendario, new { Id = id });

            if (calendario is null) return null;

            var sqlHorarios = @"
                SELECT Id, Id_Calendario AS IdCalendario, Dia_Semana AS DiaSemana,
                       Hora_Inicio AS HoraInicio, Hora_Fin AS HoraFin, Activo
                FROM Calendario_Horario
                WHERE Id_Calendario = @Id AND Activo = 1
                ORDER BY Dia_Semana, Hora_Inicio
            ";
            var horarios = await xCon.QueryAsync<SlaHorarioModel>(sqlHorarios, new { Id = id });
            calendario.Horarios = horarios.ToList();

            var sqlFeriados = @"
                SELECT Id, Id_Calendario AS IdCalendario, Fecha, Descripcion
                FROM Calendario_Feriado
                WHERE Id_Calendario = @Id
                ORDER BY Fecha
            ";
            var feriados = await xCon.QueryAsync<SlaFeriadoModel>(sqlFeriados, new { Id = id });
            calendario.Feriados = feriados.ToList();

            return calendario;
        }

        public async Task<int> CrearCalendario(SlaCalendarioRequest model, string usuarioCreacion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                INSERT INTO Calendario_Laboral (Nombre, Usu_Creacion) VALUES (@Nombre, @Usuario);
                SELECT SCOPE_IDENTITY();
            ";

            return await xCon.ExecuteScalarAsync<int>(sql, new { model.Nombre, Usuario = usuarioCreacion });
        }

        public async Task<bool> RenombrarCalendario(int id, string nombre)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Calendario_Laboral SET Nombre = @Nombre WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, Nombre = nombre });
            return filas > 0;
        }

        public async Task<bool> CambiarActivoCalendario(int id, bool activo)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Calendario_Laboral SET Activo = @Activo WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, Activo = activo });
            return filas > 0;
        }

        public async Task<int> AgregarHorario(SlaHorarioRequest model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                INSERT INTO Calendario_Horario (Id_Calendario, Dia_Semana, Hora_Inicio, Hora_Fin)
                VALUES (@IdCalendario, @DiaSemana, @HoraInicio, @HoraFin);
                SELECT SCOPE_IDENTITY();
            ";

            return await xCon.ExecuteScalarAsync<int>(sql, new { model.IdCalendario, model.DiaSemana, model.HoraInicio, model.HoraFin });
        }

        public async Task<bool> ActualizarHorario(int id, SlaHorarioRequest model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Calendario_Horario SET Dia_Semana = @DiaSemana, Hora_Inicio = @HoraInicio, Hora_Fin = @HoraFin WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, model.DiaSemana, model.HoraInicio, model.HoraFin });
            return filas > 0;
        }

        public async Task<bool> EliminarHorario(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "DELETE FROM Calendario_Horario WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id });
            return filas > 0;
        }

        public async Task<int> AgregarFeriado(SlaFeriadoRequest model, string usuarioCreacion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                INSERT INTO Calendario_Feriado (Id_Calendario, Fecha, Descripcion, Usu_Creacion)
                VALUES (@IdCalendario, @Fecha, @Descripcion, @Usuario);
                SELECT SCOPE_IDENTITY();
            ";

            return await xCon.ExecuteScalarAsync<int>(sql, new { model.IdCalendario, model.Fecha, model.Descripcion, Usuario = usuarioCreacion });
        }

        public async Task<bool> ActualizarFeriado(int id, SlaFeriadoRequest model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Calendario_Feriado SET Fecha = @Fecha, Descripcion = @Descripcion WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, model.Fecha, model.Descripcion });
            return filas > 0;
        }

        public async Task<bool> EliminarFeriado(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "DELETE FROM Calendario_Feriado WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id });
            return filas > 0;
        }

        // ============================================================
        // DEFINICIONES DE SLA
        // ============================================================

        private const string SqlDefinicionBase = @"
            SELECT
                d.Id, d.Nombre, d.Tipo_SLA AS TipoSla,
                d.Id_Tipo_Req AS IdTipoReq, tr.Nombre AS TipoRequerimiento,
                a.Nombre AS Area,
                d.Id_Categoria AS IdCategoria, c.Nombre AS Categoria,
                d.Id_Prioridad AS IdPrioridad, p.Nombre AS Prioridad,
                d.Id_Sociedad AS IdSociedad, s.Nombre AS Sociedad,
                d.Id_Calendario AS IdCalendario, cal.Nombre AS Calendario,
                d.Duracion_Minutos AS DuracionMinutos,
                d.Porcentaje_Advertencia AS PorcentajeAdvertencia,
                d.Reactivable, d.Especificidad, d.Activo
            FROM SLA_Definicion d
            LEFT  JOIN Tipo_Requerimiento tr  ON tr.Id  = d.Id_Tipo_Req
            LEFT  JOIN Area a                 ON a.Id   = tr.Id_Area
            LEFT  JOIN Categoria c            ON c.Id   = d.Id_Categoria
            LEFT  JOIN Prioridad p            ON p.Id   = d.Id_Prioridad
            LEFT  JOIN Sociedad s             ON s.Id   = d.Id_Sociedad
            INNER JOIN Calendario_Laboral cal ON cal.Id = d.Id_Calendario
        ";

        public async Task<List<SlaDefinicionModel>> ObtenerDefiniciones()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = SqlDefinicionBase + " ORDER BY d.Tipo_SLA, d.Especificidad DESC, d.Nombre";
            var result = await xCon.QueryAsync<SlaDefinicionModel>(sql);
            return result.ToList();
        }

        public async Task<SlaDefinicionModel?> ObtenerDefinicionPorId(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = SqlDefinicionBase + " WHERE d.Id = @Id";
            return await xCon.QueryFirstOrDefaultAsync<SlaDefinicionModel>(sql, new { Id = id });
        }

        public async Task<int> CrearDefinicion(SlaDefinicionRequest model, string usuarioCreacion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                INSERT INTO SLA_Definicion
                    (Nombre, Tipo_SLA, Id_Tipo_Req, Id_Categoria, Id_Prioridad, Id_Sociedad, Id_Calendario,
                     Duracion_Minutos, Porcentaje_Advertencia, Reactivable, Usu_Creacion)
                VALUES
                    (@Nombre, @TipoSla, @IdTipoReq, @IdCategoria, @IdPrioridad, @IdSociedad, @IdCalendario,
                     @DuracionMinutos, @PorcentajeAdvertencia, @Reactivable, @Usuario);
                SELECT SCOPE_IDENTITY();
            ";

            return await xCon.ExecuteScalarAsync<int>(sql, new
            {
                model.Nombre,
                model.TipoSla,
                model.IdTipoReq,
                model.IdCategoria,
                model.IdPrioridad,
                model.IdSociedad,
                model.IdCalendario,
                model.DuracionMinutos,
                model.PorcentajeAdvertencia,
                model.Reactivable,
                Usuario = usuarioCreacion
            });
        }

        public async Task<bool> ActualizarDefinicion(int id, SlaDefinicionRequest model, string usuarioModificacion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                UPDATE SLA_Definicion
                SET Nombre = @Nombre,
                    Tipo_SLA = @TipoSla,
                    Id_Tipo_Req = @IdTipoReq,
                    Id_Categoria = @IdCategoria,
                    Id_Prioridad = @IdPrioridad,
                    Id_Sociedad = @IdSociedad,
                    Id_Calendario = @IdCalendario,
                    Duracion_Minutos = @DuracionMinutos,
                    Porcentaje_Advertencia = @PorcentajeAdvertencia,
                    Reactivable = @Reactivable,
                    Usu_Modificacion = @Usuario,
                    Fecha_Modificacion = GETDATE()
                WHERE Id = @Id
            ";

            var filas = await xCon.ExecuteAsync(sql, new
            {
                Id = id,
                model.Nombre,
                model.TipoSla,
                model.IdTipoReq,
                model.IdCategoria,
                model.IdPrioridad,
                model.IdSociedad,
                model.IdCalendario,
                model.DuracionMinutos,
                model.PorcentajeAdvertencia,
                model.Reactivable,
                Usuario = usuarioModificacion
            });

            return filas > 0;
        }

        public async Task<bool> CambiarActivoDefinicion(int id, bool activo)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE SLA_Definicion SET Activo = @Activo WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, Activo = activo });
            return filas > 0;
        }

        // ============================================================
        // CATÁLOGOS AUXILIARES
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerTodasLasCategorias()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                SELECT c.Id AS Id, CONCAT(a.Nombre, ' - ', c.Nombre) AS Nombre
                FROM Categoria c
                INNER JOIN Area a ON a.Id = c.Id_Area
                WHERE c.Activo = 1
                ORDER BY a.Nombre, c.Nombre
            ";

            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerTodasLasSociedades()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Sociedad WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        // ============================================================
        // DASHBOARD DE CUMPLIMIENTO
        // ============================================================

        public async Task<SlaDashboardModel> ObtenerDashboard()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                -- 1) Resumen general
                SELECT
                    SUM(CASE WHEN Etapa = 'Completado' THEN 1 ELSE 0 END) AS TotalCompletados,
                    SUM(CASE WHEN Etapa = 'Completado' AND Cumplido_A_Tiempo = 1 THEN 1 ELSE 0 END) AS CumplidosATiempo,
                    SUM(CASE WHEN Etapa = 'Completado' AND Cumplido_A_Tiempo = 0 THEN 1 ELSE 0 END) AS IncumplidosCompletados,
                    SUM(CASE WHEN Etapa IN ('EnCurso', 'Pausado') THEN 1 ELSE 0 END) AS EnCursoActivos,
                    SUM(CASE WHEN Etapa IN ('EnCurso', 'Pausado') AND Incumplido = 0 AND Advertencia_Activa = 1 THEN 1 ELSE 0 END) AS EnRiesgo,
                    SUM(CASE WHEN Etapa IN ('EnCurso', 'Pausado') AND Incumplido = 1 THEN 1 ELSE 0 END) AS IncumplidosEnCurso
                FROM Ticket_SLA;

                -- 2) Por prioridad (solo SLA ya completados, para medir cumplimiento histórico)
                SELECT
                    ISNULL(p.Nombre, 'Sin prioridad') AS Grupo,
                    SUM(CASE WHEN ts.Etapa = 'Completado' THEN 1 ELSE 0 END) AS Completados,
                    SUM(CASE WHEN ts.Etapa = 'Completado' AND ts.Cumplido_A_Tiempo = 1 THEN 1 ELSE 0 END) AS CumplidosATiempo,
                    SUM(CASE WHEN ts.Etapa = 'Completado' AND ts.Cumplido_A_Tiempo = 0 THEN 1 ELSE 0 END) AS Incumplidos
                FROM Ticket_SLA ts
                INNER JOIN Tickets t ON t.Id = ts.Id_Ticket
                LEFT JOIN Prioridad p ON p.Id = t.Id_Prioridad
                WHERE ts.Etapa = 'Completado'
                GROUP BY p.Nombre, p.Orden
                ORDER BY p.Orden;

                -- 3) Por agente asignado
                SELECT
                    CONCAT(u.Nombre, ' ', u.Apellido) AS Grupo,
                    SUM(CASE WHEN ts.Etapa = 'Completado' THEN 1 ELSE 0 END) AS Completados,
                    SUM(CASE WHEN ts.Etapa = 'Completado' AND ts.Cumplido_A_Tiempo = 1 THEN 1 ELSE 0 END) AS CumplidosATiempo,
                    SUM(CASE WHEN ts.Etapa = 'Completado' AND ts.Cumplido_A_Tiempo = 0 THEN 1 ELSE 0 END) AS Incumplidos
                FROM Ticket_SLA ts
                INNER JOIN Tickets t ON t.Id = ts.Id_Ticket
                INNER JOIN Usuarios u ON u.Id = t.Id_Usuario_Asignado
                WHERE ts.Etapa = 'Completado'
                GROUP BY u.Id, u.Nombre, u.Apellido
                ORDER BY Incumplidos DESC, Grupo;

                -- 4) SLA en riesgo, incumplidos en curso, o incumplidos ya finalizados
                -- (antes solo se listaban los dos primeros; los finalizados solo se
                -- contaban en el resumen y no se podían ver en ninguna lista).
                SELECT
                    t.Id AS IdTicket,
                    t.Codigo_Ticket AS CodigoTicket,
                    d.Tipo_SLA AS TipoSla,
                    e.Nombre AS Estado,
                    p.Nombre AS Prioridad,
                    CONCAT(ua.Nombre, ' ', ua.Apellido) AS Asignado,
                    ts.Fecha_Objetivo AS FechaObjetivo,
                    ts.Incumplido,
                    ts.Advertencia_Activa AS AdvertenciaActiva,
                    ts.Etapa
                FROM Ticket_SLA ts
                INNER JOIN SLA_Definicion d ON d.Id = ts.Id_SLA_Definicion
                INNER JOIN Tickets t ON t.Id = ts.Id_Ticket
                INNER JOIN Estado e ON e.Id = t.Id_Estado
                LEFT JOIN Prioridad p ON p.Id = t.Id_Prioridad
                LEFT JOIN Usuarios ua ON ua.Id = t.Id_Usuario_Asignado
                WHERE (ts.Etapa IN ('EnCurso', 'Pausado') AND (ts.Incumplido = 1 OR ts.Advertencia_Activa = 1))
                   OR (ts.Etapa = 'Completado' AND ts.Cumplido_A_Tiempo = 0)
                ORDER BY ts.Incumplido DESC, ts.Fecha_Objetivo ASC;
            ";

            using var multi = await xCon.QueryMultipleAsync(sql);

            var resumen = await multi.ReadFirstOrDefaultAsync<SlaResumenModel>() ?? new SlaResumenModel();
            var porPrioridad = (await multi.ReadAsync<SlaResumenPorGrupoModel>()).ToList();
            var porAgente = (await multi.ReadAsync<SlaResumenPorGrupoModel>()).ToList();
            var enRiesgo = (await multi.ReadAsync<TicketSlaRiesgoModel>()).ToList();

            return new SlaDashboardModel
            {
                Resumen = resumen,
                PorPrioridad = porPrioridad,
                PorAgente = porAgente,
                EnRiesgoOIncumplidos = enRiesgo
            };
        }
    }
}
