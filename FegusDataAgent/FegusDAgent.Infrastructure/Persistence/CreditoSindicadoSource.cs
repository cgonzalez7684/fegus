using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class CreditoSindicadoSource : IEntitySource<CreditoSindicado>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<CreditoSindicadoSource> _logger;

    public CreditoSindicadoSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<CreditoSindicadoSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<SourceRecord<CreditoSindicado>> GetDataStreamAsync(
        int? idCliente,
        long? idLoadLocal,
        long lastSeq,
        [EnumeratorCancellation] CancellationToken cancellationToken = default)
    {
        await using var enumerator = ReadFromDatabaseAsync(idCliente, idLoadLocal, lastSeq, cancellationToken)
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
                _logger.Error($"Failed to stream CreditosSindicados for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<SourceRecord<CreditoSindicado>> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        long lastSeq,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_creditossindicados_lista(@id_load_local, @last_seq)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });
        command.Parameters.Add(new NpgsqlParameter("last_seq", NpgsqlDbType.Bigint) { Value = lastSeq });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return new SourceRecord<CreditoSindicado>(reader.GetInt64(reader.GetOrdinal("seq")), MapRow(reader));
    }

    private static CreditoSindicado MapRow(NpgsqlDataReader reader) =>
        CreditoSindicado.Create(
            idLoadLocal:                               GetInt64(reader,  "id_load_local"),
            idOperacionCredito:                        GetString(reader, "idoperacioncredito"),
            tipoPersona:                               GetString(reader, "tipopersona"),
            identidadCreditoSindicado:                 GetString(reader, "identidadcreditosindicado"),
            idOperacionCreditoEntidadCreditoSindicado: GetString(reader, "idoperacioncreditoentidadcreditosindicado"));

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
}
