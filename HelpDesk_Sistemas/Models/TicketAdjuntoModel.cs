namespace HelpDesk_Sistemas.Models
{
    //representa un archivo adjunto a un ticket, que puede ser un documento, imagen, etc.
    public class TicketAdjuntoModel
    {
        public int Id { get; set; }
        public string NombreArchivo { get; set; } //nombre del archivo con extensión
        public string RutaArchivo { get; set; } //ruta completa del archivo en el servidor
        public int? PesoKB { get; set; } //peso del archivo en KB, puede ser null si no se conoce
        public string Origen { get; set; } = "Solicitud"; //"Solicitud" (lo subió el solicitante) o "Solucion" (lo subió Soporte al registrar la solución)
    }
}
