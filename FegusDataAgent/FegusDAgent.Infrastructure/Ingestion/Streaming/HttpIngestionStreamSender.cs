using System;
using System.IO.Compression;
using System.Net.Http.Headers;
using System.Text.Json;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Infrastructure.Ingestion.Streaming;

public sealed class HttpIngestionStreamSender : IIngestionStreamSender
{
    private readonly HttpClient _httpClient;

    public HttpIngestionStreamSender(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task StreamAsync<T>(
        IngestionSession session,
        IAsyncEnumerable<T> data,
        long startSequence,
        CancellationToken cancellationToken)
    {
        var producer = new ProducerStream();

        var content = new StreamContent(producer.Reader);
        content.Headers.ContentType =
            new MediaTypeHeaderValue("application/x-ndjson");
        content.Headers.ContentEncoding.Add("gzip");

        // 1️⃣ Lanzamos el POST
        var postTask = _httpClient.PostAsync(
            session.UploadUrl,
            content,
            cancellationToken);

        // 2️⃣ Escribimos el stream
        await WriteStreamAsync(
            producer,
            data,
            startSequence,
            cancellationToken);

        // 3️⃣ Esperamos la respuesta HTTP
        var response = await postTask;
        response.EnsureSuccessStatusCode();
    }

    private static async Task WriteStreamAsync<T>(
        ProducerStream producer,
        IAsyncEnumerable<T> data,
        long startSequence,
        CancellationToken ct)
    {
        await using var gzip = new GZipStream(
            producer.Writer,
            CompressionLevel.Fastest,
            leaveOpen: false);

        await using var writer = new StreamWriter(gzip);

        long seq = startSequence;

        await foreach (var item in data.WithCancellation(ct))
        {
            var line = JsonSerializer.Serialize(new
            {
                seq = ++seq,
                data = item
            });

            await writer.WriteLineAsync(line);
        }
    }
}
