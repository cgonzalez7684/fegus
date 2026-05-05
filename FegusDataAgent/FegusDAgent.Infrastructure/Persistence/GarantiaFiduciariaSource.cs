using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class GarantiaFiduciariaSource : IEntitySource<GarantiaFiduciaria>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<GarantiaFiduciariaSource> _logger;

    public GarantiaFiduciariaSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<GarantiaFiduciariaSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<GarantiaFiduciaria> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream GarantiasFiduciarias for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<GarantiaFiduciaria> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_garantiasfiduciarias_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static GarantiaFiduciaria MapRow(NpgsqlDataReader reader) =>
        GarantiaFiduciaria.Create(
            idLoadLocal:                     GetInt64(reader,            "id_load_local"),
            idGarantiaFiduciaria:            GetString(reader,           "idgarantiafiduciaria"),
            // tipopersona is numeric(2,0) in DB â†’ converted to string
            tipoPersona:                     GetStringFromValue(reader,  "tipopersona"),
            idFiador:                        GetString(reader,           "idfiador"),
            salarioNetoFiador:               GetDecimalNullable(reader,  "salarionetofiador"),
            fechaVerificacionAsalariado:     GetDateTimeNullable(reader, "fechaverificacionasalariado"),
            montoAvalado:                    GetDecimalNullable(reader,  "montoavalado"),
            porcentajeMitigacionFondo:       GetDecimalNullable(reader,  "porcentajemitigacionfondo"),
            porcentajeEstimacionMinimoFondo: GetDecimalNullable(reader,  "porcentajeestimacionminimofondo"));

    private static long GetInt64(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0L : Convert.ToInt64(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
    }

    // For character varying columns
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

    private static decimal? GetDecimalNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? null : r.GetDecimal(o);
    }

    private static DateTime? GetDateTimeNullable(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? null : r.GetDateTime(o);
    }
}
