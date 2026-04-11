using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Fegus;

/// <summary>
/// Obtiene un Bearer token del API Fegus autenticando con idCliente, Username y Password.
/// </summary>
public sealed class AuthenticateUseCase(IFegusAuthClient authClient)
{
    public async Task<string?> ExecuteAsync(CancellationToken cancellationToken = default)
    {
        return await authClient.GetTokenAsync(cancellationToken);
    }
}
