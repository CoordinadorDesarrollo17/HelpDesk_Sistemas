using System.ComponentModel.DataAnnotations;

namespace HelpDesk_Sistemas.Models
{
    public class LoginModel
    {
        [Required(ErrorMessage = "Ingresa tu usuario.")]
        public string Usuario { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresa tu contraseña.")]
        public string Password { get; set; } = string.Empty;

        public string? ReturnUrl { get; set; }
    }
}
