using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

/// <summary>
/// Lee operaciones de crédito desde PostgreSQL mediante la función
/// <c>feguslocal.obtener_operaciones_credito_lista(@id_load_local)</c>.
/// La función debe devolver columnas en minúsculas alineadas con el mapeo de esta clase.
/// </summary>
public sealed class OperacionCreditoSource : IEntitySource<OperacionCredito>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<OperacionCreditoSource> _logger;

    public OperacionCreditoSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<OperacionCreditoSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<OperacionCredito> GetDataStreamAsync(
        int idLoadLocal = 0,
        [EnumeratorCancellation] CancellationToken cancellationToken = default)
    {
        // C# disallows yield inside a try-with-catch, so we advance the enumerator
        // inside try-catch and yield the result outside.
        await using var enumerator = ReadFromDatabaseAsync(idLoadLocal, cancellationToken)
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
                _logger.Error($"Failed to stream OperacionesCredito for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<OperacionCredito> ReadFromDatabaseAsync(
        int idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);

        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_operacionescredito_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Integer)
        {
            Value = idLoadLocal
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            yield return MapRow(reader);
        }
    }

    private static OperacionCredito MapRow(NpgsqlDataReader reader)
    {
        return OperacionCredito.FromListaRow(
            idLoadLocal: GetInt64(reader, "id_load_local"),
            idOperacionCredito: GetString(reader, "idoperacioncredito"),
            tipoPersonaDeudor: GetInt32(reader, "tipopersonadeudor"),
            idDeudor: GetString(reader, "iddeudor"),
            tipoOperacionSFN: GetInt32(reader, "tipooperacionsfn"),
            tipoOperacion: GetInt32(reader, "tipooperacion"),
            tipoCatalogoSugef: GetInt32(reader, "tipocatalogosugef"),
            tipoCarteraCrediticia: GetInt32(reader, "tipocarteracrediticia"),
            codigoCategoriaRiesgo: GetInt32Nullable(reader, "codigocategoriariesgo"),
            tasaIncumplimiento: GetDecimalNullable(reader, "tasaincumplimiento"),
            lgdPromedio: GetDecimalNullable(reader, "lgdpromedio"),
            lgdRegulatorio: GetDecimalNullable(reader, "lgdregulatorio"),
            montoOperacionAutorizado: GetDecimal(reader, "montooperacionautorizado"),
            montoDesembolsado: GetDecimal(reader, "montodesembolsado"),
            saldoPrincipalOperacionCrediticia: GetDecimal(reader, "saldoprincipaloperacioncrediticia"),
            saldoProductosPorCobrar: GetDecimal(reader, "saldoproductosporcobrar"),
            ead: GetDecimal(reader, "ead"),
            tipoMonedaOperacion: GetInt32(reader, "tipomonedaoperacion"),
            fechaFormalizacion: GetDateTime(reader, "fechaformalizacion"),
            fechaVencimiento: GetDateTime(reader, "fechavencimiento"),
            diasMaximaMorosidad: GetInt32(reader, "diasmaximamorosidad"),
            montoCuotaPrincipalActual: GetDecimalNullable(reader, "montocuotaprincipalactual"),
            montoCuotaInteresesActual: GetDecimalNullable(reader, "montocuotainteresesactual"),
            tasaInteresNominalVigente: GetDecimalNullable(reader, "tasainteresnominalvigente"),
            indicadorTipoTasa: GetStringNullable(reader, "indicadortipotasa"),
            indicadorBackToBack: GetString(reader, "indicadorbacktoback", defaultIfNull: "N"),
            indicadorCreditoSindicado: GetString(reader, "indicadorcreditosindicado", defaultIfNull: "N"),
            indicadorOperacionEspecial: GetString(reader, "indicadoroperacionespecial", defaultIfNull: "N"),
            indicadorCambioClimatico: GetString(reader, "indicadorcambioclimatico", defaultIfNull: "N"),
            createdAtUtc: GetDateTime(reader, "created_at_utc"),
            updatedAtUtc: GetDateTimeNullable(reader, "updated_at_utc"));
    }

    private static long GetInt64(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return 0;
        return Convert.ToInt64(reader.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static int GetInt32(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return 0;
        return Convert.ToInt32(reader.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static int? GetInt32Nullable(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return null;
        return Convert.ToInt32(reader.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static decimal GetDecimal(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return 0m;
        return reader.GetDecimal(o);
    }

    private static decimal? GetDecimalNullable(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return null;
        return reader.GetDecimal(o);
    }

    private static string GetString(NpgsqlDataReader reader, string column, string defaultIfNull = "")
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return defaultIfNull;
        return reader.GetString(o);
    }

    private static string? GetStringNullable(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return null;
        return reader.GetString(o);
    }

    private static DateTime GetDateTime(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        return reader.GetDateTime(o);
    }

    private static DateTime? GetDateTimeNullable(NpgsqlDataReader reader, string column)
    {
        var o = reader.GetOrdinal(column);
        if (reader.IsDBNull(o)) return null;
        return reader.GetDateTime(o);
    }
}
