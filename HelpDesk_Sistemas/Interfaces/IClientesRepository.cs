using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IClientesRepository
    {
        Task<IPagedList<ClientesModel>> ListadoClientes(FiltrosClientesModel model);
        Task<List<ClientesModel>> ListadoClientesExcel(FiltrosClientesModel model);
        Task<IEnumerable<ClientesModel>> ObtenerClientes(FiltrosClientesModel model);
        Task<int> CrearCliente(ClientesModel model);
    }
}
