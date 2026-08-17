using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IReportesService
    {
        Task<ReporteGeneralModel> ObtenerReporteGeneral(ReporteFiltroModel filtro);
        Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(ReporteFiltroModel filtro);
    }
}
