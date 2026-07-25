using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface ITicketsRepository
    {
        Task<IEnumerable<TicketsModel>> ObtenerTickets(FiltrosTicketsModel model, int idUsuarioActual);
        //para exportar en excel se necesita un listado completo sin paginacion
        Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual);
        Task<List<TicketsModel>> ListadoTicketsExcel(FiltrosTicketsModel model, int idUsuarioActual);
        Task<List<CatalogoModel>> ObtenerEstados();
        Task<TicketDetalleModel?> ObtenerDetalleTicket(int idTicket);
        Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimiento();
        Task<List<CatalogoModel>> ObtenerAreasSistemas();
        Task<List<CatalogoModel>> ObtenerCategoriasPorArea(int idArea);
        Task<int> CrearTicket(CrearTicketModel model, int idUsuarioSolicita, bool requiereCategoria);
        Task GuardarAdjunto(int idTicket, string nombreArchivo, string rutaArchivo, int pesoKB, int idUsuarioSube);
        Task<bool> TipoRequiereCategoria(int idTipoRequerimiento);
        Task<bool> TomarTicket(int idTicket, int idUsuarioAsignado);
        Task<bool> AnularTicket(int idTicket, int idUsuarioAcción, string motivo);
        Task<List<CatalogoModel>> ObtenerPrioridades();
        Task<bool> AsignarPrioridad(int idTicket, int idPrioridad);
        Task<(bool Exito, string? Mensaje)> AsignarOrdenAtencion(int idTicket, int orden);
        Task<bool> AtenderTicket(int idTicket, int idUsuarioAccion);
        Task<List<CatalogoModel>> ObtenerMisTicketsPropios(int idUsuario, int idTicketActual);
        Task<bool> PausarTicket(int idTicket, int idUsuarioAccion, string tipoMotivo, int? idTicketRelacionado);
        Task<bool> ReanudarTicket(int idTicket, int idUsuarioAccion);
        Task<bool> ValidarTicket(int idTicket, int idUsuarioAccion, string solucion);
        Task<bool> ConfirmarSolucion(int idTicket, int idUsuarioAccion);
        Task<bool> DevolverTicket(int idTicket, int idUsuarioAccion, string motivo);

        //IMPLEMENTACION O MEJORA
        Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado);
        Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion);
        Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion);

        //REASIGNAR USUARIO Y TICKET
        Task<List<CatalogoModel>> ObtenerUsuariosSoportePorArea(int idArea);
        Task<bool> ReasignarTicket(int idTicket, int idNuevoUsuario, int idUsuarioAccion);
    }
}
