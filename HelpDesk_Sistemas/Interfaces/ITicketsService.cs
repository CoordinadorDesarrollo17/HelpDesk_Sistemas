using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface ITicketsService
    {
        Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(FiltrosTicketsModel model, int idUsuarioActual);
        Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual);
        Task<List<CatalogoModel>> ObtenerEstados();
        Task<TicketDetalleModel?> ObtenerDetalleTicket(int idTicket);
        Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimiento();
        Task<List<CatalogoModel>> ObtenerAreasSistemas();
        Task<List<CatalogoModel>> ObtenerCategoriasPorArea(int idArea);
        Task<(int IdTicket, List<string> Errores)> CrearTicket(CrearTicketModel model, int idUsuarioSolicita, bool requiereCategoria);
        Task<bool> TipoRequiereCategoria(int idTipoRequerimiento);
        Task<bool> TomarTicket(int idTicket, int idUsuarioAsignado);
        Task<bool> AnularTicket(int idTicket, int idUsuarioAccion, string motivo);
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

        //IMPLENTACION Y MEJORA
        Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado);
        Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion);
        Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion);

        //REASIGNAR USUARIO A UN TICKET
        Task<List<CatalogoModel>> ObtenerUsuariosSoportePorArea(int idArea);
        Task<bool> ReasignarTicket(int idTicket, int idNuevoUsuario, int idUsuarioAccion);
    }
}
