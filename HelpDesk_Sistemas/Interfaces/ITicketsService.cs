using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface ITicketsService
    {
        // ============================================================
        // LISTADO Y FILTROS
        // ============================================================

        Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual, string rolActual);
        Task<TicketsResumenModel> ObtenerResumen(int idUsuarioActual);
        Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(FiltrosTicketsModel model, int idUsuarioActual, string rolActual);
        Task<TicketsModel?> ObtenerTicketPorId(int id);   // NUEVO: para el endpoint GET /api/tickets/{id}


        // ============================================================
        // CATÁLOGOS
        // ============================================================

        Task<List<CatalogoModel>> ObtenerEstados();
        Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimiento();
        Task<List<CatalogoModel>> ObtenerAreasSistemas();
        Task<List<CatalogoModel>> ObtenerCategoriasPorArea(int idArea);
        Task<List<CatalogoModel>> ObtenerPrioridades();
        Task<bool> TipoRequiereCategoria(int idTipoRequerimiento);
        Task<List<CatalogoModel>> ObtenerSociedadesPorUsuario(int idUsuario);
        Task<List<CatalogoModel>> ObtenerImpactos();
        Task<List<CatalogoModel>> ObtenerUrgencias();
        Task<List<MatrizPrioridadModel>> ObtenerMatrizPrioridad();

        // ============================================================
        // DETALLE
        // ============================================================

        Task<TicketDetalleModel?> ObtenerDetalleTicket(int idTicket);

        /// <summary>Solución registrada por Soporte, para revisarla antes de confirmar o devolver.</summary>
        Task<TicketSolucionModel?> ObtenerSolucion(int idTicket);

        // ============================================================
        // CREACIÓN
        // ============================================================

        Task<(int IdTicket, List<string> Errores)> CrearTicket(CrearTicketModel model, int idUsuarioSolicita, bool requiereCategoria);

        // ============================================================
        // FLUJO CONSULTA / SOPORTE
        // ============================================================

        Task<bool> TomarTicket(int idTicket, int idUsuarioAsignado);
        Task<bool> AtenderTicket(int idTicket, int idUsuarioAccion);
        Task<bool> PausarTicket(int idTicket, int idUsuarioAccion, string tipoMotivo, int? idTicketRelacionado);
        Task<bool> ReanudarTicket(int idTicket, int idUsuarioAccion, string comentario = "Ticket reanudado");
        Task<List<PausaVencidaModel>> ObtenerPausasRefrigerioVencidas();
        Task<bool> ValidarTicket(int idTicket, int idUsuarioAccion, string solucion);
        Task<bool> ConfirmarSolucion(int idTicket, int idUsuarioAccion);
        Task<bool> DevolverTicket(int idTicket, int idUsuarioAccion, string motivo);
        Task<bool> AnularTicket(int idTicket, int idUsuarioAccion, string motivo);

        // ============================================================
        // PRIORIDAD Y ORDEN DE ATENCIÓN (ambos flujos)
        // ============================================================

        Task<bool> AsignarPrioridad(int idTicket, int idPrioridad);
        Task<(bool Exito, string? Mensaje)> AsignarOrdenAtencion(int idTicket, int orden, int idUsuarioActual, int idAreaUsuarioActual);
        Task<List<CatalogoModel>> ObtenerMisTicketsPropios(int idUsuario, int idTicketActual);

        // ============================================================
        // FLUJO IMPLEMENTACIÓN Y MEJORA
        // ============================================================

        Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado);
        Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion);
        Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion);
        Task<bool> UsuarioPerteneceSociedad(int idUsuario, int idSociedad);

        // ============================================================
        // REASIGNACIÓN (ambos flujos)
        // ============================================================

        Task<List<CatalogoModel>> ObtenerUsuariosSoportePorArea(int idArea);
        Task<bool> ReasignarTicket(int idTicket, int idNuevoUsuario, int idUsuarioAccion);
    }
}