using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases;

/// <summary>
/// Orquesta la consulta de saludo al API de deudores (Health/demo del backend).
/// </summary>
public sealed class GetSaludoDeudorUseCase
{
    private readonly ISaludoDeudorClient _client;

    public GetSaludoDeudorUseCase(ISaludoDeudorClient client)
    {
        _client = client;
    }

    public Task<string?> ExecuteAsync(CancellationToken cancellationToken = default)
        => _client.GetSaludoAsync(cancellationToken);
}
