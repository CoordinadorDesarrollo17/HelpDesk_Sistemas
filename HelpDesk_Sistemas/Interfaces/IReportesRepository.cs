using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Interfaces
{
    public interface IReportesRepository
    {
        Task<ReporteGeneralModel> ObtenerReporteGeneral(ReporteFiltroModel filtro);
    }
}
