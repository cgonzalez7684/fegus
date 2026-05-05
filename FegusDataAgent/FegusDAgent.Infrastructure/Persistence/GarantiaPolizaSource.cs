using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class GarantiaPolizaSource : IEntitySource<GarantiaPoliza>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<GarantiaPolizaSource> _logger;

    public GarantiaPolizaSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<GarantiaPolizaSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<GarantiaPoliza> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream GarantiasPolizas for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<GarantiaPoliza> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_garantiaspolizas_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static GarantiaPoliza MapRow(NpgsqlDataReader reader) =>
        GarantiaPoliza.Create(
            idLoadLocal:               GetInt64(reader,          "id_load_local"),
            idGarantia:                GetString(reader,          "idgarantia"),
            // numeric(5,0) and numeric(2,0) catalog codes â†’ string
            tipoGarantia:              GetStringFromValue(reader, "tipogarantia"),
            tipoBienGarantia:          GetStringFromValue(reader, "tipobiengarantia"),
            tipoPoliza:                GetStringFromValue(reader, "tipopoliza"),
            montoPoliza:               GetDecimal(reader,         "montopoliza"),
            fechaVencimientoPoliza:    GetDateTime(reader,        "fechavencimientopoliza"),
            indicadorCoberturasPoliza: GetString(reader,          "indicadorcoberturaspoliza"),
            tipoPersonaBeneficiario:   GetStringFromValue(reader, "tipopersonabeneficiario"),
            idBeneficiario:            GetString(reader,          "idbeneficiario"));

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
}
