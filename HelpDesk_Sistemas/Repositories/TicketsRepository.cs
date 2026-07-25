using System.Security.Cryptography.Xml;
using Dapper;
using DocumentFormat.OpenXml.Office2013.Drawing.Chart;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;
using X.PagedList;
using X.PagedList.Extensions;

namespace HelpDesk_Sistemas.Repositories
{
    public class TicketsRepository : ITicketsRepository
    {
        private readonly DapperContext dapperContext;

        public TicketsRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        public async Task<IEnumerable<TicketsModel>> ObtenerTickets(FiltrosTicketsModel model, int idUsuarioActual)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var condiciones = new List<string>
            {
                "CONCAT(t.Codigo_Ticket, tr.Nombre, a.Nombre, e.Nombre, us.Nombre, us.Apellido) LIKE @Buscar"
            };

            if (model.IdEstado.HasValue)
            {
                condiciones.Add("t.Id_Estado = @IdEstado");
                condiciones.Add("(e.Nombre = 'Pendiente' OR t.Id_Usuario_Asignado = @IdUsuarioActual)");
            }

            if (model.IdArea.HasValue)
                condiciones.Add("t.Id_Area = @IdArea");

            if (model.IdTipoRequerimiento.HasValue)
                condiciones.Add("t.Id_Tipo_Req = @IdTipoRequerimiento");

            if (model.IdPrioridad.HasValue)
                condiciones.Add("t.Id_Prioridad = @IdPrioridad");

            var whereClause = string.Join(" AND ", condiciones);

            var sql = $@"
            SELECT TOP 200
            t.Id                                 AS IdTicket,
            t.Codigo_Ticket                       AS CodigoTicket,
            tr.Nombre                             AS TipoRequerimiento,
            a.Nombre                              AS Area,
            c.Nombre                              AS Categoria,
            e.Nombre                              AS Estado,
            p.Nombre                              AS Prioridad,
            CONCAT(us.Nombre, ' ', us.Apellido)   AS Solicitante,
            CONCAT(ua.Nombre, ' ', ua.Apellido)   AS Asignado,
            t.Fecha_Creacion                      AS FechaCreacion,
            t.Afecta_Funcionamiento               AS AfectaFuncionamiento,
            t.Orden_Atencion                      AS OrdenAtencion,
            t.Id_Area                             AS IdArea,
(
    CASE WHEN t.Id_Usuario_Asignado IS NULL THEN 0
    ELSE (
        SELECT COUNT(*)
        FROM Tickets t2
        INNER JOIN Estado e2 ON e2.Id = t2.Id_Estado
        WHERE t2.Id_Usuario_Asignado = t.Id_Usuario_Asignado
          AND t2.Id_Prioridad = t.Id_Prioridad
          AND e2.Nombre NOT IN ('Cerrado', 'Anulado')
    )
    END
) AS CantidadMismaAsignadoPrioridad
        FROM Tickets t
        INNER JOIN Tipo_Requerimiento tr ON tr.Id = t.Id_Tipo_Req
        INNER JOIN Area a                ON a.Id  = t.Id_Area
        LEFT  JOIN Categoria c           ON c.Id  = t.Id_Categoria
        INNER JOIN Estado e              ON e.Id  = t.Id_Estado
        LEFT  JOIN Prioridad p           ON p.Id  = t.Id_Prioridad
        INNER JOIN Usuarios us           ON us.Id = t.Id_Usuario_Solicita
        LEFT  JOIN Usuarios ua           ON ua.Id = t.Id_Usuario_Asignado
        WHERE {whereClause}
        ORDER BY CASE WHEN e.Nombre = 'Pendiente' THEN 0 ELSE 1 END, t.Fecha_Creacion DESC
            ";

            var result = await xCon.QueryAsync<TicketsModel>(sql, new
            {
                Buscar = "%" + model.Buscar + "%",
                model.IdEstado,
                model.IdArea,
                model.IdTipoRequerimiento,
                model.IdPrioridad,
                IdUsuarioActual = idUsuarioActual
            });

            return result;
        }

