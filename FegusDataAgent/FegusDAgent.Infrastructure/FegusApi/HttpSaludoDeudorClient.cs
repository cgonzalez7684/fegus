using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using FegusDAgent.Domain.Interfaces;
using Microsoft.Extensions.Logging;

namespace FegusDAgent.Infrastructure.FegusApi;

/// <summary>
/// Consume <c>GET /crediticio/deudores/saludo</c> y deserializa <see cref="Common.Share.Result{T}"/> del backend.
/// </summary>
public sealed class HttpSaludoDeudorClient : ISaludoDeudorClient
{
    private const string SaludoPath = "crediticio/deudores/saludo";

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
    };

    private readonly HttpClient _httpClient;
    private readonly ILogger<HttpSaludoDeudorClient> _logger;

    public HttpSaludoDeudorClient(HttpClient httpClient, ILogger<HttpSaludoDeudorClient> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task<string?> GetSaludoAsync(CancellationToken cancellationToken = default)
    {
        try
        {
            using var response = await _httpClient.GetAsync(SaludoPath, cancellationToken);

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogWarning(
                    "Saludo deudor: HTTP {StatusCode} al llamar {Path}",
                    (int)response.StatusCode,
                    SaludoPath);
                return null;
            }

            var envelope = await response.Content.ReadFromJsonAsync<ResultEnvelopeDto>(JsonOptions, cancellationToken);

            if (envelope is null)
            {
                _logger.LogWarning("Saludo deudor: cuerpo vacío o JSON inválido.");
                return null;
            }

            if (!envelope.IsSuccess)
            {
                _logger.LogWarning(
                    "Saludo deudor: API devolvió error lógico: {Error}",
                    envelope.Error ?? "(sin mensaje)");
                return null;
            }

            return envelope.Value?.Result;
        }
        catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Saludo deudor: error al invocar el API.");
            return null;
        }
    }

    private sealed class ResultEnvelopeDto
    {
        public bool IsSuccess { get; set; }
        public string? Error { get; set; }
        public SaludoPayloadDto? Value { get; set; }
    }

    private sealed class SaludoPayloadDto
    {
        public string? Result { get; set; }
    }
}
