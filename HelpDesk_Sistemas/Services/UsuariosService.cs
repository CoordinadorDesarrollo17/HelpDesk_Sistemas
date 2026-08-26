using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Services
{
    public class UsuariosService : IUsuariosService
    {
        // Administrador y Soporte quedan restringidos a las áreas de soporte
        // (TI/Sistemas/Desarrollo); Supervisor y Usuario pueden ser de cualquier
        // área de la empresa.
        private static readonly string[] RolesSoloAreasSistemas = { "Administrador", "Soporte" };

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

            // El Usuario/Password se generan a partir del Área (su Prefijo), no del
            // Rol: el Rol solo define permisos dentro de HelpDesk, mientras que el
            // Prefijo replica la convención real de la empresa (ej. "manager3").
            var area = await usuariosRepository.ObtenerAreaPorId(model.IdArea);

            if (area is null || string.IsNullOrWhiteSpace(area.Prefijo))
            {
                return (false, "El área seleccionada no tiene un prefijo configurado para generar el usuario.", null, null);
            }

            if (RolesSoloAreasSistemas.Contains(rol.Nombre) && !area.EsAreaSistemas)
            {
                return (false, "Para Administrador o Soporte, selecciona una de las 3 áreas de soporte (TI, Sistemas o Desarrollo).", null, null);
            }

            model.IdSociedades = model.IdSociedades.Distinct().ToList();

            if (model.IdSociedades.Count == 0)
            {
                return (false, "Selecciona al menos una sociedad.", null, null);
            }

            var numeroSecuencial = await usuariosRepository.ObtenerSiguienteNumeroSecuencial(area.Prefijo);
            var usuarioGenerado = GeneradorCredenciales.GenerarUsuario(area.Prefijo, numeroSecuencial);
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

            // El Rol no se edita en este formulario, así que se valida contra el Rol
            // real ya guardado (no contra model.Rol, que el cliente podría alterar).
            var rolActual = await usuariosRepository.ObtenerRolUsuario(model.Id);

            if (rolActual is not null && RolesSoloAreasSistemas.Contains(rolActual))
            {
                var area = await usuariosRepository.ObtenerAreaPorId(model.IdArea);

                if (area is null || !area.EsAreaSistemas)
                {
                    return (false, "Para Administrador o Soporte, selecciona una de las 3 áreas de soporte (TI, Sistemas o Desarrollo).");
                }
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

        public async Task<List<AreaModel>> ObtenerAreasSistemas()
        {
            return await usuariosRepository.ObtenerAreasSistemas();
        }

        public async Task<List<CatalogoModel>> ObtenerDepartamentos()
        {
            return await usuariosRepository.ObtenerDepartamentos();
        }

        public async Task<List<CatalogoModel>> ObtenerAreasPorDepartamento(int idDepartamento)
        {
            return await usuariosRepository.ObtenerAreasPorDepartamento(idDepartamento);
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
