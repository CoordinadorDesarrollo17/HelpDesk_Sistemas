using Dapper;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;

namespace HelpDesk_Sistemas.Repositories
{
    public class UsuariosRepository : IUsuariosRepository
    {
        private readonly DapperContext dapperContext;

        public UsuariosRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        public async Task<UsuarioAutenticacionModel?> ObtenerParaLogin(string usuario)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                SELECT
                    u.Id,
                    u.Usuario,
                    u.Password,
                    CONCAT(u.Nombre, ' ', u.Apellido) AS NombreCompleto,
                    r.Nombre AS Rol,
                    u.Activo
                FROM Usuarios u
                INNER JOIN Rol r ON r.Id = u.IdRol
                WHERE u.Usuario = @Usuario
            ";

            return await xCon.QueryFirstOrDefaultAsync<UsuarioAutenticacionModel>(sql, new { Usuario = usuario });
        }

        public async Task<List<UsuarioModel>> ObtenerUsuarios()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            // Las sociedades se concatenan en un subquery: si se hiciera con JOIN directo,
            // un usuario con N sociedades saldría repetido N veces en el listado.
            var sql = @"
                SELECT
                    u.Id, u.Nombre, u.Apellido, u.Usuario, r.Nombre AS Rol, a.Nombre AS Area, u.Correo, u.Activo,
                    (
                        SELECT STRING_AGG(s.Nombre, ', ') WITHIN GROUP (ORDER BY s.Nombre)
                        FROM Usuario_Sociedad us
                        INNER JOIN Sociedad s ON s.Id = us.Id_Sociedad
                        WHERE us.Id_Usuario = u.Id
                    ) AS Sociedades
                FROM Usuarios u
                INNER JOIN Rol r ON r.Id = u.IdRol
                INNER JOIN Area a ON a.Id = u.Id_Area
                ORDER BY u.Nombre, u.Apellido
            ";

