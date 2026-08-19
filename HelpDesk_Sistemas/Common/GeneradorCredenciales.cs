using System.Globalization;
using System.Text;

namespace HelpDesk_Sistemas.Common
{
    // Convención real de la empresa para usuario/contraseña:
    //   Usuario    = prefijo del área (Área.Prefijo) en minúsculas + secuencial por
    //                prefijo (ej. Prefijo "MANAGER" -> "manager3"). El Rol de
    //                HelpDesk NO participa: solo define permisos, no el usuario.
    //   Contraseña = 3 primeras letras del Nombre + 3 del Apellido + el mismo secuencial,
    //                todo en minúsculas y sin tildes (ej. "jhocar12").
    public static class GeneradorCredenciales
    {
        public static string GenerarUsuario(string prefijoArea, int numeroSecuencial)
        {
            return $"{prefijoArea.Trim().ToLowerInvariant()}{numeroSecuencial}";
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
