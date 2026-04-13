using System.Net.Http.Headers;
using System.Net.Http.Json;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;
using Microsoft.Extensions.Options;

namespace FegusDAgent.Infrastructure.Ingestion;

public sealed class HttpIngestionSessionClient : IIngestionSessionClient
{
    private readonly HttpClient _httpClient;
    private readonly IEventLogger<HttpIngestionSessionClient> _logger;
    private readonly IngestionApiOptions _options;

    public HttpIngestionSessionClient(
        HttpClient httpClient,
        IEventLogger<HttpIngestionSessionClient> logger,
        IOptions<IngestionApiOptions> options)
    {
        _httpClient = httpClient;
        _logger = logger;
        _options = options.Value;
    }

    public async Task<IngestionSession> CreateSessionAsync(
        int? idLoad,
        string dataset,
        string token,
        CancellationToken cancellationToken)
    {
        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, _options.CreateSessionPath);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
            //request.Content = JsonContent.Create(new { dataset });
            request.Content = JsonContent.Create(new { idLoad, dataset });

            var response = await _httpClient.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();

            var dto = await response.Content
                .ReadFromJsonAsync<CreateSessionResponseDto>(cancellationToken);

            return new IngestionSession(
                dto!.SessionId.ToString(),
                string.Empty,
                0);
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

    private sealed record CreateSessionResponseDto(Guid SessionId);

    public async Task CommitAsync(
        string sessionId,
        string token,
        CancellationToken cancellationToken)
    {
        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, $"{_options.CommitPath}/{sessionId}/commit");
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
            using var request = new HttpRequestMessage(HttpMethod.Get, $"{_options.GetStatusPath}/{sessionId}");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _httpClient.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();

            var dto = await response.Content
                .ReadFromJsonAsync<IngestionSessionStatus>(cancellationToken);

            return new IngestionSessionStatus(
                dto!.SessionId,
                dto.idCliente,
                dto.idLoad,
                dto.Dataset,
                dto.SessionStateCode,
                dto.LastSequencePersisted
            );
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