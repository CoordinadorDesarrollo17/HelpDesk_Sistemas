using System.ComponentModel.DataAnnotations;

namespace HelpDesk_Sistemas.Models
{
    public class EditarUsuarioModel
    {
        public int Id { get; set; }

        /// <summary>Rol actual del usuario (no viene del formulario: solo para filtrar el combo de
        /// Área y decidir si el Rol se puede editar).</summary>
        public string Rol { get; set; } = string.Empty;

        /// <summary>Nuevo rol elegido en el formulario — solo se manda (y solo se aplica) cuando el
        /// rol actual es Usuario o Supervisor; para Soporte/Administrador el campo no se muestra.</summary>
        public int? IdRolNuevo { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "El apellido es obligatorio.")]
        public string Apellido { get; set; } = string.Empty;

        public string? Correo { get; set; }
        public string? NroContacto { get; set; }

        [Required(ErrorMessage = "Selecciona un área.")]
        public int IdArea { get; set; }

        /// <summary>Departamento del área actual (solo para precargar el combo al editar, no se guarda).</summary>
        public int? IdDepartamentoActual { get; set; }

        /// <summary>Nombre y estado del área actual (solo para el formulario: si el área quedó
        /// inactiva mientras tanto, el cascade por AJAX no la trae porque solo lista áreas activas
        /// — con esto se puede mostrar igual como opción, marcada "(inactiva)", en vez de dejar el
        /// combo en blanco y arriesgar que se pierda la asignación real al guardar.</summary>
        public string? AreaActualNombre { get; set; }
        public bool AreaActualActiva { get; set; }

        // Un usuario pertenece a una o más sociedades (mínimo una).
        [MinLength(1, ErrorMessage = "Selecciona al menos una sociedad.")]
        public List<int> IdSociedades { get; set; } = new();

        public bool EsCoordinador { get; set; }
        public int? IdSupUsuario { get; set; }
    }
}
