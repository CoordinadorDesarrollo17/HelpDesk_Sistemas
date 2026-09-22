namespace HelpDesk_Sistemas.Common
{
    // Muestra duraciones como "1h 12m" en vez de horas decimales (1.2), que se
    // prestan a confusión (1.2 no es 1 h 20 min). Sin valor -> "-".
    public static class FormatoDuracion
    {
        public static string DesdeHoras(decimal? horas) =>
            horas.HasValue ? DesdeMinutos((int)Math.Round(horas.Value * 60m)) : "-";

        public static string DesdeMinutos(int? minutos)
        {
            if (!minutos.HasValue) return "-";

            var total = Math.Max(0, minutos.Value);
            var h = total / 60;
            var m = total % 60;

            if (h == 0) return $"{m}m";
            return m == 0 ? $"{h}h" : $"{h}h {m:00}m";
        }
    }
}
