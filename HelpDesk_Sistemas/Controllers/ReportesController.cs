using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    [Authorize(Roles = "Administrador")]
    public class ReportesController : Controller
    {
        private readonly IReportesService reportesService;
        private readonly ITicketsService ticketsService;

        public ReportesController(IReportesService reportesService, ITicketsService ticketsService)
        {
            this.reportesService = reportesService;
            this.ticketsService = ticketsService;
        }

        public async Task<IActionResult> Index(ReporteFiltroModel filtro)
        {
            var reporte = await reportesService.ObtenerReporteGeneral(filtro);
            ViewBag.Filtro = filtro;
            ViewBag.AreasSoporte = await ticketsService.ObtenerAreasSistemas();
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
