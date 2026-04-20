using Dapper;
using FegusDAgent.Application.Common.Models;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;

namespace FegusDAgent.Infrastructure.Persistence;

public class FegusLocalRepository : IFegusLocalRepository
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<FegusLocalRepository> _logger;

    public FegusLocalRepository(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<FegusLocalRepository> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async Task<FeBoxDataLoad> CreateBoxDataLoadLocal(
        FeBoxDataLoad dataLoad,
        CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT * from feguslocal.fn_box_data_load_insert(
                @p_id_cliente,
                @p_id_load,
                @p_state_code,
                @p_is_active,
                @p_asofdate
            );
        """;

        try
        {
            await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);

            
            var rawResult = await connection.QueryFirstAsync<BoxInsertDbRawResult>(
                new CommandDefinition(sql, new
                {
                    p_id_cliente = dataLoad.IdCliente,
                    p_id_load    = dataLoad.IdLoad,
                    p_state_code = dataLoad.StateCode,
                    p_is_active  = dataLoad.IsActive,
                    p_asofdate   = dataLoad.AsofDate
                }, cancellationToken: cancellationToken));

            var idLoadLocal = rawResult is null && !rawResult!.pidload.HasValue ? (int?)null : Convert.ToInt32(rawResult.pidload);

            if (idLoadLocal is > 0)
                dataLoad.IdLoadLocal = idLoadLocal;

            return dataLoad;
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"Failed to create local box for IdLoad={dataLoad.IdLoad}, IdCliente={dataLoad.IdCliente}.", ex);
            throw;
        }
    }
}
