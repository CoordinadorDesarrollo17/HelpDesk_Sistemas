namespace HelpDesk_Sistemas.Models
{
    public class GuiaSubcategoriaModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int IdGuiaCategoria { get; set; }
    }
}
