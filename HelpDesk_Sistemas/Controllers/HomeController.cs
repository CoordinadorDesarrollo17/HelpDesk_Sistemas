using System.Diagnostics;
using HelpDesk_Sistemas.Common;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.AspNetCore.Mvc;

namespace HelpDesk_Sistemas.Controllers
{
    public class HomeController : Controller
    {
        private readonly ITicketsService ticketsService;
        private readonly ISlaService slaService;

        public HomeController(ITicketsService ticketsService, ISlaService slaService)
        {
            this.ticketsService = ticketsService;
            this.slaService = slaService;
        }

        public async Task<IActionResult> Index()
        {
            var resumenTickets = await ticketsService.ObtenerResumen(SesionTemporal.UsuarioActualTemporal);
            var dashboardSla = await slaService.ObtenerDashboard();

            var model = new HomeIndexModel
            {
                Tickets = resumenTickets,
                Sla = dashboardSla.Resumen,
                SlaEnRiesgo = dashboardSla.EnRiesgoOIncumplidos.Take(5).ToList()
            };

            return View(model);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
