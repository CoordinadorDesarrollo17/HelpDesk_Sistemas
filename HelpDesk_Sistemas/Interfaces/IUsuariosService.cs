using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IUsuariosService
    {
        Task<UsuarioAutenticacionModel?> ValidarCredenciales(string usuario, string password);

        Task<List<UsuarioModel>> ObtenerUsuarios();
        Task<(bool Exito, string? Mensaje, string? UsuarioGenerado, string? PasswordGenerada)> CrearUsuario(CrearUsuarioModel model, string usuarioCreacion);
        Task<bool> CambiarActivo(int id, bool activo);

        Task<List<CatalogoModel>> ObtenerRoles();
        Task<List<CatalogoModel>> ObtenerTodasLasAreas();
        Task<List<CatalogoModel>> ObtenerPosiblesSupervisores();
    }
}
