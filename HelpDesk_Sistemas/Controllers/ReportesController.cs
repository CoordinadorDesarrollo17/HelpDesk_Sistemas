using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    public class ReportesController : Controller
    {
        private readonly IReportesService reportesService;

        public ReportesController(IReportesService reportesService)
        {
            this.reportesService = reportesService;
        }

        public async Task<IActionResult> Index(ReporteFiltroModel filtro)
        {
            var reporte = await reportesService.ObtenerReporteGeneral(filtro);
            ViewBag.Filtro = filtro;
            return View(reporte);
        }

        [HttpGet]
        public async Task<IActionResult> ExportarExcel(ReporteFiltroModel filtro)
        {
            var file = await reportesService.ExportarExcelAsync(filtro);
            return File(file.Content, file.ContentType, file.FileName);
        }
    }
}
