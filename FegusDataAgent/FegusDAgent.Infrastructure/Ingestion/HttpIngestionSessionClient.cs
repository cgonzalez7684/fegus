using System.Net.Http.Headers;
using System.Net.Http.Json;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Infrastructure.Ingestion;

public sealed class HttpIngestionSessionClient : IIngestionSessionClient
{
    private readonly HttpClient _httpClient;
    private readonly IEventLogger<HttpIngestionSessionClient> _logger;

    public HttpIngestionSessionClient(
        HttpClient httpClient,
        IEventLogger<HttpIngestionSessionClient> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task<IngestionSession> CreateSessionAsync(
        int? idLoad,
        string dataset,
        string token,
        CancellationToken cancellationToken)
    {
        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, "/ingestion/sessions");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
            //request.Content = JsonContent.Create(new { dataset });
            request.Content = JsonContent.Create(new { idLoad, dataset });

            var response = await _httpClient.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();

            var dto = await response.Content
                .ReadFromJsonAsync<IngestionSession>(cancellationToken);

            return new IngestionSession(
                dto!.SessionId,
                dto.UploadUrl,
                dto.RecommendedChunkSize);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"Failed to create ingestion session for dataset='{dataset}'.", ex);
            throw;
        }
    }

    public async Task CommitAsync(
        string sessionId,
        string token,
        CancellationToken cancellationToken)
    {
        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, $"/ingestion/sessions/{sessionId}/commit");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"Failed to commit ingestion session sessionId='{sessionId}'.", ex);
            throw;
        }
    }

    public async Task<IngestionSessionStatus> GetStatusAsync(
        string sessionId,
        string token,
        CancellationToken cancellationToken)
    {
        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Get, $"/ingestion/sessions/{sessionId}");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();

            var dto = await response.Content
                .ReadFromJsonAsync<IngestionSessionStatus>(cancellationToken);

            return new IngestionSessionStatus(
                dto!.SessionId,
                dto.LastSequencePersisted,
                dto.Status);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"Failed to get status for ingestion session sessionId='{sessionId}'.", ex);
            throw;
        }
    }
}