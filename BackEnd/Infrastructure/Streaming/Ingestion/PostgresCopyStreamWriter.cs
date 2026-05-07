using System;
using System.IO.Compression;
using System.Text.Json;
using Domain.Entities.Ingestion;
using Domain.Enums;
using Domain.Interfaces.Ingestion;
using Infrastructure.Ingestion.Streaming;
using Infrastructure.Interfaces;
using Infrastructure.Storage.Ingestion;
using Microsoft.Extensions.Logging;
using NLog;

namespace Infrastructure.Streaming.Ingestion;
public sealed class PostgresCopyStreamWriter : IIngestionStreamWriter
{
    private readonly IDbConnectionFactory _connectionFactory;
    private readonly TempFileStorage _storage;
    private readonly NdjsonStreamReader _reader;
    //private readonly Microsoft.Extensions.Logging.ILogger _logger;

    public PostgresCopyStreamWriter(
        IDbConnectionFactory connectionFactory,
        TempFileStorage storage,
        NdjsonStreamReader reader)
        //Microsoft.Extensions.Logging.ILogger logger)
    {
        _connectionFactory = connectionFactory;
        _storage = storage;
        _reader = reader;
        //_logger = logger;
    }

    public async Task WriteAsync(
    IngestionSession session,
    Stream stream,
    CancellationToken cancellationToken)
    {
        var copySql = GetCopySql(session.Dataset!);

        await using var conn =
            (NpgsqlConnection)await _connectionFactory
                .CreateConnectionAsync(cancellationToken);

        await using var importer =
            await conn.BeginBinaryImportAsync(copySql, cancellationToken);

        long seq = session.LastSequencePersisted;

        await using var decompressed = new GZipStream(stream, CompressionMode.Decompress, leaveOpen: true);

        await foreach (var line in _reader.ReadLinesAsync(decompressed, cancellationToken))
        {
            cancellationToken.ThrowIfCancellationRequested();

            seq++;

            await importer.StartRowAsync(cancellationToken);
            await importer.WriteAsync(session.SessionId,  NpgsqlTypes.NpgsqlDbType.Uuid,   cancellationToken);
            await importer.WriteAsync(session.IdCliente,  NpgsqlTypes.NpgsqlDbType.Integer, cancellationToken);
            await importer.WriteAsync(seq,                NpgsqlTypes.NpgsqlDbType.Bigint,  cancellationToken);
            await importer.WriteAsync(line,               NpgsqlTypes.NpgsqlDbType.Jsonb,   cancellationToken);
            await importer.WriteAsync(session.IdLoad,    NpgsqlTypes.NpgsqlDbType.Bigint,  cancellationToken);
        }

        await importer.CompleteAsync(cancellationToken);

        session.UpdateLastSequence(seq);
    }

    private static string GetCopySql(string dataset)
    {
        var table = dataset switch
        {
            // ── original datasets ────────────────────────────────────────────
            "Deudores"                     => "fe_ingestion_deudores_raw",
            "OperacionesCredito"           => "fe_ingestion_operaciones_raw",
            "GarantiasOperacion"           => "fe_ingestion_garantias_raw",

            // ── extended datasets ─────────────────────────────────────────────
            "ActividadEconomica"           => "fe_ingestion_actividadeconomica_raw",
            "BienesRealizables"            => "fe_ingestion_bienesrealizables_raw",
            "BienesRealizablesNoReportados"=> "fe_ingestion_bienesrealizablesnoreportados_raw",
            "CambioClimatico"              => "fe_ingestion_cambioclimatico_raw",
            "Codeudores"                   => "fe_ingestion_codeudores_raw",
            "CreditosSindicados"           => "fe_ingestion_creditossindicados_raw",
            "CuentasPorCobrarNoAsociadas"  => "fe_ingestion_cuentasporcobrarnosasociadas_raw",
            "Fideicomiso"                  => "fe_ingestion_fideicomiso_raw",
            "GarantiasCartasCredito"       => "fe_ingestion_garantiascartascredito_raw",
            "GarantiasFacturasCedidas"     => "fe_ingestion_garantiasfacturascedidas_raw",
            "GarantiasFiduciarias"         => "fe_ingestion_garantiasfiduciarias_raw",
            "GarantiasMobiliarias"         => "fe_ingestion_garantiasmobiliarias_raw",
            "GarantiasPolizas"             => "fe_ingestion_garantiaspolizas_raw",
            "GarantiasReales"              => "fe_ingestion_garantiasreales_raw",
            "GarantiasValores"             => "fe_ingestion_garantiasvalores_raw",
            "Gravamenes"                   => "fe_ingestion_gravamenes_raw",
            "IngresoDeudores"              => "fe_ingestion_ingresodeudores_raw",
            "Modificacion"                 => "fe_ingestion_modificacion_raw",
            "NaturalezaGasto"              => "fe_ingestion_naturalezagasto_raw",
            "OperacionesBienesRealizables" => "fe_ingestion_operacionesbienesrealizables_raw",
            "OperacionesCompradas"         => "fe_ingestion_operacionescompradas_raw",
            "OperacionesNoReportadas"      => "fe_ingestion_operacionesnoreportadas_raw",
            "OrigenRecursos"               => "fe_ingestion_origenrecursos_raw",

            _ => throw new NotSupportedException($"Dataset '{dataset}' is not supported.")
        };

        return $"""
            COPY fegusconfig.{table}
            (session_id, id_cliente, seq, payload, id_load)
            FROM STDIN (FORMAT BINARY)
        """;
    }

}