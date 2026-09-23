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

        // Con [Required] acá, el error de "falta el archivo" sale junto con los de
        // Título/Categoría en el mismo envío — antes solo se detectaba dentro de
        // AnexosService.CrearGuia, que ni se llegaba a ejecutar si ya había otros
        // errores, así que el usuario lo veía recién en un segundo intento.
        [Required(ErrorMessage = "Selecciona un archivo para la guía.")]
        public IFormFile? Archivo { get; set; }
    }
}
