using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Services
{
    public class AnexosService : IAnexosService
    {
        private readonly IAnexosRepository anexosRepository;
        private readonly IConfiguration configuration;
        private readonly ILogger<AnexosService> logger;

        private const long TamanoMaximoBytes = 10 * 1024 * 1024;
        private static readonly string[] ExtensionesPermitidas = { ".jpg", ".jpeg", ".png", ".pdf", ".docx", ".xlsx", ".ppt", ".pptx", ".mp4" };

        public AnexosService(IAnexosRepository anexosRepository, IConfiguration configuration, ILogger<AnexosService> logger)
        {
            this.anexosRepository = anexosRepository;
            this.configuration = configuration;
            this.logger = logger;
        }

        // Carpeta SEPARADA de los adjuntos de tickets — así una limpieza de
        // adjuntos de tickets nunca toca por accidente la base de conocimiento.
        private string ObtenerCarpetaGuias()
        {
            return configuration["Almacenamiento:CarpetaGuias"] ?? @"D:\COBEFARWEBFILES\Helpdesk_Guias";
        }

        public Task<List<GuiaCategoriaModel>> ObtenerCategorias() => anexosRepository.ObtenerCategorias();
        public Task<List<GuiaSubcategoriaModel>> ObtenerSubcategorias(int idCategoria) => anexosRepository.ObtenerSubcategorias(idCategoria);
        public Task<List<GuiaModel>> ObtenerGuias(int? idCategoria, int? idSubcategoria, string? buscar, bool priorizarSubcategoria = false) => anexosRepository.ObtenerGuias(idCategoria, idSubcategoria, buscar, priorizarSubcategoria);
        public Task<GuiaModel?> ObtenerGuiaPorId(int id) => anexosRepository.ObtenerGuiaPorId(id);
        public Task VincularGuiaATicket(int idTicket, int idGuia, int idUsuarioAccion) => anexosRepository.VincularGuiaATicket(idTicket, idGuia, idUsuarioAccion);
        public Task<List<GuiaModel>> ObtenerGuiasVinculadas(int idTicket) => anexosRepository.ObtenerGuiasVinculadas(idTicket);

        public async Task<(bool Exito, string? Mensaje)> CrearGuia(CrearGuiaModel model, int idUsuarioSube)
        {
            if (model.Archivo is null || model.Archivo.Length == 0)
            {
                return (false, "Selecciona un archivo para la guía.");
            }

            if(model.Archivo.Length > TamanoMaximoBytes)
            {
                return (false, $"El archivo supera el tamaño máximo de 10 MB.");
            }

            var extension = Path.GetExtension(model.Archivo.FileName).ToLower();
            if (!ExtensionesPermitidas.Contains(extension))
            {
                return (false, "Formato de archivo no permitido.");
            }

            var carpeta = ObtenerCarpetaGuias();

            try
            {
                Directory.CreateDirectory(carpeta);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "No se pudo acceder a la carpeta de guías '{Carpeta}'.", carpeta);
                return (false, "No se pudo acceder a la carpeta de guías del servidor.");
            }

            var nombreUnico = $"{Guid.NewGuid()}_{model.Archivo.FileName}";
            var rutaFisica = Path.Combine(carpeta, nombreUnico);

            using (var stream = new FileStream(rutaFisica, FileMode.Create))
            {
                await model.Archivo.CopyToAsync(stream);
            }

            var pesoKB = (int)(model.Archivo.Length / 1024);
            await anexosRepository.CrearGuia(model, model.Archivo.FileName, nombreUnico, pesoKB, idUsuarioSube);

            return (true, null);
        }

        public async Task<(bool Exito, string? Mensaje)> EditarGuia(int id, CrearGuiaModel model)
        {
            // Editar aquí NO reemplaza el archivo (mantenlo simple: para cambiar el
            // archivo, se elimina la guía y se sube una nueva). Si luego quieres
            // permitir reemplazar el archivo, es el mismo bloque de guardado de
            // CrearGuia, pero actualizando Ruta_Archivo/Nombre_Archivo/Peso_KB.
            var exito = await anexosRepository.EditarGuia(id, model);
            return (exito, exito ? null : "No se encontró la guía.");
        }

        public Task<bool> EliminarGuia(int id) => anexosRepository.EliminarGuia(id);

        public async Task<(string RutaFisica, string NombreArchivo)?> ObtenerArchivoParaDescarga(int id)
        {
            var guia = await anexosRepository.ObtenerGuiaPorId(id);
            if (guia is null || string.IsNullOrEmpty(guia.RutaArchivo)) return null;

            // Ruta_Archivo es el nombre único en disco (con el GUID adelante); Nombre_Archivo
            // es el nombre original que ve el usuario — no son intercambiables.
            var rutaFisica = Path.Combine(ObtenerCarpetaGuias(), Path.GetFileName(guia.RutaArchivo));

            if (!File.Exists(rutaFisica)) return null;

            return (rutaFisica, guia.NombreArchivo);
        }
    }
}
