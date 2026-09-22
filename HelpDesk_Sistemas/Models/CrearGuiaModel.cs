//lo que llega del formulario al subir
using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace HelpDesk_Sistemas.Models
{
    public class CrearGuiaModel
    {
        [Required(ErrorMessage ="El título es obligatorio.")]
        public string Titulo { get; set; } = string.Empty;
        public string? Descripcion { get; set; }

        [Required(ErrorMessage ="Selecciona una categoría.")]
        public int? IdGuiaCategoria { get; set; }
        public int? IdSubcategoria { get; set; }
        public IFormFile? Archivo { get; set; }
    }
}