            var result = await xCon.QueryAsync<UsuarioModel>(sql);
            return result.ToList();
        }

        public async Task<int> ObtenerSiguienteNumeroSecuencial(int idRol)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT ISNULL(MAX(Numero_Secuencial), 0) + 1 FROM Usuarios WHERE IdRol = @IdRol";
            return await xCon.ExecuteScalarAsync<int>(sql, new { IdRol = idRol });
        }

        public async Task<int> CrearUsuario(CrearUsuarioModel model, string usuario, string passwordHash, int numeroSecuencial, string usuarioCreacion)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            await xCon.OpenAsync();
            using var transaccion = xCon.BeginTransaction();

            try
            {
                var sqlUsuario = @"
            INSERT INTO Usuarios
                (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario,
                 Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
            VALUES
                (@IdRol, @IdArea, @EsCoordinador, @Nombre, @Apellido, @Correo, @NroContacto, @IdSupUsuario,
                 @Usuario, @PasswordHash, @NumeroSecuencial, 1, @UsuarioCreacion);
            SELECT SCOPE_IDENTITY();
        ";

                var idUsuario = await xCon.ExecuteScalarAsync<int>(sqlUsuario, new
                {
                    model.IdRol,
                    model.IdArea,
                    model.EsCoordinador,
                    model.Nombre,
                    model.Apellido,
                    model.Correo,
                    model.NroContacto,
                    model.IdSupUsuario,
                    Usuario = usuario,
                    PasswordHash = passwordHash,
                    NumeroSecuencial = numeroSecuencial,
                    UsuarioCreacion = usuarioCreacion
                }, transaccion);

                var sqlSociedad = @"
            INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad)
            VALUES (@IdUsuario, @IdSociedad)
        ";

                // Dapper ejecuta el INSERT una vez por cada elemento de la lista.
                await xCon.ExecuteAsync(
                    sqlSociedad,
                    model.IdSociedades.Select(idSociedad => new { IdUsuario = idUsuario, IdSociedad = idSociedad }),
                    transaccion);

                transaccion.Commit();
                return idUsuario;
            }
            catch
            {
                transaccion.Rollback();
                throw;
            }
        }

        public async Task<bool> CambiarActivo(int id, bool activo)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Usuarios SET Activo = @Activo WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, Activo = activo });
            return filas > 0;
        }

        public async Task<EditarUsuarioModel?> ObtenerUsuarioParaEditar(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                SELECT
                    u.Id, u.Nombre, u.Apellido, u.Correo, u.Nro_Contacto AS NroContacto,
                    u.Id_Area AS IdArea, u.Es_Coordinador AS EsCoordinador, u.Id_Sup_Usuario AS IdSupUsuario
                FROM Usuarios u
                WHERE u.Id = @Id;

                SELECT Id_Sociedad FROM Usuario_Sociedad WHERE Id_Usuario = @Id;
            ";

            using var resultado = await xCon.QueryMultipleAsync(sql, new { Id = id });

            var usuario = await resultado.ReadFirstOrDefaultAsync<EditarUsuarioModel>();
            if (usuario is null) return null;

            usuario.IdSociedades = (await resultado.ReadAsync<int>()).ToList();
            return usuario;
        }

        public async Task<bool> ActualizarUsuario(EditarUsuarioModel model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            await xCon.OpenAsync();
            using var transaccion = xCon.BeginTransaction();

            try
            {
                var sql = @"
                    UPDATE Usuarios SET
                        Nombre = @Nombre,
                        Apellido = @Apellido,
                        Correo = @Correo,
                        Nro_Contacto = @NroContacto,
                        Id_Area = @IdArea,
                        Es_Coordinador = @EsCoordinador,
                        Id_Sup_Usuario = @IdSupUsuario
                    WHERE Id = @Id
                ";

                var filas = await xCon.ExecuteAsync(sql, model, transaccion);

                if (filas == 0)
                {
                    transaccion.Rollback();
                    return false;
                }

                // Las sociedades se re-sincronizan por completo: es más simple y seguro
                // que calcular el diferencial entre las actuales y las nuevas.
                await xCon.ExecuteAsync(
                    "DELETE FROM Usuario_Sociedad WHERE Id_Usuario = @Id",
                    new { model.Id },
                    transaccion);

                await xCon.ExecuteAsync(
                    "INSERT INTO Usuario_Sociedad (Id_Usuario, Id_Sociedad) VALUES (@IdUsuario, @IdSociedad)",
                    model.IdSociedades.Select(idSociedad => new { IdUsuario = model.Id, IdSociedad = idSociedad }),
                    transaccion);

                transaccion.Commit();
                return true;
            }
            catch
            {
                transaccion.Rollback();
                throw;
            }
        }

        public async Task<(bool Exito, string? Mensaje)> EliminarUsuario(int id)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            await xCon.OpenAsync();
            using var transaccion = xCon.BeginTransaction();

            try
            {
                await xCon.ExecuteAsync("DELETE FROM Usuario_Sociedad WHERE Id_Usuario = @Id", new { Id = id }, transaccion);

                var filas = await xCon.ExecuteAsync("DELETE FROM Usuarios WHERE Id = @Id", new { Id = id }, transaccion);

                if (filas == 0)
                {
                    transaccion.Rollback();
                    return (false, "No se encontró el usuario a eliminar.");
                }

                transaccion.Commit();
                return (true, null);
            }
            catch (SqlException ex) when (ex.Number == 547) // Violación de FK: el usuario tiene tickets u otra información asociada.
            {
                transaccion.Rollback();
                return (false, "No se puede eliminar: el usuario tiene tickets u otra información asociada. Desactívalo en su lugar.");
            }
        }

        public async Task<List<CatalogoModel>> ObtenerRoles()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Rol WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerTodasLasAreas()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "SELECT Id, Nombre FROM Area WHERE Activo = 1 ORDER BY Nombre";
            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerPosiblesSupervisores()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                SELECT u.Id AS Id, CONCAT(u.Nombre, ' ', u.Apellido) AS Nombre
                FROM Usuarios u
                WHERE u.Activo = 1
                ORDER BY u.Nombre, u.Apellido
            ";

            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }

        public async Task<List<CatalogoModel>> ObtenerSociedades()
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"SELECT Id, Nombre FROM Sociedad WHERE Activo = 1 ORDER BY Nombre";

            var result = await xCon.QueryAsync<CatalogoModel>(sql);
            return result.ToList();
        }
    }
}
