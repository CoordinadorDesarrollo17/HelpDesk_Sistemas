using Dapper;
using HelpDesk_Sistemas.Repositories;
using Microsoft.Data.SqlClient;

namespace HelpDesk_Sistemas.Services
{
    /// <summary>
    /// Corre sp_SLA_ActualizarEstados periódicamente para marcar advertencia/incumplimiento
    /// de los SLA en curso. No depende de SQL Server Agent (no siempre está activo en cada
    /// instancia) — el propio proceso web hace de motor. Ver Database/Sla/05_StoredProcedures.sql.
    /// </summary>
    public class SlaEngineBackgroundService : BackgroundService
    {
        private static readonly TimeSpan Intervalo = TimeSpan.FromMinutes(2);

        private readonly DapperContext dapperContext;
        private readonly ILogger<SlaEngineBackgroundService> logger;

        public SlaEngineBackgroundService(DapperContext dapperContext, ILogger<SlaEngineBackgroundService> logger)
        {
            this.dapperContext = dapperContext;
            this.logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            using var timer = new PeriodicTimer(Intervalo);

            do
            {
                try
                {
                    using var xCon = new SqlConnection(dapperContext.connectionString);
                    await xCon.ExecuteAsync("EXEC sp_SLA_ActualizarEstados;");
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Error ejecutando sp_SLA_ActualizarEstados.");
                }
            }
            while (await timer.WaitForNextTickAsync(stoppingToken));
        }
    }
}
