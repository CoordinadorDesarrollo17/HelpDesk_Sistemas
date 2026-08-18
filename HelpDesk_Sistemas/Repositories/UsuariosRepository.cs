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

            var sql = @"
                SELECT
                    u.Id, u.Nombre, u.Apellido, u.Usuario, r.Nombre AS Rol, a.Nombre AS Area, u.Correo, u.Activo
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

            var sql = @"
                INSERT INTO Usuarios
                    (IdRol, Id_Area, Es_Coordinador, Nombre, Apellido, Correo, Nro_Contacto, Id_Sup_Usuario,
                     Usuario, Password, Numero_Secuencial, Activo, Usu_Creacion)
                VALUES
                    (@IdRol, @IdArea, @EsCoordinador, @Nombre, @Apellido, @Correo, @NroContacto, @IdSupUsuario,
                     @Usuario, @PasswordHash, @NumeroSecuencial, 1, @UsuarioCreacion);
                SELECT SCOPE_IDENTITY();
            ";

            return await xCon.ExecuteScalarAsync<int>(sql, new
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
            });
        }

        public async Task<bool> CambiarActivo(int id, bool activo)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);
            var sql = "UPDATE Usuarios SET Activo = @Activo WHERE Id = @Id";
            var filas = await xCon.ExecuteAsync(sql, new { Id = id, Activo = activo });
            return filas > 0;
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
    }
}
