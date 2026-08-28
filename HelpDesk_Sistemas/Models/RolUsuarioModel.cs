namespace HelpDesk_Sistemas.Models
{
    /// <summary>Rol actual de un usuario (Id + Nombre), usado al validar un cambio de rol al editar.</summary>
    public class RolUsuarioModel
    {
        public int IdRol { get; set; }
        public string Nombre { get; set; } = string.Empty;
    }
}
