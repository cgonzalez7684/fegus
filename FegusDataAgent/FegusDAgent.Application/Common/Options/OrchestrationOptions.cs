namespace FegusDAgent.Application.Common.Options;

/// <summary>
/// Cross-cutting options for the data-load orchestration. Populated by the Worker host
/// from configuration (see SaludoWorker section in appsettings.json).
/// </summary>
public sealed class OrchestrationOptions
{
    /// <summary>
    /// Máximo de intentos por box antes de marcarlo en estado ERROR. Default 5.
    /// </summary>
    public int MaxAttemptsPerBox { get; set; } = 5;
}
