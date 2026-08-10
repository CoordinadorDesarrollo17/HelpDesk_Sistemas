namespace HelpDesk_Sistemas.Models
{
    // modelo generico para cualquier combo simple (id + nombre):
    //se reutiliza para tipo_requerimiento,area y categoria - evita
    //crear 3 clases casi identicas solo para llenar un <select>
    public class CatalogoModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
    }
}
