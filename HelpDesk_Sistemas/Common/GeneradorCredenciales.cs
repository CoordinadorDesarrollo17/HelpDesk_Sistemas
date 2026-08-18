using System.Globalization;
using System.Text;

namespace HelpDesk_Sistemas.Common
{
    // Convención real de Cobefar para usuario/contraseña:
    //   Usuario    = nombre del rol en minúsculas + secuencial por rol (ej. "soporte3")
    //   Contraseña = 3 primeras letras del Nombre + 3 del Apellido + el mismo secuencial,
    //                todo en minúsculas y sin tildes (ej. "jhocar12").
    public static class GeneradorCredenciales
    {
        public static string GenerarUsuario(string nombreRol, int numeroSecuencial)
        {
            return $"{nombreRol.Trim().ToLowerInvariant()}{numeroSecuencial}";
        }

        public static string GenerarPassword(string nombre, string apellido, int numeroSecuencial)
        {
            return $"{Primeras3(nombre)}{Primeras3(apellido)}{numeroSecuencial}".ToLowerInvariant();
        }

        private static string Primeras3(string texto)
        {
            var limpio = QuitarTildes(texto.Trim());
            return limpio.Length <= 3 ? limpio : limpio[..3];
        }

        private static string QuitarTildes(string texto)
        {
            var descompuesto = texto.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();

            foreach (var c in descompuesto)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(c);
                }
            }

            return sb.ToString().Normalize(NormalizationForm.FormC);
        }
    }
}
