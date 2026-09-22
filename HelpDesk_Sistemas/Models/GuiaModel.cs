//lo que se lista/consulta
namespace HelpDesk_Sistemas.Models
{
    public class GuiaModel
    {
        public int Id { get; set; }
        public string Titulo { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
        public string NombreArchivo { get; set; } = string.Empty; //nombre original, el que ve el usuario
        public string RutaArchivo { get; set; } = string.Empty; //nombre único guardado en disco, para servir la descarga
        public int? PesoKB { get; set; }
        public string? Categoria { get; set; }
        public string? Subcategoria { get; set; }
        public int? IdGuiaCategoria { get; set; }
        public int? IdSubcategoria { get; set; }
        public string? SubidoPor { get; set; }
        public DateTime FechaCreacion { get; set; }
    }
}
