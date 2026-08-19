using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IUsuariosRepository
    {
        Task<UsuarioAutenticacionModel?> ObtenerParaLogin(string usuario);
        Task<List<UsuarioModel>> ObtenerUsuarios();

        /// <summary>Área con su Prefijo (para generar el Usuario al crear una cuenta).</summary>
        Task<AreaModel?> ObtenerAreaPorId(int idArea);

        Task<string?> ObtenerRolUsuario(int idUsuario);

        /// <summary>Siguiente correlativo para ese prefijo de área (ej. "MANAGER" -> 4, para "manager4").</summary>
        Task<int> ObtenerSiguienteNumeroSecuencial(string prefijo);

        Task<int> CrearUsuario(CrearUsuarioModel model, string usuario, string passwordHash, int numeroSecuencial, string usuarioCreacion);
        Task<bool> CambiarActivo(int id, bool activo);

        Task<EditarUsuarioModel?> ObtenerUsuarioParaEditar(int id);
        Task<bool> ActualizarUsuario(EditarUsuarioModel model);
        Task<(bool Exito, string? Mensaje)> EliminarUsuario(int id);

        Task<List<CatalogoModel>> ObtenerRoles();
        Task<List<AreaModel>> ObtenerTodasLasAreas();
        Task<List<CatalogoModel>> ObtenerPosiblesSupervisores();
        Task<List<CatalogoModel>> ObtenerSociedades();
    }
}
