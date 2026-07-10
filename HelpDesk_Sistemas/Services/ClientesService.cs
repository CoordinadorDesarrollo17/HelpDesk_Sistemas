using ClosedXML.Excel;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using X.PagedList;

namespace HelpDesk_Sistemas.Services
{
    public class ClientesService : IClientesService
    {
        private readonly IClientesRepository clientesRepository;

        public ClientesService(IClientesRepository clientesRepository)
        {
            this.clientesRepository = clientesRepository;
        }

        public async Task<IPagedList<ClientesModel>> ListadoClientes(FiltrosClientesModel model)
        {
            return await clientesRepository.ListadoClientes(model);
        }

        public async Task<(byte[] Content, string ContentType, string FileName)> ExportarExcelAsync(FiltrosClientesModel model)
        {
            var lista = await clientesRepository.ListadoClientesExcel(model);

            using var workbook = new XLWorkbook();
            var ws = workbook.Worksheets.Add("Clientes");

            // CABECERAS
            ws.Cell(1, 1).Value = "Nombre";
            ws.Cell(1, 2).Value = "Apellido";
            ws.Cell(1, 3).Value = "Teléfono";
            ws.Cell(1, 4).Value = "Email";

            ws.Range("A1:E1").Style.Font.Bold = true;

            int row = 2;
            foreach (var x in lista)
            {
                ws.Cell(row, 1).Value = x.Nombre;
                ws.Cell(row, 2).Value = x.Apellido;
                ws.Cell(row, 3).Value = x.Telefono;
                ws.Cell(row, 4).Value = x.Email;
                row++;
            }
            ws.Columns().AdjustToContents();
            ws.SheetView.FreezeRows(1);
            ws.Cells().Style.Border.OutsideBorder = XLBorderStyleValues.None;
            ws.Cells().Style.Border.InsideBorder = XLBorderStyleValues.None;
            ws.ShowGridLines = false;

            using var stream = new MemoryStream();
            workbook.SaveAs(stream);

            var content = stream.ToArray();
            var fileName = $"Clientes_{DateTime.Now:yyyyMMddHHmm}.xlsx";
            var contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            return (content, contentType, fileName);
        }

        public async Task<bool> CrearCliente(ClientesModel model)
        {
            var id = await clientesRepository.CrearCliente(model);
            return id > 0;
        }
    }
}
