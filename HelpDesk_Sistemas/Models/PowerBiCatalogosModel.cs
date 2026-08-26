namespace HelpDesk_Sistemas.Models
{
    // Modelos de dimensión para la API de Power BI. Los catálogos simples (Sociedad,
    // Sistema, Estado, Prioridad) reutilizan CatalogoModel (Id, Nombre); estos son los
    // que necesitan campos propios o su jerarquía padre.

    public class PowerBiDepartamentoModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Prefijo { get; set; } = string.Empty;
    }

    public class PowerBiAreaModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int? IdDepartamento { get; set; }
        public string? Departamento { get; set; }
        public bool EsAreaSistemas { get; set; }
        public bool RequiereSistema { get; set; }
    }

    public class PowerBiTipoAtencionModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Area { get; set; } = string.Empty;
        public string Flujo { get; set; } = string.Empty;
        public bool UsaImpactoUrgencia { get; set; }
    }

    public class PowerBiCategoriaModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string TipoAtencion { get; set; } = string.Empty;
        public string Area { get; set; } = string.Empty;
    }

    public class PowerBiUsuarioModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public string Usuario { get; set; } = string.Empty;
        public string Rol { get; set; } = string.Empty;
        public string Area { get; set; } = string.Empty;
        public string? Departamento { get; set; }
        public string? Sociedades { get; set; }
        public bool Activo { get; set; }
    }
}
