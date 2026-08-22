namespace HelpDesk_Sistemas.Models
{
    // como catalogomodel, pero con la bandera que el formulario necesita
    // para saber si debe mostrar categoria y la pregunta de impacto
    public class TipoRequerimientoModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public bool RequiereCategoria { get; set; }

        // 'Soporte' (flujo corto) o 'ImplementacionMejora' (flujo largo).
        public string Flujo { get; set; } = string.Empty;

        // Si este tipo calcula la prioridad automática vía Impacto x Urgencia.
        public bool UsaImpactoUrgencia { get; set; }
    }
}
