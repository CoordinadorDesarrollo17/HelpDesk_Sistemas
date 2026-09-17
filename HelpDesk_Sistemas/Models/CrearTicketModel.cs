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

        //obligatorio solo si el área lo requiere (Soporte Sistemas / Soporte Desarrollo)
        public int? IdSistema { get; set; }

        //no es obligatorio para implementacion y mejora
        public int? IdCategoria { get; set; }

        [Required(ErrorMessage = "El detalle del requerimiento es obligatorio.")]
        [MinLength(20, ErrorMessage = "Describe tu requerimiento con al menos 20 caracteres.")]
        public string Detalle { get; set; }

        //solo para Soporte: reemplazan al viejo AfectaFuncionamiento Sí/No
        public int? IdImpacto { get; set; }
        public int? IdUrgencia { get; set; }

        public List<IFormFile>? Archivos { get; set; }

        [Required(ErrorMessage = "Selecciona la sociedad para este ticket.")]
        public int? IdSociedad { get; set; }

        // Temporal, solo para pruebas: permite indicar manualmente de qué área es el
        // solicitante, en vez de que siempre se derive del área propia de quien crea el
        // ticket (todas las pruebas las hacen las mismas cuentas, así que sin esto no hay
        // trazabilidad de qué área originó cada reporte). Opcional: si se deja vacío, el
        // comportamiento es el de siempre (se usa el área del usuario que crea el ticket).
        public int? IdAreaSolicitante { get; set; }
    }
}
