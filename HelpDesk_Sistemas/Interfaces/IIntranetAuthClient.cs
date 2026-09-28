using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    /// <summary>Cliente de la API de autenticación de la intranet (api/auth/validate).
    /// Devuelve null cuando la intranet no responde (caída, timeout, red) — eso es
    /// distinto de Success = false (credenciales incorrectas), y UsuariosService lo
    /// usa para decidir si cae al login local mientras se migra.</summary>
    public interface IIntranetAuthClient
    {
        Task<IntranetAuthResultModel?> Validar(string usuario, string password);
    }
}
