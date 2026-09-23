using HelpDesk_Sistemas.Models;
namespace HelpDesk_Sistemas.Interfaces
{
    public interface IAnexosRepository
    {
        Task<List<GuiaCategoriaModel>> ObtenerCategorias();
        Task<List<GuiaSubcategoriaModel>> ObtenerSubcategorias(int idCategoria);

        /// <summary>Buscador global: si "buscar" tiene texto, ignora los filtros de
        /// categoría/subcategoría — es justo la regla de "sugerencia, no restricción".</summary>
        Task<List<GuiaModel>> ObtenerGuias(int? idCategoria, int? idSubcategoria, string? buscar, bool priorizarSubcategoria = false);
        
        Task<GuiaModel?> ObtenerGuiaPorId(int id);
        Task<int> CrearGuia(CrearGuiaModel model, string nombreArchivo, string rutaArchivo, int pesoKB, int idUsuarioSube);
        Task<bool> EditarGuia(int id, CrearGuiaModel model);
        Task<bool> EliminarGuia(int id);

        Task VincularGuiaATicket(int idTicket, int idGuia, int idUsuarioAccion);
        Task<List<GuiaModel>> ObtenerGuiasVinculadas(int idTicket);
    }
}
