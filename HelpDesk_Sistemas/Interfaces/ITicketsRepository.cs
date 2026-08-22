using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface ITicketsRepository
    {
        // ============================================================
        // LISTADO Y FILTROS
        // ============================================================

        Task<IEnumerable<TicketsModel>> ObtenerTickets(FiltrosTicketsModel model, int idUsuarioActual, string rolActual);
        Task<TicketsResumenModel> ObtenerResumen(int idUsuarioActual);
        Task<IPagedList<TicketsModel>> ListadoTickets(FiltrosTicketsModel model, int idUsuarioActual, string rolActual);
        Task<TicketsModel?> ObtenerTicketPorId(int id); //PARA EL ENDPOINT GET /api/tickets/{id}

        /// <summary>Listado completo sin paginar, usado para exportar a Excel.</summary>
        Task<List<TicketsModel>> ListadoTicketsExcel(FiltrosTicketsModel model, int idUsuarioActual, string rolActual);

        // ============================================================
        // CATÁLOGOS
        // ============================================================

        Task<List<CatalogoModel>> ObtenerEstados();
        Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimiento();

        /// <summary>Tipos de atención de una área específica — para el combo de Crear ticket.</summary>
        Task<List<TipoRequerimientoModel>> ObtenerTiposRequerimientoPorArea(int idArea);
        Task<List<CatalogoModel>> ObtenerAreasSistemas();

        /// <summary>Las 3 áreas de soporte con Requiere_Sistema — para el combo de Crear ticket.</summary>
        Task<List<AreaModel>> ObtenerAreasParaCrearTicket();
        Task<List<CatalogoModel>> ObtenerCategoriasPorTipo(int idTipoReq);
        Task<List<CatalogoModel>> ObtenerSistemas();
        Task<List<CatalogoModel>> ObtenerPrioridades();
        Task<List<CatalogoModel>> ObtenerSociedadesPorUsuario(int idUsuario);
        Task<List<CatalogoModel>> ObtenerImpactos();
        Task<List<CatalogoModel>> ObtenerUrgencias();
        Task<List<MatrizPrioridadModel>> ObtenerMatrizPrioridad();

        Task<TipoRequerimientoModel?> ObtenerTipoRequerimientoPorId(int idTipoRequerimiento);
        Task<bool> AreaRequiereSistema(int idArea);

        /// <summary>True si el tipo requiere Categoría (y, por extensión, la pregunta de Afecta_Funcionamiento).</summary>
        Task<bool> TipoRequiereCategoria(int idTipoRequerimiento);

        // ============================================================
        // DETALLE
        // ============================================================

        Task<TicketDetalleModel?> ObtenerDetalleTicket(int idTicket);

        /// <summary>Solución registrada por Soporte, para revisarla antes de confirmar o devolver.</summary>
        Task<TicketSolucionModel?> ObtenerSolucion(int idTicket);

        // ============================================================
        // CREACIÓN
        // ============================================================

        Task<int> CrearTicket(CrearTicketModel model, int idUsuarioSolicita);
        Task GuardarAdjunto(int idTicket, string nombreArchivo, string rutaArchivo, int pesoKB, int idUsuarioSube);

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
        Task<bool> UsuarioPerteneceSociedad(int idUsuario, int idSociedad);

        // ============================================================
        // PRIORIDAD Y ORDEN DE ATENCIÓN (ambos flujos)
        // ============================================================

        Task<(bool Exito, string? Mensaje)> AsignarPrioridad(int idTicket, int idPrioridad, int idUsuarioActual, int idAreaUsuarioActual);
        Task<(bool Exito, string? Mensaje)> AsignarOrdenAtencion(int idTicket, int orden, int idUsuarioActual, int idAreaUsuarioActual);

        /// <summary>Tickets del mismo usuario, con prioridad definida, aptos como motivo de pausa.</summary>
        Task<List<CatalogoModel>> ObtenerMisTicketsPropios(int idUsuario, int idTicketActual);

        // ============================================================
        // FLUJO IMPLEMENTACIÓN / MEJORA
        // ============================================================

        Task<bool> TomarLevantamiento(int idTicket, int idUsuarioAsignado);
        Task<bool> IniciarDesarrollo(int idTicket, int idUsuarioAccion);
        Task<bool> EnviarAPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> ConfirmarPruebas(int idTicket, int idUsuarioAccion);
        Task<bool> CerrarImplementacion(int idTicket, int idUsuarioAccion);

        // ============================================================
        // REASIGNACIÓN (ambos flujos)
        // ============================================================

        Task<List<CatalogoModel>> ObtenerUsuariosSoportePorArea(int idArea);
        Task<bool> ReasignarTicket(int idTicket, int idNuevoUsuario, int idUsuarioAccion);
    }
}