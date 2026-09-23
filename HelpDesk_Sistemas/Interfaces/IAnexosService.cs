using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IAnexosService
    {
        Task<List<GuiaCategoriaModel>> ObtenerCategorias();
        Task<List<GuiaSubcategoriaModel>> ObtenerSubcategorias(int idCategoria);
        Task<List<GuiaModel>> ObtenerGuias(int? idCategoria, int? idSubcategoria, string? buscar, bool priorizarSubcategoria = false);
        Task<GuiaModel?> ObtenerGuiaPorId(int id);

        Task<(bool Exito, string? Mensaje)> CrearGuia(CrearGuiaModel model, int idUsuarioSube);
        Task<(bool Exito, string? Mensaje)> EditarGuia(int id, CrearGuiaModel model);
        Task<bool> EliminarGuia(int id);

        Task<(string RutaFisica, string NombreArchivo)?> ObtenerArchivoParaDescarga(int id);

        Task VincularGuiaATicket(int idTicket, int idGuia, int idUsuarioAccion);
        Task<List<GuiaModel>> ObtenerGuiasVinculadas(int idTicket);
    }
}