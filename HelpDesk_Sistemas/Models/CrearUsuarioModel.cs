using System.ComponentModel.DataAnnotations;

namespace HelpDesk_Sistemas.Models
{
    public class CrearUsuarioModel
    {
        [Required(ErrorMessage = "El nombre es obligatorio.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "El apellido es obligatorio.")]
        public string Apellido { get; set; } = string.Empty;

        public string? Correo { get; set; }
        public string? NroContacto { get; set; }

        [Required(ErrorMessage = "Selecciona un rol.")]
        public int IdRol { get; set; }

        [Required(ErrorMessage = "Selecciona un área.")]
        public int IdArea { get; set; }

        public bool EsCoordinador { get; set; }
        public int? IdSupUsuario { get; set; }
    }
}
