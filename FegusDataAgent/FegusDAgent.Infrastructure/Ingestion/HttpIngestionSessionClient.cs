using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using FegusDAgent.Application.Common.Models;
using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Domain.Values;
using Microsoft.Extensions.Options;

namespace FegusDAgent.Infrastructure.Ingestion;

public sealed class HttpIngestionSessionClient : IIngestionSessionClient
{

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };
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
            request.Content = JsonContent.Create(new { idLoad, dataset });

            var response = await _httpClient.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();

            var dto = await response.Content
                .ReadFromJsonAsync<ApiResponse<IngestionSession>>(cancellationToken);

            return dto!.Value!;

            /*return new IngestionSession(
                SessionId: dto!.SessionId,
                IdCliente: 0, // estos campos no los devuelve el API, se podrían eliminar o dejar como opcionales
                IdLoad: idLoad ?? 0,
                Dataset: dataset,
                SessionStateCode: null,
                LastSequencePersisted: 0,
                CreatedAtUtc: DateTime.UtcNow,
                UpdatedAtUtc: DateTime.UtcNow,
                ErrorMessage: null
            );*/
            /*return new IngestionSession(
                dto!.SessionId.ToString(),
                string.Empty,
                0);*/
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
        Guid sessionId,
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
        Guid sessionId,
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