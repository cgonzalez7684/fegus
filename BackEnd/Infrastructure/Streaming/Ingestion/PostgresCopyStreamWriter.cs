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
        if (dataset == DataSetNameIngestion.Deudores.Value)
            return """
                COPY fegusconfig.fe_ingestion_deudores_raw
                (session_id, id_cliente, seq, payload, id_load)
                FROM STDIN (FORMAT BINARY)
            """;

        if (dataset == DataSetNameIngestion.OperacionesCredito.Value)
            return """
                COPY fegusconfig.fe_ingestion_operaciones_raw
                (session_id, id_cliente, seq, payload, id_load)
                FROM STDIN (FORMAT BINARY)
            """;

        if (dataset == DataSetNameIngestion.GarantiasOperacion.Value)
            return """
                COPY fegusconfig.fe_ingestion_garantias_raw
                (session_id, id_cliente, seq, payload, id_load)
                FROM STDIN (FORMAT BINARY)
            """;

        throw new NotSupportedException($"Dataset '{dataset}' is not supported.");
    }

}