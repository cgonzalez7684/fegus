namespace FegusDAgent.Domain.Interfaces;

/// <summary>
/// Obtiene un Bearer token del API Fegus llamando a POST /auth/login.
/// </summary>
public interface IFegusAuthClient
{
    Task<string?> GetTokenAsync(CancellationToken cancellationToken = default);
}
