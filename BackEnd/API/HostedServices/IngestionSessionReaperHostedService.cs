using Domain.Interfaces.Ingestion;
using Microsoft.Extensions.Options;

namespace API.HostedServices;

public sealed class IngestionReaperOptions
{
    public int OrphanSessionTimeoutHours { get; set; } = 6;
    public int ReaperIntervalMinutes { get; set; } = 60;
}

/// <summary>
/// Periodically marks ingestion sessions stuck in CREATED/RECEIVING beyond the
/// configured timeout as FAILED. Prevents orphaned sessions from accumulating
/// when the agent crashes or a client is decommissioned.
/// </summary>
public sealed class IngestionSessionReaperHostedService : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly IOptionsMonitor<IngestionReaperOptions> _options;
    private readonly ILogger<IngestionSessionReaperHostedService> _logger;

    public IngestionSessionReaperHostedService(
        IServiceScopeFactory scopeFactory,
        IOptionsMonitor<IngestionReaperOptions> options,
        ILogger<IngestionSessionReaperHostedService> logger)
    {
        _scopeFactory = scopeFactory;
        _options = options;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            var current = _options.CurrentValue;
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var repo = scope.ServiceProvider.GetRequiredService<IIngestionSessionRepository>();

                var olderThan = TimeSpan.FromHours(current.OrphanSessionTimeoutHours);
                var reaped = await repo.ReapOrphanSessionsAsync(olderThan, stoppingToken);

                if (reaped > 0)
                    _logger.LogInformation(
                        "IngestionSessionReaper: marked {Count} orphan session(s) as FAILED (older than {Hours}h).",
                        reaped, current.OrphanSessionTimeoutHours);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "IngestionSessionReaper failed; will retry next interval.");
            }

            try
            {
                await Task.Delay(
                    TimeSpan.FromMinutes(current.ReaperIntervalMinutes),
                    stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
        }
    }
}
