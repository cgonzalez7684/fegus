using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class CambioClimaticoSource : IEntitySource<CambioClimatico>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<CambioClimaticoSource> _logger;

    public CambioClimaticoSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<CambioClimaticoSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<CambioClimatico> GetDataStreamAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken = default)
    {
        await using var enumerator = ReadFromDatabaseAsync(idCliente, idLoadLocal, cancellationToken)
            .GetAsyncEnumerator(cancellationToken);

        while (true)
        {
            bool hasNext;
            try
            {
                hasNext = await enumerator.MoveNextAsync();
            }
            catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.Error($"Failed to stream CambioClimatico for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<CambioClimatico> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_cambioclimatico_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static CambioClimatico MapRow(NpgsqlDataReader reader) =>
        CambioClimatico.Create(
            idLoadLocal:              GetInt64(reader,   "id_load_local"),
            idOperacionCredito:       GetString(reader,  "idoperacioncredito"),
            tipoTema:                 GetString(reader,  "tipotema"),
            tipoSubtema:              GetString(reader,  "tiposubtema"),
            tipoActividad:            GetString(reader,  "tipoactividad"),
            tipoAmbito:               GetString(reader,  "tipoambito"),
            tipoFuenteFinanciamiento: GetString(reader,  "tipofuentefinanciamiento"),
            tipoFondoFinanciamiento:  GetString(reader,  "tipofondofinanciamiento"),
            saldoMontoClimatico:      GetDecimal(reader, "saldomontoclimatico"),
            codigoModalidad:          GetString(reader,  "codigomodalidad"));

    private static long GetInt64(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0L : Convert.ToInt64(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static string GetString(NpgsqlDataReader r, string col, string defaultIfNull = "")
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? defaultIfNull : r.GetString(o);
    }

    private static decimal GetDecimal(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0m : r.GetDecimal(o);
    }
}
