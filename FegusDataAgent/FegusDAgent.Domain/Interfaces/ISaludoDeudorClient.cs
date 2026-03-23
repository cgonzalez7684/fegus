namespace FegusDAgent.Domain.Interfaces;

/// <summary>
/// Cliente HTTP hacia el endpoint GET /crediticio/deudores/saludo del API Fegus.
/// </summary>
public interface ISaludoDeudorClient
{
    /// <summary>
    /// Obtiene el mensaje de saludo. Devuelve null si la respuesta no es exitosa o no se puede deserializar.
    /// </summary>
    Task<string?> GetSaludoAsync(CancellationToken cancellationToken = default);
}
