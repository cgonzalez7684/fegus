using System.Net.Http.Json;
using System.Text.Json;
using FegusDAgent.Domain.Interfaces;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Http;
using FegusDAgent.Application.Common.Models;

namespace FegusDAgent.Infrastructure.FegusApi;

/// <summary>
/// Singleton que obtiene y cachea el Bearer token del API Fegus
/// llamando a POST /auth/login.
/// </summary>
public sealed class FegusApiTokenProvider : IFegusAuthClient
{
    private const string LoginPath = "auth/login";

    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    private static readonly Action<ILogger, int, string, Exception?> LogHttpError =
        LoggerMessage.Define<int, string>(LogLevel.Warning, default,
            "FegusApi auth: HTTP {StatusCode} al llamar {Path}.");

    private static readonly Action<ILogger, Exception?> LogNoToken =
        LoggerMessage.Define(LogLevel.Warning, default,
            "FegusApi auth: respuesta sin token.");

    private static readonly Action<ILogger, DateTime, Exception?> LogTokenObtained =
        LoggerMessage.Define<DateTime>(LogLevel.Information, default,
            "FegusApi auth: token obtenido, valido hasta {ExpiresAt:u}.");

    private static readonly Action<ILogger, Exception?> LogCallError =
        LoggerMessage.Define(LogLevel.Error, default,
            "FegusApi auth: error al obtener token.");

    private readonly IHttpClientFactory _httpClientFactory;
    private readonly FegusApiOptions _options;
    private readonly ILogger<FegusApiTokenProvider> _logger;
    private readonly SemaphoreSlim _lock = new(1, 1);

    private string? _token;
    private DateTime _expiresAt = DateTime.MinValue;

    public FegusApiTokenProvider(
        IHttpClientFactory httpClientFactory,
        IOptions<FegusApiOptions> options,
        ILogger<FegusApiTokenProvider> logger)
    {
        _httpClientFactory = httpClientFactory;
        _options = options.Value;
        _logger = logger;
    }

    public async Task<string?> GetTokenAsync(CancellationToken cancellationToken = default)
    {
        if (_token is not null && DateTime.UtcNow < _expiresAt)
            return _token;

        await _lock.WaitAsync(cancellationToken);
        try
        {
            // Double-check tras adquirir el lock
            if (_token is not null && DateTime.UtcNow < _expiresAt)
                return _token;

            using var client = _httpClientFactory.CreateClient("FegusApiAuth");

            using var response = await client.PostAsJsonAsync(
                LoginPath,
                new { idCliente = _options.IdCliente, username = _options.Username, password = _options.Password },
                cancellationToken);

            if (!response.IsSuccessStatusCode)
            {
                LogHttpError(_logger, (int)response.StatusCode, LoginPath, null);
                return null;
            }

            var dto = await response.Content
                .ReadFromJsonAsync<ApiResponse<AuthTokenResponse>>(JsonOptions, cancellationToken);

            if (dto?.Value?.AccessToken is null)
            {
                LogNoToken(_logger, null);
                return null;
            }

            _token = dto?.Value?.AccessToken;
            _expiresAt = DateTime.UtcNow.AddMinutes(55); // renueva antes de la expiracion tipica de 1h

            LogTokenObtained(_logger, _expiresAt, null);
            return _token;
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            LogCallError(_logger, ex);
            return null;
        }
        finally
        {
            _lock.Release();
        }
    }

    /// <summary>Fuerza la renovacion del token en la proxima llamada (usar tras recibir 401).</summary>
    public void InvalidateToken() => _token = null;

    
}
