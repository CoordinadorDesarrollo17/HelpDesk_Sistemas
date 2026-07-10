using Dapper;
using DocumentFormat.OpenXml.InkML;
using HelpDesk_Sistemas.Interfaces;
using HelpDesk_Sistemas.Models;
using Microsoft.Data.SqlClient;
using System.Data;
using X.PagedList;
using X.PagedList.Extensions;

namespace HelpDesk_Sistemas.Repositories
{
    public class ClientesRepository : IClientesRepository
    {
        private readonly DapperContext dapperContext;

        public ClientesRepository(DapperContext dapperContext)
        {
            this.dapperContext = dapperContext;
        }

        public async Task<IEnumerable<ClientesModel>> ObtenerClientes(FiltrosClientesModel model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"     
                        SELECT TOP 200 Nombre,Apellido,Telefono,Email FROM Clientes
                        WHERE CONCAT(Nombre,Apellido,Telefono,Email) LIKE @Buscar
                    ";

            var result = await xCon.QueryAsync<ClientesModel>(sql, new { Buscar = "%" + model.Buscar + "%" });

            return result;
        }
        public async Task<IPagedList<ClientesModel>> ListadoClientes(FiltrosClientesModel model)
        {
            var result = await ObtenerClientes(model);
            return result.ToPagedList(model.Paginacion.Page, model.Paginacion.PageSize);
        }

        public async Task<List<ClientesModel>> ListadoClientesExcel(FiltrosClientesModel model)
        {
            var result = await ObtenerClientes(model);
            return result.ToList();
        }

        public async Task<int> CrearCliente(ClientesModel model)
        {
            using var xCon = new SqlConnection(dapperContext.connectionString);

            var sql = @"
                INSERT INTO Clientes (Nombre, Apellido, Telefono, Email)
                VALUES (@Nombre, @Apellido, @Telefono, @Email);
                SELECT CAST(SCOPE_IDENTITY() AS int);
            ";

            var id = await xCon.QuerySingleAsync<int>(sql,model);

            return id;
        }
    }
}
