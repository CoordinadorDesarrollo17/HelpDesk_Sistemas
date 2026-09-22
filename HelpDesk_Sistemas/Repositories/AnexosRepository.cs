using Dapper;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;

namespace HelpDesk_Sistemas.Repositories
{
    public class AnexosRepository : IAnexosRepository
    {
        private readonly DapperContext dapperContext;

        public AnexosRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        public async Task<List<GuiaCategoriaModel>> ObtenerCategorias()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Guia_Categoria WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<GuiaCategoriaModel>(sql);
            return result.ToList();
        }

        public async Task<List<GuiaSubcategoriaModel>> ObtenerSubcategorias(int idCategoria)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre, Id_Guia_Categoria AS IdGuiaCategoria FROM Guia_Subcategoria WHERE Id_Guia_Categoria = @IdCategoria AND Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<GuiaSubcategoriaModel>(sql, new { IdCategoria = idCategoria });
            return result.ToList();
        }

        public async Task<List<GuiaModel>> ObtenerGuias(int? idCategoria, int? idSubcategoria, string? buscar)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var condiciones = new List<string> { "g.Activo = 1" };

            // Regla de negocio clave: si hay texto en el buscador, se ignoran los
            // filtros de categoría/subcategoría — es una SUGERENCIA, no una
            // restricción (ver la explicación que dio el usuario).
            if (!string.IsNullOrWhiteSpace(buscar))
            {
                condiciones.Add("(g.Titulo LIKE @Buscar OR g.Descripcion LIKE @Buscar)");
            }
            else
            {
                if (idCategoria.HasValue) condiciones.Add("g.Id_Guia_Categoria = @IdCategoria");
                if (idSubcategoria.HasValue) condiciones.Add("g.Id_Subcategoria = @IdSubcategoria");
            }

            var where = string.Join(" AND ", condiciones);

            var sql = $@"
                SELECT
                    g.Id, g.Titulo, g.Descripcion, g.Nombre_Archivo AS NombreArchivo, g.Ruta_Archivo AS RutaArchivo, g.Peso_KB AS PesoKB,
                    c.Nombre AS Categoria, s.Nombre AS Subcategoria,
                    g.Id_Guia_Categoria AS IdGuiaCategoria, g.Id_Subcategoria AS IdSubcategoria,
                    CONCAT(u.Nombre, ' ', u.Apellido) AS SubidoPor,
                    g.Fecha_Creacion AS FechaCreacion
                FROM Guias_Anexos g
                LEFT JOIN Guia_Categoria c ON c.Id = g.Id_Guia_Categoria
                LEFT JOIN Guia_Subcategoria s ON s.Id = g.Id_Subcategoria
                LEFT JOIN Usuarios u ON u.Id = g.Id_Usuario_Sube
                WHERE {where}
                ORDER BY g.Fecha_Creacion DESC
            ";

            var result = await xCon.QueryAsync<GuiaModel>(sql, new
            {
                IdCategoria = idCategoria,
                IdSubcategoria = idSubcategoria,
                Buscar = "%" + buscar + "%"
            });
            return result.ToList();
        }

        public async Task<GuiaModel?> ObtenerGuiaPorId(int id)
        {
            var lista = await ObtenerGuias(null, null, null);
            return lista.FirstOrDefault(g => g.Id == id)
                ?? (await ConsultaDirecta(id));
        }

        private async Task<GuiaModel?> ConsultaDirecta(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                SELECT g.Id, g.Titulo, g.Descripcion, g.Nombre_Archivo AS NombreArchivo, g.Ruta_Archivo AS RutaArchivo,
                       g.Id_Guia_Categoria AS IdGuiaCategoria, g.Id_Subcategoria AS IdSubcategoria
                FROM Guias_Anexos g WHERE g.Id = @Id";
            return await xCon.QueryFirstOrDefaultAsync<GuiaModel>(sql, new { Id = id });
        }

        public async Task<int> CrearGuia(CrearGuiaModel model, string nombreArchivo, string rutaArchivo, int pesoKB, int idUsuarioSube)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                INSERT INTO Guias_Anexos (Titulo, Descripcion, Ruta_Archivo, Nombre_Archivo, Peso_KB, Id_Guia_Categoria, Id_Subcategoria, Id_Usuario_Sube, Activo, Fecha_Creacion)
                OUTPUT INSERTED.Id
                VALUES (@Titulo, @Descripcion, @RutaArchivo, @NombreArchivo, @PesoKB, @IdGuiaCategoria, @IdSubcategoria, @IdUsuarioSube, 1, GETDATE());
            ";
            return await xCon.ExecuteScalarAsync<int>(sql, new
            {
                model.Titulo,
                model.Descripcion,
                RutaArchivo = rutaArchivo,
                NombreArchivo = nombreArchivo,
                PesoKB = pesoKB,
                model.IdGuiaCategoria,
                model.IdSubcategoria,
                IdUsuarioSube = idUsuarioSube
            });
        }

        public async Task<bool> EditarGuia(int id, CrearGuiaModel model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                UPDATE Guias_Anexos
                SET Titulo = @Titulo, Descripcion = @Descripcion,
                    Id_Guia_Categoria = @IdGuiaCategoria, Id_Subcategoria = @IdSubcategoria
                WHERE Id = @Id
            ";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, model.Titulo, model.Descripcion, model.IdGuiaCategoria, model.IdSubcategoria });
            return filas > 0;
        }

        public async Task<bool> EliminarGuia(int id)
        {
            // Baja lógica (igual que Usuarios): nunca se borra la fila, porque
            // Ticket_Guias podría estar apuntando a ella desde tickets ya cerrados.
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Guias_Anexos SET Activo = 0 WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id });
            return filas > 0;
        }

        public async Task VincularGuiaATicket(int idTicket, int idGuia, int idUsuarioAccion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                INSERT INTO Ticket_Guias (Id_Ticket, Id_Guia, Id_Usuario_Accion)
                VALUES (@IdTicket, @IdGuia, @IdUsuarioAccion);
            ";
            await xCon.ExecuteAsync(sql, new { IdTicket = idTicket, IdGuia = idGuia, IdUsuarioAccion = idUsuarioAccion });
        }

        public async Task<List<GuiaModel>> ObtenerGuiasVinculadas(int idTicket)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = @"
                SELECT g.Id, g.Titulo, g.Nombre_Archivo AS NombreArchivo
                FROM Ticket_Guias tg
                INNER JOIN Guias_Anexos g ON g.Id = tg.Id_Guia
                WHERE tg.Id_Ticket = @IdTicket
                ORDER BY tg.Fecha_Vinculo ASC
            ";
            var result = await xCon.QueryAsync<GuiaModel>(sql, new { IdTicket = idTicket });
            return result.ToList();
        }
    }
}