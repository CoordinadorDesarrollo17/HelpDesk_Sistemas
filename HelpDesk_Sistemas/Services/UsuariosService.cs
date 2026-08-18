using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Services
{
    public class UsuariosService : IUsuariosService
    {
        private readonly IUsuariosRepository usuariosRepository;

        public UsuariosService(IUsuariosRepository usuariosRepository)
        {
            this.usuariosRepository = usuariosRepository;
        }

        public async Task<UsuarioAutenticacionModel?> ValidarCredenciales(string usuario, string password)
        {
            var candidato = await usuariosRepository.ObtenerParaLogin(usuario.Trim().ToLowerInvariant());

            if (candidato is null || !candidato.Activo) return null;

            return PasswordHasher.Verify(password, candidato.Password) ? candidato : null;
        }

        public async Task<List<UsuarioModel>> ObtenerUsuarios()
        {
            return await usuariosRepository.ObtenerUsuarios();
        }

        public async Task<(bool Exito, string? Mensaje, string? UsuarioGenerado, string? PasswordGenerada)> CrearUsuario(CrearUsuarioModel model, string usuarioCreacion)
        {
            var roles = await usuariosRepository.ObtenerRoles();
            var rol = roles.FirstOrDefault(r => r.Id == model.IdRol);

            if (rol is null)
            {
                return (false, "El rol seleccionado no es válido.", null, null);
            }

            model.IdSociedades = model.IdSociedades.Distinct().ToList();

            if (model.IdSociedades.Count == 0)
            {
                return (false, "Selecciona al menos una sociedad.", null, null);
            }

            var numeroSecuencial = await usuariosRepository.ObtenerSiguienteNumeroSecuencial(model.IdRol);
            var usuarioGenerado = GeneradorCredenciales.GenerarUsuario(rol.Nombre, numeroSecuencial);
            var passwordGenerada = GeneradorCredenciales.GenerarPassword(model.Nombre, model.Apellido, numeroSecuencial);
            var passwordHash = PasswordHasher.Hash(passwordGenerada);

            await usuariosRepository.CrearUsuario(model, usuarioGenerado, passwordHash, numeroSecuencial, usuarioCreacion);

            return (true, null, usuarioGenerado, passwordGenerada);
        }

        public async Task<bool> CambiarActivo(int id, bool activo)
        {
            return await usuariosRepository.CambiarActivo(id, activo);
        }

        public async Task<EditarUsuarioModel?> ObtenerUsuarioParaEditar(int id)
        {
            return await usuariosRepository.ObtenerUsuarioParaEditar(id);
        }

        public async Task<(bool Exito, string? Mensaje)> ActualizarUsuario(EditarUsuarioModel model)
        {
            if (model.IdSupUsuario == model.Id)
            {
                return (false, "Un usuario no puede ser su propio supervisor.");
            }

            model.IdSociedades = model.IdSociedades.Distinct().ToList();

            if (model.IdSociedades.Count == 0)
            {
                return (false, "Selecciona al menos una sociedad.");
            }

            var actualizado = await usuariosRepository.ActualizarUsuario(model);

            return actualizado
                ? (true, (string?)null)
                : (false, "No se encontró el usuario a actualizar.");
        }

        public async Task<(bool Exito, string? Mensaje)> EliminarUsuario(int id, int idUsuarioActual)
        {
            if (id == idUsuarioActual)
            {
                return (false, "No puedes eliminar tu propio usuario.");
            }

            return await usuariosRepository.EliminarUsuario(id);
        }

        public async Task<List<CatalogoModel>> ObtenerRoles()
        {
            return await usuariosRepository.ObtenerRoles();
        }

        public async Task<List<CatalogoModel>> ObtenerTodasLasAreas()
        {
            return await usuariosRepository.ObtenerTodasLasAreas();
        }

        public async Task<List<CatalogoModel>> ObtenerPosiblesSupervisores()
        {
            return await usuariosRepository.ObtenerPosiblesSupervisores();
        }

        public async Task<List<CatalogoModel>> ObtenerSociedades()
        {
            return await usuariosRepository.ObtenerSociedades();
        }
    }
}
