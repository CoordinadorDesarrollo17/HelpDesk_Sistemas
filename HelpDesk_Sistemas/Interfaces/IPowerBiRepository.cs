using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IPowerBiRepository
    {
        Task<List<PowerBiTicketModel>> ObtenerTickets(DateTime? fechaInicio, DateTime? fechaFin);
        Task<List<PowerBiDepartamentoModel>> ObtenerDepartamentos();
        Task<List<PowerBiAreaModel>> ObtenerAreas();
        Task<List<CatalogoModel>> ObtenerSociedades();
        Task<List<PowerBiTipoAtencionModel>> ObtenerTiposAtencion();
        Task<List<PowerBiCategoriaModel>> ObtenerCategorias();
        Task<List<CatalogoModel>> ObtenerSistemas();
        Task<List<CatalogoModel>> ObtenerEstados();
        Task<List<CatalogoModel>> ObtenerPrioridades();
        Task<List<PowerBiUsuarioModel>> ObtenerUsuarios();
    }
}
