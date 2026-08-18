using System.ComponentModel.DataAnnotations;

namespace HelpDesk_Sistemas.Models
{
    public class EditarUsuarioModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "El apellido es obligatorio.")]
        public string Apellido { get; set; } = string.Empty;

        public string? Correo { get; set; }
        public string? NroContacto { get; set; }

        [Required(ErrorMessage = "Selecciona un área.")]
        public int IdArea { get; set; }

        // Un usuario pertenece a una o más sociedades (mínimo una).
        [MinLength(1, ErrorMessage = "Selecciona al menos una sociedad.")]
        public List<int> IdSociedades { get; set; } = new();

        public bool EsCoordinador { get; set; }
        public int? IdSupUsuario { get; set; }
    }
}
