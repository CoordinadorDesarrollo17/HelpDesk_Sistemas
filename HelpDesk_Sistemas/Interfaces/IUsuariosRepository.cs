using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IUsuariosRepository
    {
        Task<UsuarioAutenticacionModel?> ObtenerParaLogin(string usuario);
        Task<List<UsuarioModel>> ObtenerUsuarios();
        Task<int> ObtenerSiguienteNumeroSecuencial(int idRol);
        Task<int> CrearUsuario(CrearUsuarioModel model, string usuario, string passwordHash, int numeroSecuencial, string usuarioCreacion);
        Task<bool> CambiarActivo(int id, bool activo);

        Task<List<CatalogoModel>> ObtenerRoles();
        Task<List<CatalogoModel>> ObtenerTodasLasAreas();
        Task<List<CatalogoModel>> ObtenerPosiblesSupervisores();
    }
}
