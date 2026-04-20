using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using Microsoft.Extensions.Logging;

namespace FegusDAgent.Infrastructure.FegusApi;

/// <summary>
/// Consume <c>GET /fegusconfig/box/{idCliente}</c> (sin auth) y
/// <c>PUT /fegusconfig/box</c> (con Bearer token) del API Fegus.
/// </summary>
public sealed class HttpFegusConfigClient(
    HttpClient httpClient,    
    ILogger<HttpFegusConfigClient> logger) : IFegusConfigClient
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
    };

    private static readonly Action<ILogger, int, string, Exception?> LogHttpError =
        LoggerMessage.Define<int, string>(LogLevel.Warning, default,
            "FegusConfig box: HTTP {StatusCode} al llamar {Path}.");

    private static readonly Action<ILogger, int, Exception?> LogEmptyBody =
        LoggerMessage.Define<int>(LogLevel.Warning, default,
            "FegusConfig box: cuerpo vacío o JSON inválido para idCliente={IdCliente}.");

    private static readonly Action<ILogger, int, string, Exception?> LogApiError =
        LoggerMessage.Define<int, string>(LogLevel.Warning, default,
            "FegusConfig box: API devolvió error lógico para idCliente={IdCliente}: {Error}.");

    private static readonly Action<ILogger, int, Exception?> LogCallError =
        LoggerMessage.Define<int>(LogLevel.Error, default,
            "FegusConfig box: error al invocar el API para idCliente={IdCliente}.");

    private static readonly Action<ILogger, int, Exception?> LogNoToken =
        LoggerMessage.Define<int>(LogLevel.Warning, default,
            "FegusConfig box: no se pudo obtener token para idCliente={IdCliente}.");

    private static readonly Action<ILogger, int, Exception?> LogUnauthorized =
        LoggerMessage.Define<int>(LogLevel.Warning, default,
            "FegusConfig box: 401 al actualizar box para idCliente={IdCliente}. Token invalidado.");

    private static readonly Action<ILogger, int, Exception?> LogUpdateSuccess =
        LoggerMessage.Define<int>(LogLevel.Information, default,
            "FegusConfig box: actualización exitosa para idCliente={IdCliente}.");

    public async Task<FeBoxDataLoad?> GetNextBoxDataLoadAsync(int idCliente, CancellationToken cancellationToken = default)
    {
        var path = $"fegusconfig/box/{idCliente}";

        try
        {
            using var response = await httpClient.GetAsync(path, cancellationToken);

            if (!response.IsSuccessStatusCode)
            {
                LogHttpError(logger, (int)response.StatusCode, path, null);
                return null;
            }

            var envelope = await response.Content
                .ReadFromJsonAsync<ResultEnvelopeDto>(JsonOptions, cancellationToken);

            if (envelope is null)
            {
                LogEmptyBody(logger, idCliente, null);
                return null;
            }

            if (!envelope.IsSuccess)
            {
                LogApiError(logger, idCliente, envelope.Error ?? "(sin mensaje)", null);
                return null;
            }

            return envelope.Value;
        }
        catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            LogCallError(logger, idCliente, ex);
            return null;
        }
    }

    public async Task<bool> UpdateFeBoxDataLoadAsync(string token,FeBoxDataLoad box, CancellationToken cancellationToken = default)
    {
        const string path = "fegusconfig/box";
        var idCliente = box.IdCliente ?? 0;       

        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Put, path);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
            request.Content = JsonContent.Create(new { pFeBoxDataLoad = box }, options: JsonOptions);

            using var response = await httpClient.SendAsync(request, cancellationToken);
            

            if (!response.IsSuccessStatusCode)
            {
                LogHttpError(logger, (int)response.StatusCode, path, null);
                return false;
            }

            LogUpdateSuccess(logger, idCliente, null);
            return true;
        }
        catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            LogCallError(logger, idCliente, ex);
            return false;
        }
    }

    private sealed class ResultEnvelopeDto
    {
        public bool IsSuccess { get; set; }
        public string? Error { get; set; }
        public FeBoxDataLoad? Value { get; set; }
    }
}
