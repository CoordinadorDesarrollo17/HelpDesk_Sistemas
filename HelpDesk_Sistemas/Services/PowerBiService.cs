using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;

namespace HelpDesk_Sistemas.Services
{
    public class PowerBiService : IPowerBiService
    {
        private readonly IPowerBiRepository powerBiRepository;

        public PowerBiService(IPowerBiRepository powerBiRepository)
        {
            this.powerBiRepository = powerBiRepository;
        }

        public Task<List<PowerBiTicketModel>> ObtenerTickets(DateTime? fechaInicio, DateTime? fechaFin)
        {
            return powerBiRepository.ObtenerTickets(fechaInicio, fechaFin);
        }

        public Task<List<PowerBiDepartamentoModel>> ObtenerDepartamentos()
        {
            return powerBiRepository.ObtenerDepartamentos();
        }

        public Task<List<PowerBiAreaModel>> ObtenerAreas()
        {
            return powerBiRepository.ObtenerAreas();
        }

        public Task<List<CatalogoModel>> ObtenerSociedades()
        {
            return powerBiRepository.ObtenerSociedades();
        }

        public Task<List<PowerBiTipoAtencionModel>> ObtenerTiposAtencion()
        {
            return powerBiRepository.ObtenerTiposAtencion();
        }

        public Task<List<PowerBiCategoriaModel>> ObtenerCategorias()
        {
            return powerBiRepository.ObtenerCategorias();
        }

        public Task<List<CatalogoModel>> ObtenerSistemas()
        {
            return powerBiRepository.ObtenerSistemas();
        }

        public Task<List<CatalogoModel>> ObtenerEstados()
        {
            return powerBiRepository.ObtenerEstados();
        }

        public Task<List<CatalogoModel>> ObtenerPrioridades()
        {
            return powerBiRepository.ObtenerPrioridades();
        }

        public Task<List<PowerBiUsuarioModel>> ObtenerUsuarios()
        {
            return powerBiRepository.ObtenerUsuarios();
        }
    }
}
