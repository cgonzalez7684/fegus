using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class GarantiaFacturaCedidaSource : IEntitySource<GarantiaFacturaCedida>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<GarantiaFacturaCedidaSource> _logger;

    public GarantiaFacturaCedidaSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<GarantiaFacturaCedidaSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<GarantiaFacturaCedida> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream GarantiasFacturasCedidas for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<GarantiaFacturaCedida> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_garantiasfacturascedidas_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static GarantiaFacturaCedida MapRow(NpgsqlDataReader reader) =>
        GarantiaFacturaCedida.Create(
            idLoadLocal:              GetInt64(reader,           "id_load_local"),
            idGarantiaFacturaCedida:  GetString(reader,          "idgarantiafacturacedida"),
            fechaConstitucion:        GetDateTime(reader,         "fechaconstitucion"),
            fechaVencimiento:         GetDateTimeNullable(reader, "fechavencimiento"),
            // numeric(2,0) and numeric(6,0) catalog codes â†’ string
            tipoPersona:              GetStringFromValue(reader,  "tipopersona"),
            idObligado:               GetString(reader,           "idobligado"),
            valorNominalGarantia:     GetDecimal(reader,          "valornominalgarantia"),
            tipoMonedaValorNominal:   GetStringFromValue(reader,  "tipomonedavalornominal"),
            porcentajeAjusteRc:       GetDecimal(reader,          "porcentajeajusterc"));

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

    // For numeric columns that map to string (catalog codes)
    private static string GetStringFromValue(NpgsqlDataReader r, string col, string defaultIfNull = "")
    {
        var o = r.GetOrdinal(col);
        if (r.IsDBNull(o)) return defaultIfNull;
        return Convert.ToString(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture) ?? defaultIfNull;
    }

    private static decimal GetDecimal(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0m : r.GetDecimal(o);
    }

    private static DateTime GetDateTime(NpgsqlDataReader r, string col) => r.GetDateTime(r.GetOrdinal(col));

    private static DateTime? GetDateTimeNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? null : r.GetDateTime(o);
    }
}
