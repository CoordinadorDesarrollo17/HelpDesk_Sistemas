using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IUsuariosService
    {
        Task<UsuarioAutenticacionModel?> ValidarCredenciales(string usuario, string password);

        Task<List<UsuarioModel>> ObtenerUsuarios();
        Task<(bool Exito, string? Mensaje, string? UsuarioGenerado, string? PasswordGenerada)> CrearUsuario(CrearUsuarioModel model, string usuarioCreacion);
        Task<bool> CambiarActivo(int id, bool activo);

        Task<EditarUsuarioModel?> ObtenerUsuarioParaEditar(int id);
        Task<(bool Exito, string? Mensaje)> ActualizarUsuario(EditarUsuarioModel model);
        Task<(bool Exito, string? Mensaje)> EliminarUsuario(int id, int idUsuarioActual);

        Task<List<CatalogoModel>> ObtenerRoles();
        Task<List<AreaModel>> ObtenerTodasLasAreas();
        Task<List<CatalogoModel>> ObtenerPosiblesSupervisores();
        Task<List<CatalogoModel>> ObtenerSociedades();
    }
}
