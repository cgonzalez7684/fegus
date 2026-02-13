using System;
using System.Text.Json;
using Domain.Entities.Ingestion;
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
        await using var conn =
            (NpgsqlConnection)await _connectionFactory
                .CreateConnectionAsync(cancellationToken);

        const string copySql = """
            COPY fegusdata.ingestion_deudores_raw
            (session_id, id_cliente, seq, payload)
            FROM STDIN (FORMAT BINARY)
        """;

        await using var importer =
            await conn.BeginBinaryImportAsync(copySql, cancellationToken);

        long seq = session.LastSequencePersisted;

        await foreach (var line in _reader.ReadLinesAsync(stream, cancellationToken))
        {
            cancellationToken.ThrowIfCancellationRequested();

            seq++;

            await importer.StartRowAsync(cancellationToken);
            await importer.WriteAsync(session.SessionId, cancellationToken);
            await importer.WriteAsync(session.IdCliente, cancellationToken);
            await importer.WriteAsync(seq, cancellationToken);
            await importer.WriteAsync(line, NpgsqlTypes.NpgsqlDbType.Jsonb, cancellationToken);
        }

        await importer.CompleteAsync(cancellationToken);

        /*try
        {
            await importer.CompleteAsync(cancellationToken);
        }
        catch (PostgresException ex)
        {
            _logger.LogError(
                "COPY error: SqlState={SqlState}, Message={Message}, Detail={Detail}",
                ex.SqlState,
                ex.MessageText,
                ex.Detail);

            throw;
        }*/

        session.UpdateLastSequence(seq);
    }
}