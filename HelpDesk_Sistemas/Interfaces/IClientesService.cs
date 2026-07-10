using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IClientesService
    {
        Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(FiltrosClientesModel model);
        Task<IPagedList<ClientesModel>> ListadoClientes(FiltrosClientesModel model);
        Task<bool> CrearCliente(ClientesModel model);
    }
}
