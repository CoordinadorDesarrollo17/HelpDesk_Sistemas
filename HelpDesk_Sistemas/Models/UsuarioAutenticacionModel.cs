namespace HelpDesk_Sistemas.Models
{
    // Solo para validar el login — nunca se expone tal cual a una vista.
    public class UsuarioAutenticacionModel
    {
        public int Id { get; set; }
        public string Usuario { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty; // hash
        public string NombreCompleto { get; set; } = string.Empty;
        public string Rol { get; set; } = string.Empty;
        public int IdArea { get; set; }
        public bool Activo { get; set; }
    }
}
