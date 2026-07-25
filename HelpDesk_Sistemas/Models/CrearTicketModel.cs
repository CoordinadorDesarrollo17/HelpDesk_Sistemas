using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;


namespace HelpDesk_Sistemas.Models
{
    //Lo que llega desde el formulario cuando el usuario envia un ticket nuevo
    public class CrearTicketModel
    {
        [Required(ErrorMessage = "Selecciona un tipo de requerimiento.")]
        public int? IdTipoRequerimiento { get; set; }

        [Required(ErrorMessage = "Selecciona un área.")]
        public int? IdArea { get; set; }

        //no es obligatorio para implementacion y mejora
        public int? IdCategoria { get; set; }

        [Required(ErrorMessage = "El detalle del requerimiento es obligatorio.")]
        [MinLength(20, ErrorMessage = "Describe tu requerimiento con al menos 20 caracteres.")]
        public string Detalle { get; set; }

        public bool? AfectaFuncionamiento { get; set; }

        public List<IFormFile>? Archivos { get; set; }
    }
}
