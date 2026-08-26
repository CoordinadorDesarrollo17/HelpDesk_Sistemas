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

        /// <summary>Las 3 áreas de soporte (TI/Sistemas/Desarrollo) — únicas válidas para Administrador/Soporte.</summary>
        Task<List<AreaModel>> ObtenerAreasSistemas();
        Task<List<CatalogoModel>> ObtenerDepartamentos();
        Task<List<CatalogoModel>> ObtenerAreasPorDepartamento(int idDepartamento);
        Task<List<CatalogoModel>> ObtenerPosiblesSupervisores();
        Task<List<CatalogoModel>> ObtenerSociedades();
    }
}
