using System;
using System.Net.Http.Json;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Infrastructure.Ingestion;

public sealed class HttpIngestionSessionClient : IIngestionSessionClient
{
    private readonly HttpClient _httpClient;

    public HttpIngestionSessionClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<IngestionSession> CreateSessionAsync(
        string dataset,
        CancellationToken cancellationToken)
    {
        var response = await _httpClient.PostAsJsonAsync(
            "/api/ingestion/sessions",
            new { dataset },
            cancellationToken);

        response.EnsureSuccessStatusCode();

        var dto = await response.Content
            .ReadFromJsonAsync<IngestionSession>(cancellationToken);

        return new IngestionSession(
            dto!.SessionId,
            dto.UploadUrl,
            dto.RecommendedChunkSize);
    }

    public async Task CommitAsync(
        string sessionId,
        CancellationToken cancellationToken)
    {
        var response = await _httpClient.PostAsync(
            $"/api/ingestion/sessions/{sessionId}/commit",
            null,
            cancellationToken);

        response.EnsureSuccessStatusCode();
    }

    public async Task<IngestionSessionStatus> GetStatusAsync(
        string sessionId,
        CancellationToken cancellationToken)
    {
        var response = await _httpClient.GetAsync(
            $"/api/ingestion/sessions/{sessionId}",
            cancellationToken);

        response.EnsureSuccessStatusCode();

        var dto = await response.Content
            .ReadFromJsonAsync<IngestionSessionStatus>(cancellationToken);

        return new IngestionSessionStatus(
            dto!.SessionId,
            dto.LastSequencePersisted,
            dto.Status);
    }

   
}
