namespace HelpDesk_Sistemas.Models
{
    /// <summary>Respuesta de la API de autenticación de la intranet (api/auth/validate).
    /// Solo DocEntry identifica a la persona — Nombres/Apellidos son informativos,
    /// nunca se usan para decidir el enlace con un usuario del HelpDesk.</summary>
    public class IntranetAuthResultModel
    {
        public bool Success { get; set; }
        public int DocEntry { get; set; }
        public string? Nombres { get; set; }
        public string? Apellidos { get; set; }
        public string? Message { get; set; }
    }
}