        public async Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual)
        {
            var result = await ObtenerTickets(model, idUsuarioActual);
            return result.ToPagedList(model.Paginacion.Page, model.Paginacion.PageSize);
        }

        public async Task<List<TicketsModel>> ListadoTicketsExcel(FiltrosTicketsModel model, int idUsuarioActual)
        {
            var result = await ObtenerTickets(model, idUsuarioActual);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerEstados()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Estado WHERE Activo = 1 ORDER BY Orden";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<TicketDetalleModel?> ObtenerDetalleTicket(int idTicket)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sqlTicket = @"
        SELECT
            t.Id                                 AS IdTicket,
            t.Codigo_Ticket                       AS CodigoTicket,
            tr.Nombre                             AS TipoRequerimiento,
            a.Nombre                              AS Area,
            c.Nombre                              AS Categoria,
            t.Detalle                             AS Detalle,
            p.Nombre                              AS Prioridad,
            t.Afecta_Funcionamiento               AS AfectaFuncionamiento
        FROM Tickets t
        INNER JOIN Tipo_Requerimiento tr ON tr.Id = t.Id_Tipo_Req
        INNER JOIN Area a                ON a.Id  = t.Id_Area
        LEFT  JOIN Categoria c           ON c.Id  = t.Id_Categoria
        LEFT JOIN Prioridad p            ON p.Id = t.Id_Prioridad
        WHERE t.Id = @IdTicket
    ";

            var ticket = await xCon.QueryFirstOrDefaultAsync<TicketDetalleModel>(sqlTicket, new { IdTicket = idTicket });
            if (ticket is null)
            {
                return null;
            }
            var sqlAdjuntos = @"
        SELECT
            Nombre_Archivo AS NombreArchivo,
            Ruta_Archivo   AS RutaArchivo,
            Peso_KB        AS PesoKB
        FROM Ticket_Adjuntos
        WHERE Id_Ticket = @IdTicket
        ORDER BY Fecha_Carga ASC
    ";

            var adjuntos = await xCon.QueryAsync<TicketAdjuntoModel>(sqlAdjuntos, new { IdTicket = idTicket });
            ticket.Adjuntos = adjuntos.ToList();

            var sqlHistorial = @"
SELECT
            eAnt.Nombre                         AS EstadoAnterior,
            eNue.Nombre                         AS EstadoNuevo,
            CONCAT(u.Nombre, ' ', u.Apellido)   AS UsuarioAccion,
            h.Comentario                        AS Comentario,
            h.Fecha_Cambio                       AS FechaCambio
        FROM Ticket_Historial h
        LEFT  JOIN Estado eAnt ON eAnt.Id = h.Id_Estado_Anterior
        INNER JOIN Estado eNue ON eNue.Id = h.Id_Estado_Nuevo
        INNER JOIN Usuarios u  ON u.Id    = h.Id_Usuario_Accion
        WHERE h.Id_Ticket = @IdTicket
        ORDER BY h.Fecha_Cambio ASC";

            var historial = await xCon.QueryAsync<TicketHistorialModel>(sqlHistorial, new { IdTicket = idTicket });
            ticket.Historial = historial.ToList();

            return ticket;
        }

        public async Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimiento()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre, Requiere_Categoria AS RequiereCategoria FROM Tipo_Requerimiento WHERE Activo = 1 ORDER BY Id";
            var result = await xCon.QueryAsync<TipoRequerimientoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerAreasSistemas()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Area WHERE Es_Area_Sistemas = 1 AND Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerCategoriasPorArea(int idArea)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Categoria WHERE Id_Area = @IdArea AND Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql, new { IdArea = idArea });
            return result.ToList();
        }

        public async Task<int> CrearTicket(CrearTicketModel model, int idUsuarioSolicita, bool requiereCategoria)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
        DECLARE @Anio INT = YEAR(GETDATE());
        DECLARE @Siguiente INT = (
            SELECT ISNULL(MAX(CAST(RIGHT(Codigo_Ticket, 6) AS INT)), 0) + 1
            FROM Tickets
            WHERE Codigo_Ticket LIKE 'TCK-' + CAST(@Anio AS VARCHAR) + '-%'
        );
        DECLARE @Codigo VARCHAR(20) = 'TCK-' + CAST(@Anio AS VARCHAR) + '-' + RIGHT('000000' + CAST(@Siguiente AS VARCHAR), 6);
        DECLARE @IdEstadoPendiente INT = (SELECT Id FROM Estado WHERE Nombre = 'Pendiente');
        DECLARE @IdPrioridad INT = CASE
    WHEN @RequiereCategoria = 0 THEN NULL
    WHEN @Afecta = 1 THEN (SELECT Id FROM Prioridad WHERE Nombre = 'Alta')
    ELSE (SELECT Id FROM Prioridad WHERE Nombre = 'Baja')
