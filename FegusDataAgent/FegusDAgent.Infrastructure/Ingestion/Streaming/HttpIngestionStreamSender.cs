using System.IO.Compression;
using System.Net.Http.Headers;
using System.Text.Json;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;
using Microsoft.Extensions.Options;

namespace FegusDAgent.Infrastructure.Ingestion.Streaming;

public sealed class HttpIngestionStreamSender : IIngestionStreamSender
{
    private readonly HttpClient _httpClient;
    private readonly IEventLogger<HttpIngestionStreamSender> _logger;
    private readonly IngestionApiOptions _options;


    public HttpIngestionStreamSender(
        HttpClient httpClient,
        IEventLogger<HttpIngestionStreamSender> logger,
        IOptions<IngestionApiOptions> options)
    {
        _httpClient = httpClient;
        _logger = logger;
        _options = options.Value;

    }

    public async Task SendStreamAsync<T>(
        IngestionSession session,
        IAsyncEnumerable<T> data,
        long startSequence,
        string token,
        CancellationToken cancellationToken)
    {
        try
        {
            var producer = new ProducerStream();

            var content = new StreamContent(producer.Reader);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/x-ndjson");
            content.Headers.ContentEncoding.Add("gzip");

            using var request = new HttpRequestMessage(HttpMethod.Post, $"{_options.StreamPath}/{session.SessionId}/stream");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
            request.Content = content;

            // 1️⃣ Lanzamos el POST
            var postTask = _httpClient.SendAsync(
                request,
                HttpCompletionOption.ResponseHeadersRead,
                cancellationToken);

            // 2️⃣ Escribimos el stream
            await WriteStreamAsync(producer, data, startSequence, cancellationToken);

            // 3️⃣ Esperamos la respuesta HTTP
            var response = await postTask;
            response.EnsureSuccessStatusCode();
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"Failed to stream data to sessionId='{session.SessionId}', uploadUrl='{session.UploadUrl}'.", ex);
            throw;
        }
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