using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class GarantiaValorSource : IEntitySource<GarantiaValor>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<GarantiaValorSource> _logger;

    public GarantiaValorSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<GarantiaValorSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<GarantiaValor> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream GarantiasValores for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<GarantiaValor> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_garantiasvalores_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static GarantiaValor MapRow(NpgsqlDataReader reader) =>
        GarantiaValor.Create(
            idLoadLocal:                  GetInt64(reader,                   "id_load_local"),
            idGarantiaValor:              GetString(reader,                  "idgarantiavalor"),
            // numeric(1,0) columns â†’ string catalog codes
            tipoClasificacionInstrumento: GetStringFromValue(reader,         "tipoclasificacioninstrumento"),
            tipoPersona:                  GetStringFromValueNullable(reader,  "tipopersona"),
            idEmisor:                     GetStringNullable(reader,           "idemisor"),
            idInstrumento:                GetString(reader,                   "idinstrumento"),
            serieInstrumento:             GetStringNullable(reader,           "serieinstrumento"),
            premio:                       GetDecimalNullable(reader,          "premio"),
            codigoIsin:                   GetString(reader,                   "codigoisin"),
            tipoAsignacionCalificacion:   GetStringFromValue(reader,          "tipoasignacioncalificacion"),
            categoriaCalificacion:        GetStringFromValueNullable(reader,  "categoriacalificacion"),
            codigoCalificacionRiesgo:     GetStringNullable(reader,           "codigocalificacionriesgo"),
            codigoEmpresaCalificadora:    GetStringFromValueNullable(reader,  "codigoempresacalificadora"),
            valorFacial:                  GetDecimalNullable(reader,          "valorfacial"),
            tipoMonedaValorFacial:        GetStringFromValueNullable(reader,  "tipomonedavalorfacial"),
            valorMercado:                 GetDecimal(reader,                  "valormercado"),
            tipoMonedaValorMercado:       GetStringFromValueNullable(reader,  "tipomonedavalormercado"),
            fechaConstitucion:            GetDateTime(reader,                 "fechaconstitucion"),
            fechaVencimiento:             GetDateTimeNullable(reader,         "fechavencimiento"),
            tipoColateralFinanciero:      GetStringFromValue(reader,          "tipocolateralfinanciero"),
            codigoCalificacionInstrumento: GetStringFromValue(reader,         "codigocalificacioninstrumento"),
            porcentajeAjusteRc:           GetDecimal(reader,                  "porcentajeajusterc"));

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

    private static decimal? GetDecimalNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? null : r.GetDecimal(o);
    }

    private static DateTime GetDateTime(NpgsqlDataReader r, string col) => r.GetDateTime(r.GetOrdinal(col));

    private static DateTime? GetDateTimeNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? null : r.GetDateTime(o);
    }
}
