namespace FegusDAgent.Worker;

/// <summary>
/// Configuración del productor + worker pool que invoca <c>GetSaludoDeudorUseCase</c>.
/// </summary>
public sealed class SaludoWorkerOptions
{
    public const string SectionName = "SaludoWorker";

    /// <summary>Segundos entre cada “tick” del productor.</summary>
    public int PollIntervalSeconds { get; set; } = 5;

    /// <summary>Cuántos trabajos encolar por tick (invocaciones paralelas posibles al API).</summary>
    public int ParallelJobsPerTick { get; set; } = 4;

    /// <summary>Número de consumidores que leen del canal en paralelo.</summary>
    public int ConsumerCount { get; set; } = 4;

    /// <summary>Capacidad del canal acotado (cola máxima antes de que el productor espere).</summary>
    public int ChannelCapacity { get; set; } = 64;
}