END;
        DECLARE @IdTicketNuevo INT;

        INSERT INTO Tickets (Codigo_Ticket, Id_Tipo_Req, Id_Categoria, Id_Area, Id_Usuario_Solicita, Detalle, Id_Estado, Afecta_Funcionamiento, Id_Prioridad)
        VALUES (@Codigo, @IdTipoReq, @IdCategoria, @IdArea, @IdUsuarioSolicita, @Detalle, @IdEstadoPendiente, @Afecta, @IdPrioridad);

        SET @IdTicketNuevo = SCOPE_IDENTITY();

        INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
        VALUES (@IdTicketNuevo, NULL, @IdEstadoPendiente, @IdUsuarioSolicita, 'Ticket creado');

        SELECT @IdTicketNuevo;
    ";

            var idTicket = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTipoReq = model.IdTipoRequerimiento,
                IdCategoria = model.IdCategoria,
                IdArea = model.IdArea,
                IdUsuarioSolicita = idUsuarioSolicita,
                Detalle = model.Detalle,
                Afecta = model.AfectaFuncionamiento,
                RequiereCategoria = requiereCategoria
            });

            return idTicket;
        }

        public async Task GuardarAdjunto(int idTicket, string nombreArchivo, string rutaArchivo, int pesoKB, int idUsuarioSube)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
        INSERT INTO Ticket_Adjuntos (Id_Ticket, Nombre_Archivo, Ruta_Archivo, Peso_KB, Id_Usuario_Sube)
        VALUES (@IdTicket, @NombreArchivo, @RutaArchivo, @PesoKB, @IdUsuarioSube);
    ";

            await xCon.ExecuteAsync(sql, new { IdTicket = idTicket, NombreArchivo = nombreArchivo, RutaArchivo = rutaArchivo, PesoKB = pesoKB, IdUsuarioSube = idUsuarioSube });
        }

        public async Task<bool> TipoRequiereCategoria(int idTipoRequerimiento)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Requiere_Categoria FROM Tipo_Requerimiento WHERE Id = @Id";
            return await xCon.ExecuteScalarAsync<bool>(sql, new { Id = idTipoRequerimiento });
        }

        public async Task<bool> TomarTicket(int idTicket, int idUsuarioAsignado)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
                DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'En revisión');

                UPDATE Tickets
                SET Id_Estado = @IdEstadoNuevo,
                    Id_Usuario_Asignado = @IdUsuarioAsignado,
                    Fecha_Asignacion = GETDATE()
                WHERE Id = @IdTicket
                    AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Pendiente')
                    AND Id_Prioridad IS NOT NULL;

                IF @@ROWCOUNT > 0
                BEGIN
                    INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
                    VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAsignado, 'Ticket tomado por el usuario de Soporte');
                END

                SELECT @@ROWCOUNT;
        ";
            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAsignado = idUsuarioAsignado });
            return filasAfectadas > 0;
        }

        public async Task<bool> AnularTicket(int idTicket, int idUsuarioAccion, string motivo)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Anulado');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo,
            Motivo_Anulacion = @Motivo,
            Fecha_Cierre = GETDATE()
        WHERE Id = @IdTicket
  AND Id_Estado IN (
        SELECT Id FROM Estado WHERE Nombre IN ('Pendiente', 'En revisión', 'En atención', 'En pausa', 'En validación')
      );

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, @Motivo);
        END

        SELECT @@ROWCOUNT;
    ";
            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion, Motivo = motivo });
            return filasAfectadas > 0;
        }

        public async Task<List<CatalogoModel>> ObtenerPrioridades()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Prioridad WHERE Activo = 1 ORDER BY Orden";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<bool> AsignarPrioridad(int idTicket, int idPrioridad)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                UPDATE Tickets
                SET Id_Prioridad = @IdPrioridad
                WHERE Id = @IdTicket
                AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Pendiente')
                AND ISNULL(Afecta_Funcionamiento, 0) <> 1
                --AND Id_Tipo_Req IN (SELECT Id FROM Tipo_Requerimiento WHERE Requiere_Categoria = 1);
                ";

            var filasAfectadas = await xCon.ExecuteAsync(sql, new { IdTicket = idTicket, IdPrioridad = idPrioridad });

            return filasAfectadas > 0;
        }

        public async Task<(bool Exito, string? Mensaje)> AsignarOrdenAtencion(int idTicket, int orden)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sqlInfo = @"
                SELECT t.Id_Usuario_Asignado AS IdUsuarioAsignado, t.Id_Prioridad AS IdPrioridad, e.Nombre AS Estado
                FROM Tickets t
                INNER JOIN Estado e ON e.Id = t.Id_Estado
                WHERE t.Id = @IdTicket
                ";

            var info = await xCon.QueryFirstOrDefaultAsync<(int? IdUsuarioAsignado, int? IdPrioridad, string Estado)>(sqlInfo, new { IdTicket = idTicket });

            var estadosNoPermitidos = new[] { "En Atención", "Desarrollo", "Pruebas", "Pase a producción", "Cierre", "Cerrado", "Anulado" };

            if (estadosNoPermitidos.Contains(info.Estado))
            {
                return (false, "No se puede asignar orden de atención en el estado actual del ticket.");
            }

            var sqlDuplicado = @"
                SELECT COUNT(*)
                FROM Tickets t
                INNER JOIN Estado e ON e.Id = t.Id_Estado
                WHERE t.Id <> @IdTicket
                    AND t.Id_Usuario_Asignado = @IdUsuarioAsignado
                    AND t.Id_Prioridad = @IdPrioridad
                    AND t.Orden_Atencion = @Orden
                    AND e.Nombre NOT IN ('Cerrado', 'Anulado')
            ";

            var duplicados = await xCon.ExecuteScalarAsync<int>(sqlDuplicado, new
            {
                IdTicket = idTicket,
                IdUsuarioAsignado = info.IdUsuarioAsignado,
                IdPrioridad = info.IdPrioridad,
                Orden = orden
            });

            if (duplicados > 0)
            {
                return (false, "Ya existe otro ticket con ese mismo orden, para el mismo usuario y prioridad.");
            }

            var sqlUpdate = "UPDATE Tickets SET Orden_Atencion = @Orden WHERE Id = @IdTicket";
            await xCon.ExecuteAsync(sqlUpdate, new { IdTicket = idTicket, Orden = orden });

            return (true, null);
        }

        public async Task<bool> AtenderTicket(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'En atención');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo,
            Fecha_Atencion = GETDATE()
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'En revisión');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Ticket en atención');
        END

        SELECT @@ROWCOUNT;";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion});

            return filasAfectadas > 0;
        }

        public async Task<List<CatalogoModel>> ObtenerMisTicketsPropios(int idUsuario, int idTicketActual)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"SELECT
            Id AS Id,
            CONCAT(Codigo_Ticket, ' - ', LEFT(Detalle, 40)) AS Nombre
        FROM Tickets
        WHERE Id_Usuario_Asignado = @IdUsuario
          --AND Id_Prioridad IS NOT NULL
          AND Id <> @IdTicketActual
          AND Id_Estado NOT IN (
                SELECT Id FROM Estado WHERE Nombre IN ('Cerrado', 'Anulado', 'Cierre')
              )
        ORDER BY Codigo_Ticket;";

            var result = await xCon.QueryAsync<CatalogoModel>(sql, new { IdUsuario = idUsuario, idTicketActual = idTicketActual });
            return result.ToList();
        }

        public async Task<bool> PausarTicket(int idTicket, int idUsuarioAccion, string tipoMotivo, int? idTicketRelacionado)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'En pausa');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'En atención');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Pausas (Id_Ticket, Tipo_Motivo, Id_Ticket_Relacionado, Id_Usuario_Accion)
            VALUES (@IdTicket, @TipoMotivo, @IdTicketRelacionado, @IdUsuarioAccion);

            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Ticket pausado');
        END

        SELECT @@ROWCOUNT;";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                IdUsuarioAccion = idUsuarioAccion,
                TipoMotivo = tipoMotivo,
                IdTicketRelacionado = idTicketRelacionado
            });

            return filasAfectadas > 0;
        }

        public async Task<bool> ReanudarTicket(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'En atención');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'En pausa');

        IF @@ROWCOUNT > 0
        BEGIN
            UPDATE Ticket_Pausas
            SET Fecha_Fin = GETDATE()
            WHERE Id_Ticket = @IdTicket AND Fecha_Fin IS NULL;

            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Ticket reanudado');
        END

        SELECT @@ROWCOUNT;";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });

            return filasAfectadas > 0;
        }

        public async Task<bool> ValidarTicket(int idTicket, int idUsuarioAccion, string solucion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'En validación');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo,
            Solucion = @Solucion
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'En atención');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Solución registrada, pendiente de validación del solicitante');
        END

        SELECT @@ROWCOUNT;";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                IdUsuarioAccion = idUsuarioAccion,
                Solucion = solucion
            });

            return filasAfectadas > 0;
        }

        public async Task<bool> ConfirmarSolucion(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Cerrado');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo,
            Fecha_Cierre = GETDATE()
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'En validación');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Solución confirmada por el solicitante');
        END

        SELECT @@ROWCOUNT;";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });

            return filasAfectadas > 0;
        }

        public async Task<bool> DevolverTicket(int idTicket, int idUsuarioAccion, string motivo)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'En atención');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'En validación');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, @Motivo);
        END

        SELECT @@ROWCOUNT;";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion, Motivo = motivo });

            return filasAfectadas > 0;
        }


        //IMPLEMNTACION Y MEJORA
        public async Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
                DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Levantamiento');

                UPDATE Tickets
                SET Id_Estado = @IdEstadoNuevo,
                    Id_Usuario_Asignado = @IdUsuarioAsignado,
                    Fecha_Asignacion = GETDATE()
                WHERE Id = @IdTicket
                    AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Pendiente')
                    AND Id_Prioridad IS NOT NULL;

                IF @@ROWCOUNT > 0
                BEGIN
                    INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
                    VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAsignado, 'Ticket tomado para levantamiento');
                END

                SELECT @@ROWCOUNT;";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAsignado = idUsuarioAsignado });
            return filas > 0;
        }

        public async Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Desarrollo');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Levantamiento');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Inicia desarrollo');
        END

        SELECT @@ROWCOUNT;";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });
            return filas > 0;
        }

        public async Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Pruebas');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Desarrollo');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Enviado a pruebas del solicitante');
        END

        SELECT @@ROWCOUNT;";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });
            return filas > 0;
        }

        public async Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Pase a producción');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Pruebas');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Solicitante confirma pruebas correctas');
        END

        SELECT @@ROWCOUNT;";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });
            return filas > 0;
        }

        public async Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
        DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = 'Cierre');

        UPDATE Tickets
        SET Id_Estado = @IdEstadoNuevo,
            Fecha_Cierre = GETDATE()
        WHERE Id = @IdTicket
          AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Pase a producción');

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, 'Ticket cerrado');
        END

        SELECT @@ROWCOUNT;";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });
            return filas > 0;
        }

        //REASIGNAR USUARIO A UN TICKET
        public async Task<List<CatalogoModel>> ObtenerUsuariosSoportePorArea(int idArea)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
        SELECT
            u.Id AS Id,
            CONCAT(u.Nombre, ' ', u.Apellido) AS Nombre
        FROM Usuarios u
        INNER JOIN Rol r ON r.Id = u.IdRol
        WHERE r.Nombre = 'Soporte'
          AND u.Id_Area = @IdArea
          AND u.Activo = 1
        ORDER BY u.Nombre;
    ";

            var result = await xCon.QueryAsync<CatalogoModel>(sql, new { IdArea = idArea });
            return result.ToList();
        }

        public async Task<bool> ReasignarTicket(int idTicket, int idNuevoUsuario, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
        DECLARE @NombreAnterior VARCHAR(200) = (
            SELECT CONCAT(u.Nombre, ' ', u.Apellido)
            FROM Tickets t
            LEFT JOIN Usuarios u ON u.Id = t.Id_Usuario_Asignado
            WHERE t.Id = @IdTicket
        );
        DECLARE @NombreNuevo VARCHAR(200) = (
            SELECT CONCAT(Nombre, ' ', Apellido) FROM Usuarios WHERE Id = @IdNuevoUsuario
        );
        DECLARE @IdEstadoActual INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);

        UPDATE Tickets
        SET Id_Usuario_Asignado = @IdNuevoUsuario,
            Fecha_Asignacion = GETDATE()
        WHERE Id = @IdTicket
          AND Id_Usuario_Asignado IS NOT NULL
          AND Id_Estado NOT IN (
                SELECT Id FROM Estado WHERE Nombre IN ('Cerrado', 'Anulado', 'Cierre')
              );

        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
            VALUES (@IdTicket, @IdEstadoActual, @IdEstadoActual, @IdUsuarioAccion,
                    CONCAT('Reasignado de ', ISNULL(@NombreAnterior, 'sin asignar'), ' a ', @NombreNuevo));
        END

        SELECT @@ROWCOUNT;
    ";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                IdNuevoUsuario = idNuevoUsuario,
                IdUsuarioAccion = idUsuarioAccion
            });

            return filas > 0;
        }
    }
}
