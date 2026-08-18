namespace HelpDesk_Sistemas.Models
{
    public class UsuarioModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public string Usuario { get; set; } = string.Empty;
        public string Rol { get; set; } = string.Empty;
        public string Area { get; set; } = string.Empty;
        public string? Correo { get; set; }
        public bool Activo { get; set; }
    }
}
