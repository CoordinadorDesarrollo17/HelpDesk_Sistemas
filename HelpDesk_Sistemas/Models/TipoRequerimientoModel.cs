namespace HelpDesk_Sistemas.Models
{
    // como catalogomodel, pero con la bandera que el formulario necesita
    // para saber si debe mostrar categoria y la pregunta de impacto
    public class TipoRequerimientoModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public bool RequiereCategoria { get; set; }
    }
}
