namespace HelpDesk_Sistemas.Models
{
    public class FiltrosTicketsModel
    {
        public string Buscar { get; set; }
        public int? IdEstado { get; set; }
        public int? IdArea { get; set; }
        public int? IdTipoRequerimiento { get; set; }
        public int? IdPrioridad { get; set; }

        // Filtros "compuestos" que no se pueden expresar con IdEstado solo (agrupan
        // varios estados, o cruzan con el usuario actual). Vienen de las tarjetas KPI
        // de Home/Reportes, que enlazan aquí en vez de filtrar en su propia página.
        // Valores: "en-curso", "mis-asignados", "cerrados", "activos".
        public string? Categoria { get; set; }

        // Igual que en Reportes: filtra por Fecha_Creacion, para que las tarjetas de
        // ese módulo (que sí están acotadas a un rango de fechas) enlacen aquí con el
        // mismo período exacto que muestran.
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }

        public PaginacionModel Paginacion { get; set; } = new();
    }
}
