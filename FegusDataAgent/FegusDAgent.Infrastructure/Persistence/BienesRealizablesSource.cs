using System.Runtime.CompilerServices;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public sealed class BienesRealizablesSource : IEntitySource<BienesRealizables>
{
    private readonly IDbConnectionFactory _dbConnectionFactory;
    private readonly IEventLogger<BienesRealizablesSource> _logger;

    public BienesRealizablesSource(
        IDbConnectionFactory dbConnectionFactory,
        IEventLogger<BienesRealizablesSource> logger)
    {
        _dbConnectionFactory = dbConnectionFactory;
        _logger = logger;
    }

    public async IAsyncEnumerable<BienesRealizables> GetDataStreamAsync(
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
                _logger.Error($"Failed to stream BienesRealizables for idLoadLocal={idLoadLocal}.", ex);
                throw;
            }

            if (!hasNext) break;
            yield return enumerator.Current;
        }
    }

    private async IAsyncEnumerable<BienesRealizables> ReadFromDatabaseAsync(
        int? idCliente,
        long? idLoadLocal,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);
        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT *
            FROM feguslocal.obtener_bienesrealizables_lista(@id_load_local)
            """;

        command.Parameters.Add(new NpgsqlParameter("id_load_local", NpgsqlDbType.Bigint)
        {
            Value = idLoadLocal.HasValue ? (object)idLoadLocal.Value : DBNull.Value
        });

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
            yield return MapRow(reader);
    }

    private static BienesRealizables MapRow(NpgsqlDataReader reader) =>
        BienesRealizables.Create(
            idLoadLocal:                             GetInt64(reader,    "id_load_local"),
            tipoAdquisicionBien:                     GetString(reader,   "tipoadquisicionbien"),
            idBienRealizable:                        GetString(reader,   "idbienrealizable"),
            indicadorGarantia:                       GetString(reader,   "indicadorgarantia"),
            idGarantia:                              GetString(reader,   "idgarantia"),
            idBien:                                  GetString(reader,   "idbien"),
            tipoBien:                                GetString(reader,   "tipobien"),
            fechaAdjudicacionDacionBien:             GetDateTime(reader, "fechaadjudicaciondacionbien"),
            saldoRegistroContable:                   GetDecimal(reader,  "saldoregistrocontable"),
            tipoMonedaSaldoRegistroContable:         GetString(reader,   "tipomonedasaldoregistrocontable"),
            cuentaCatalogoSugef:                     GetString(reader,   "cuentacatalogosugef"),
            tipoCatalogoSugef:                       GetString(reader,   "tipocatalogosugef"),
            fechaUltimaTasacionBien:                 GetDateTime(reader, "fechaultimatasacionbien"),
            montoUltimaTasacion:                     GetDecimal(reader,  "montoultimatasacion"),
            tipoMonedaMontoAvaluo:                   GetString(reader,   "tipomonedamontoavaluo"),
            tipoPersonaTasador:                      GetString(reader,   "tipopersonatasador"),
            idTasador:                               GetString(reader,   "idtasador"),
            tipoPersonaEmpresaTasadora:              GetString(reader,   "tipopersonaempresatasadora"),
            idEmpresaTasadora:                       GetString(reader,   "idempresatasadora"),
            saldoContableCreditoCancelado:           GetDecimal(reader,  "saldocontablecreditocancelado"),
            tipoMonedaSaldoContableCreditoCancelado: GetString(reader,   "tipomonedasaldocontablecreditocancelado"),
            montoEstimacion:                         GetDecimal(reader,  "montoestimacion"));

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

    private static DateTime GetDateTime(NpgsqlDataReader r, string col) => r.GetDateTime(r.GetOrdinal(col));
}
