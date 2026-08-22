namespace HelpDesk_Sistemas.Models
{
    /// <summary>
    /// Área con su Prefijo, usada solo internamente al crear un usuario para
    /// generar el Usuario/Password (ej. Prefijo "MANAGER" -> "manager3").
    /// El combo de Área en las vistas sigue usando CatalogoModel (Id/Nombre),
    /// que no necesita conocer el prefijo.
    /// </summary>
    public class AreaModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Prefijo { get; set; }

        /// <summary>True para las 3 áreas de soporte (TI/Sistemas/Desarrollo) que enrutan tickets.</summary>
        public bool EsAreaSistemas { get; set; }

        /// <summary>True solo para Soporte Sistemas / Soporte Desarrollo — piden el campo Sistema al crear ticket.</summary>
        public bool RequiereSistema { get; set; }
    }
}
