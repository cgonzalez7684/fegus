namespace FegusDAgent.Infrastructure.FegusApi;

/// <summary>
/// Configuración para el API Fegus (sección "FegusApi" en appsettings).
/// </summary>
public sealed class FegusApiOptions
{
    public const string SectionName = "FegusApi";

    public string BaseUrl { get; set; } = string.Empty;
    
    public string IdCliente { get; set; } = string.Empty;
    /// <summary>Usuario para POST /auth/login.</summary>
    public string Username { get; set; } = string.Empty;

    /// <summary>Contraseña para POST /auth/login.</summary>
    public string Password { get; set; } = string.Empty;

    
}
