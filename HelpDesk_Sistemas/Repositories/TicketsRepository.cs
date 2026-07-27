using Dapper;
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

        // ============================================================
        // LISTADO Y FILTROS
        // ============================================================

        /// <summary>
        /// Trae los tickets que cumplen los filtros dados. Si se filtra por un Estado
        /// distinto de "Pendiente", solo devuelve los asignados al usuario actual
        /// (los Pendiente son visibles para todos, ya que nadie los tiene asignado aún).
        /// </summary>
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
                    soc.Nombre                            AS Sociedad,
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
                LEFT JOIN Sociedad soc           ON soc.Id = t.Id_Sociedad
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

        /// <summary>Versión paginada de ObtenerTickets, para la tabla del listado.</summary>
        public async Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual)
        {
            var result = await ObtenerTickets(model, idUsuarioActual);
            return result.ToPagedList(model.Paginacion.Page, model.Paginacion.PageSize);
        }

        /// <summary>Versión sin paginar de ObtenerTickets, para la exportación a Excel.</summary>
        public async Task<List<TicketsModel>> ListadoTicketsExcel(FiltrosTicketsModel model, int idUsuarioActual)
        {
            var result = await ObtenerTickets(model, idUsuarioActual);
            return result.ToList();
        }

        // ============================================================
        // CATÁLOGOS (combos de filtros y formularios)
        // ============================================================

        public async Task<List<CatalogoModel>> ObtenerEstados()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Estado WHERE Activo = 1 ORDER BY Orden";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
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

        public async Task<List<CatalogoModel>> ObtenerPrioridades()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Prioridad WHERE Activo = 1 ORDER BY Orden";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        /// <summary>True si el tipo de requerimiento requiere Categoría (y, por extensión,
        /// también la pregunta de "Afecta funcionamiento"). False para Implementación/Mejora.</summary>
        public async Task<bool> TipoRequiereCategoria(int idTipoRequerimiento)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Requiere_Categoria FROM Tipo_Requerimiento WHERE Id = @Id";
            return await xCon.ExecuteScalarAsync<bool>(sql, new { Id = idTipoRequerimiento });
        }

        /// <summary>Sociedades a las que pertenece un usuario — usado para llenar el
        /// combo de "Sociedad" al crear un ticket.</summary>
        public async Task<List<CatalogoModel>> ObtenerSociedadesPorUsuario(int idUsuario)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
        SELECT s.Id AS Id, s.Nombre AS Nombre
        FROM Sociedad s
        INNER JOIN Usuario_Sociedad us ON us.Id_Sociedad = s.Id
        WHERE us.Id_Usuario = @IdUsuario
          AND s.Activo = 1
        ORDER BY s.Nombre;
    ";

            var result = await xCon.QueryAsync<CatalogoModel>(sql, new { IdUsuario = idUsuario });
            return result.ToList();
        }

        // ============================================================
        // DETALLE DE TICKET
        // ============================================================

        /// <summary>
        /// Trae los datos del formulario original de un ticket, más sus archivos
        /// adjuntos y la bitácora completa de cambios de estado.
        /// </summary>
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
                    t.Afecta_Funcionamiento               AS AfectaFuncionamiento,
                    soc.Nombre                            AS Sociedad
                FROM Tickets t
                INNER JOIN Tipo_Requerimiento tr ON tr.Id = t.Id_Tipo_Req
                INNER JOIN Area a                ON a.Id  = t.Id_Area
                LEFT  JOIN Categoria c           ON c.Id  = t.Id_Categoria
                LEFT  JOIN Prioridad p           ON p.Id  = t.Id_Prioridad
                LEFT JOIN Sociedad soc           ON soc.Id = t.Id_Sociedad
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
                    h.Fecha_Cambio                      AS FechaCambio
                FROM Ticket_Historial h
                LEFT  JOIN Estado eAnt ON eAnt.Id = h.Id_Estado_Anterior
                INNER JOIN Estado eNue ON eNue.Id = h.Id_Estado_Nuevo
                INNER JOIN Usuarios u  ON u.Id    = h.Id_Usuario_Accion
                WHERE h.Id_Ticket = @IdTicket
                ORDER BY h.Fecha_Cambio ASC
            ";

            var historial = await xCon.QueryAsync<TicketHistorialModel>(sqlHistorial, new { IdTicket = idTicket });
            ticket.Historial = historial.ToList();

            return ticket;
        }

        // ============================================================
        // CREACIÓN DE TICKET
        // ============================================================

        /// <summary>
        /// Crea el ticket con código autogenerado (TCK-AAAA-NNNNNN) y, si el tipo
        /// requiere categoría, fija la prioridad automáticamente según la respuesta
        /// de "Afecta funcionamiento" (Sí → Alta, No → Baja). Para Implementación/Mejora
        /// la prioridad queda en NULL hasta que Soporte la asigne manualmente.
        /// </summary>
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
                DECLARE @IdPrioridad INT = (
                    CASE
                        WHEN @RequiereCategoria = 0 THEN NULL
                        WHEN @Afecta = 1 THEN (SELECT Id FROM Prioridad WHERE Nombre = 'Alta')
                        ELSE (SELECT Id FROM Prioridad WHERE Nombre = 'Baja')
                    END
                );
                DECLARE @IdTicketNuevo INT;

                INSERT INTO Tickets (Codigo_Ticket, Id_Tipo_Req, Id_Categoria, Id_Area, Id_Usuario_Solicita, Detalle, Id_Estado, Afecta_Funcionamiento, Id_Prioridad, Id_Sociedad)
                VALUES (@Codigo, @IdTipoReq, @IdCategoria, @IdArea, @IdUsuarioSolicita, @Detalle, @IdEstadoPendiente, @Afecta, @IdPrioridad, @IdSociedad);

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
                RequiereCategoria = requiereCategoria,
                IdSociedad = model.IdSociedad
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

        // ============================================================
        // HELPERS PRIVADOS DE TRANSICIÓN DE ESTADO
        // Reutilizados por las transiciones "simples" (un solo estado
        // origen, un solo estado destino, sin lógica extra). Las
        // transiciones con lógica propia (pausas, validación con texto,
        // anulación con múltiples orígenes) se quedan con su SQL propio.
        // ============================================================

        /// <summary>
        /// Cambia el ticket de estadoOrigen a estadoDestino y registra el cambio
        /// en la bitácora. Si se indica campoFechaExtra (ej. "Fecha_Cierre"), esa
        /// columna también se actualiza a la fecha/hora actual en el mismo UPDATE.
        /// </summary>
        private async Task<bool> CambiarEstado(int idTicket, string estadoOrigen, string estadoDestino, int idUsuarioAccion, string comentario, string? campoFechaExtra = null)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var setFechaExtra = campoFechaExtra != null ? $", {campoFechaExtra} = GETDATE()" : "";

            var sql = $@"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
                DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = @EstadoDestino);

                UPDATE Tickets
                SET Id_Estado = @IdEstadoNuevo{setFechaExtra}
                WHERE Id = @IdTicket
                  AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = @EstadoOrigen);

                IF @@ROWCOUNT > 0
                BEGIN
                    INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
                    VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAccion, @Comentario);
                END

                SELECT @@ROWCOUNT;
            ";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                EstadoOrigen = estadoOrigen,
                EstadoDestino = estadoDestino,
                IdUsuarioAccion = idUsuarioAccion,
                Comentario = comentario
            });

            return filas > 0;
        }

        /// <summary>
        /// Variante de CambiarEstado para cuando además hay que asignar un usuario
        /// responsable (Id_Usuario_Asignado, Fecha_Asignacion). Exige que el ticket
        /// ya tenga prioridad asignada. Usado por TomarTicket y TomarLevantamiento.
        /// </summary>
        private async Task<bool> TomarGenerico(int idTicket, string estadoOrigen, string estadoDestino, int idUsuarioAsignado, string comentario)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
                DECLARE @IdEstadoNuevo INT = (SELECT Id FROM Estado WHERE Nombre = @EstadoDestino);

                UPDATE Tickets
                SET Id_Estado = @IdEstadoNuevo,
                    Id_Usuario_Asignado = @IdUsuarioAsignado,
                    Fecha_Asignacion = GETDATE()
                WHERE Id = @IdTicket
                  AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = @EstadoOrigen)
                  AND Id_Prioridad IS NOT NULL;

                IF @@ROWCOUNT > 0
                BEGIN
                    INSERT INTO Ticket_Historial (Id_Ticket, Id_Estado_Anterior, Id_Estado_Nuevo, Id_Usuario_Accion, Comentario)
                    VALUES (@IdTicket, @IdEstadoAnterior, @IdEstadoNuevo, @IdUsuarioAsignado, @Comentario);
                END

                SELECT @@ROWCOUNT;
            ";

            var filas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                EstadoOrigen = estadoOrigen,
                EstadoDestino = estadoDestino,
                IdUsuarioAsignado = idUsuarioAsignado,
                Comentario = comentario
            });

            return filas > 0;
        }

        // ============================================================
        // FLUJO CONSULTA / SOPORTE
        // ============================================================

        /// <summary>Pendiente → En revisión. Asigna al usuario que toma el ticket.</summary>
        public async Task<bool> TomarTicket(int idTicket, int idUsuarioAsignado)
            => await TomarGenerico(idTicket, "Pendiente", "En revisión", idUsuarioAsignado, "Ticket tomado por el usuario de Soporte");

        /// <summary>En revisión → En atención.</summary>
        public async Task<bool> AtenderTicket(int idTicket, int idUsuarioAccion)
            => await CambiarEstado(idTicket, "En revisión", "En atención", idUsuarioAccion, "Ticket en atención", "Fecha_Atencion");

        /// <summary>
        /// En atención → En pausa. Registra el motivo (Reunión o Atención de otro
        /// ticket propio) en Ticket_Pausas, con Fecha_Fin en NULL mientras dure la pausa.
        /// </summary>
        public async Task<bool> PausarTicket(int idTicket, int idUsuarioAccion, string tipoMotivo, int? idTicketRelacionado)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
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

                SELECT @@ROWCOUNT;
            ";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                IdUsuarioAccion = idUsuarioAccion,
                TipoMotivo = tipoMotivo,
                IdTicketRelacionado = idTicketRelacionado
            });

            return filasAfectadas > 0;
        }

        /// <summary>En pausa → En atención. Cierra la pausa abierta (Fecha_Fin = ahora).</summary>
        public async Task<bool> ReanudarTicket(int idTicket, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
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

                SELECT @@ROWCOUNT;
            ";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new { IdTicket = idTicket, IdUsuarioAccion = idUsuarioAccion });
            return filasAfectadas > 0;
        }

        /// <summary>En atención → En validación. Registra la solución redactada por Soporte.</summary>
        public async Task<bool> ValidarTicket(int idTicket, int idUsuarioAccion, string solucion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                DECLARE @IdEstadoAnterior INT = (SELECT Id_Estado FROM Tickets WHERE Id = @IdTicket);
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

                SELECT @@ROWCOUNT;
            ";

            var filasAfectadas = await xCon.ExecuteScalarAsync<int>(sql, new
            {
                IdTicket = idTicket,
                IdUsuarioAccion = idUsuarioAccion,
                Solucion = solucion
            });

            return filasAfectadas > 0;
        }

        /// <summary>En validación → Cerrado. El solicitante da conformidad a la solución.</summary>
        public async Task<bool> ConfirmarSolucion(int idTicket, int idUsuarioAccion)
            => await CambiarEstado(idTicket, "En validación", "Cerrado", idUsuarioAccion, "Solución confirmada por el solicitante", "Fecha_Cierre");

        /// <summary>En validación → En atención. El solicitante rechaza la solución con un motivo.</summary>
        public async Task<bool> DevolverTicket(int idTicket, int idUsuarioAccion, string motivo)
            => await CambiarEstado(idTicket, "En validación", "En atención", idUsuarioAccion, motivo);

        /// <summary>
        /// Anula el ticket desde cualquier estado activo del flujo de Consulta/Soporte
        /// (no aplica a Implementación/Mejora, que usa sus propios nombres de estado).
        /// </summary>
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

        // ============================================================
        // PRIORIDAD Y ORDEN DE ATENCIÓN (aplica a ambos flujos)
        // ============================================================

        /// <summary>
        /// Asigna prioridad a un ticket Pendiente. Bloqueado si el ticket ya tiene
        /// "Alta" fijada automáticamente (Afecta_Funcionamiento = Sí), ya que esa
        /// prioridad no se puede cambiar manualmente.
        /// </summary>
        public async Task<bool> AsignarPrioridad(int idTicket, int idPrioridad)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                UPDATE Tickets
                SET Id_Prioridad = @IdPrioridad
                WHERE Id = @IdTicket
                  AND Id_Estado = (SELECT Id FROM Estado WHERE Nombre = 'Pendiente')
                  AND ISNULL(Afecta_Funcionamiento, 0) <> 1;
            ";

            var filasAfectadas = await xCon.ExecuteAsync(sql, new { IdTicket = idTicket, IdPrioridad = idPrioridad });
            return filasAfectadas > 0;
        }

        /// <summary>
        /// Asigna el orden de atención entre tickets del mismo usuario asignado y
        /// misma prioridad. Rechaza el cambio si el ticket ya está en un estado
        /// "en curso" (equivalente a En atención en cada flujo), o si el número de
        /// orden ya está usado por otro ticket del mismo grupo.
        /// </summary>
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

            // Estados donde el ticket ya está "en curso" y no debe reordenarse:
            // En atención (Consulta/Soporte) y Desarrollo en adelante (Implementación/Mejora).
            var estadosNoPermitidos = new[] { "En atención", "Desarrollo", "Pruebas", "Pase a producción", "Cierre", "Cerrado", "Anulado" };

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

        /// <summary>
        /// Tickets ya asignados al mismo usuario (con prioridad definida, sin contar
        /// el ticket actual, sin estar Cerrado/Anulado/Cierre). Es la lista que se
        /// ofrece al pausar un ticket por "atención de otro ticket propio".
        /// </summary>
        public async Task<List<CatalogoModel>> ObtenerMisTicketsPropios(int idUsuario, int idTicketActual)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                SELECT
                    Id AS Id,
                    CONCAT(Codigo_Ticket, ' - ', LEFT(Detalle, 40)) AS Nombre
                FROM Tickets
                WHERE Id_Usuario_Asignado = @IdUsuario
                  AND Id_Prioridad IS NOT NULL
                  AND Id <> @IdTicketActual
                  AND Id_Estado NOT IN (
                        SELECT Id FROM Estado WHERE Nombre IN ('Cerrado', 'Anulado', 'Cierre')
                      )
                ORDER BY Codigo_Ticket;
            ";

            var result = await xCon.QueryAsync<CatalogoModel>(sql, new { IdUsuario = idUsuario, IdTicketActual = idTicketActual });
            return result.ToList();
        }

        // ============================================================
        // FLUJO IMPLEMENTACIÓN / MEJORA
        // ============================================================

        /// <summary>Pendiente → Levantamiento. Asigna al usuario que toma el ticket.</summary>
        public async Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado)
            => await TomarGenerico(idTicket, "Pendiente", "Levantamiento", idUsuarioAsignado, "Ticket tomado para levantamiento");

        /// <summary>Levantamiento → Desarrollo.</summary>
        public async Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion)
            => await CambiarEstado(idTicket, "Levantamiento", "Desarrollo", idUsuarioAccion, "Inicia desarrollo");

        /// <summary>Desarrollo → Pruebas.</summary>
        public async Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion)
            => await CambiarEstado(idTicket, "Desarrollo", "Pruebas", idUsuarioAccion, "Enviado a pruebas del solicitante");

        /// <summary>Pruebas → Pase a producción. El solicitante confirma que las pruebas salieron bien.</summary>
        public async Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion)
            => await CambiarEstado(idTicket, "Pruebas", "Pase a producción", idUsuarioAccion, "Solicitante confirma pruebas correctas");

        /// <summary>Pase a producción → Cierre.</summary>
        public async Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion)
            => await CambiarEstado(idTicket, "Pase a producción", "Cierre", idUsuarioAccion, "Ticket cerrado", "Fecha_Cierre");

        // ============================================================
        // REASIGNACIÓN (aplica a ambos flujos)
        // ============================================================

        /// <summary>Agentes con rol Soporte, activos, del área indicada — usado para elegir a quién reasignar.</summary>
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

        /// <summary>
        /// Cambia el usuario asignado de un ticket ya tomado (sin cambiar su estado).
        /// Registra en la bitácora el nombre del anterior y el nuevo responsable.
        /// </summary>
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

        /// <summary>Protección de servidor: confirma que la sociedad elegida realmente
        /// pertenece al usuario, sin confiar únicamente en lo que envía el formulario.</summary>
        public async Task<bool> UsuarioPerteneceSociedad(int idUsuario, int idSociedad)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
        SELECT COUNT(*)
        FROM Usuario_Sociedad
        WHERE Id_Usuario = @IdUsuario AND Id_Sociedad = @IdSociedad;
    ";

            var count = await xCon.ExecuteScalarAsync<int>(sql, new { IdUsuario = idUsuario, IdSociedad = idSociedad });
            return count > 0;
        }
    }
}