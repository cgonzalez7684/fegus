using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class CuentaPorCobrarSource : IEntitySource<CuentaPorCobrar>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<CuentaPorCobrarSource> _logger;

    public CuentaPorCobrarSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<CuentaPorCobrarSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<CuentaPorCobrar> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream CuentasPorCobrar for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<CuentaPorCobrar> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_cuentasxcobrar_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static CuentaPorCobrar MapRow(NpgsqlDataReader reader) =>
        CuentaPorCobrar.Create(
            idLoadLocal:                          GetInt64(reader,    "id_load_local"),
            idOperacionCredito:                   GetString(reader,   "idoperacioncredito"),
            idCuentaCobrarAsociada:               GetString(reader,   "idcuentacobrarasociada"),
            cuentaContableCuentaCobrarAsociada:   GetString(reader,   "cuentacontablecuentacobrarasociada"),
            tipoCatalogoSugef:                    GetString(reader,   "tipocatalogosugef"),
            saldoCuentaCobrarAsociada:            GetDecimal(reader,  "saldocuentacobrarasociada"),
            tipoMonedaCuentaCobrarAsociada:       GetString(reader,   "tipomonedacuentacobrarasociada"),
            diasAtrasoCuentaCobrarAsociada:       GetInt32(reader,    "diasatrasocuentacobrarasociada"),
            fechaRegistroCuentaCobrarAsociada:    GetDateTime(reader, "fecharegistrocuentacobrarasociada"),
            fechaVencimientoCuentaCobrarAsociada: GetDateTime(reader, "fechavencimientocuentacobrarasociada"),
            concepto:                             GetStringNullable(reader, "concepto"));

    private static long GetInt64(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0L : Convert.ToInt64(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
    }

    private static int GetInt32(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0 : Convert.ToInt32(r.GetValue(o), System.Globalization.CultureInfo.InvariantCulture);
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

    private static decimal GetDecimal(NpgsqlDataReader r, string col)
    {
        var o = r.GetOrdinal(col);
        return r.IsDBNull(o) ? 0m : r.GetDecimal(o);
    }

    private static DateTime GetDateTime(NpgsqlDataReader r, string col) => r.GetDateTime(r.GetOrdinal(col));
}
