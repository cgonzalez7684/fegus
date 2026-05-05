using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class GarantiaRealSource : IEntitySource<GarantiaReal>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<GarantiaRealSource> _logger;

    public GarantiaRealSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<GarantiaRealSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<GarantiaReal> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream GarantiasReales for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<GarantiaReal> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_garantiasreales_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static GarantiaReal MapRow(NpgsqlDataReader reader) =>
        GarantiaReal.Create(
            idLoadLocal:                       GetInt64(reader,                  "id_load_local"),
            idGarantiaReal:                    GetString(reader,                 "idgarantiareal"),
            // numeric catalog codes â†’ string
            tipoBienGarantiaReal:              GetStringFromValue(reader,        "tipobiengarantiareal"),
            montoUltimaTasacionTerreno:        GetDecimal(reader,                "montoultimatasacionterreno"),
            montoUltimaTasacionNoTerreno:      GetDecimal(reader,                "montoultimatasacionnoterreno"),
            fechaUltimaTasacionGarantia:       GetDateTime(reader,               "fechaultimatasaciongarantia"),
            fechaUltimoSeguimientoGarantia:    GetDateTime(reader,               "fechaultimoseguimientogarantia"),
            tipoMonedaTasacion:                GetStringFromValue(reader,        "tipomonedatasacion"),
            fechaConstruccion:                 GetDateTimeNullable(reader,        "fechaconstruccion"),
            tipoPersonaTasador:                GetStringFromValue(reader,        "tipopersonatasador"),
            idTasador:                         GetString(reader,                 "idtasador"),
            tipoPersonaEmpresaTasadora:        GetStringFromValueNullable(reader, "tipopersonaempresatasadora"),
            idEmpresaTasadora:                 GetStringNullable(reader,          "idempresatasadora"),
            indicadorPolizaGarantiaReal:       GetString(reader,                 "indicadorpolizagarantiareal"),
            tipoColateralReal:                 GetStringFromValue(reader,        "tipocolateralreal"),
            porcentajeRecuperacionColateralReal: GetDecimal(reader,              "porcentajerecuperacioncolateralreal"),
            tiempo:                            GetDecimal(reader,                "tiempo"),
            porcentajeFactorDescuentoTiempo:   GetDecimal(reader,                "porcentajefactordescuentotiempo"));

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

    private static string? GetStringNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? null : r.GetString(o);
    }

    // For numeric columns that map to string (catalog codes)
    private static string GetStringFromValue(NpgsqlDataReader r, string col, string defaultIfNull = "")
    {
        var o = r.GetOrdinal(col);
        if (r.IsDBNull(o)) return defaultIfNull;
        return Convert.ToString(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture) ?? defaultIfNull;
    }

    private static string? GetStringFromValueNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        if (r.IsDBNull(o)) return null;
        return Convert.ToString(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
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
