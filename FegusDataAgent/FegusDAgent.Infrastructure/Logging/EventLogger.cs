using FegusDAgent.Application.Logging;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace FegusDAgent.Infrastructure.Logging;

public sealed class EventLogger<T>(
    ILogger<T> logger,
    IOptions<EventLogOptions> options) : IEventLogger<T>
{
    private readonly ILogger<T> _logger = logger;
    private readonly EventLogOptions _options = options.Value;

    public void Info(string message)
    {
        if (_options.LogInformational)
            _logger.LogInformation(message);
    }

    public void Error(string message, Exception? exception = null)
    {
        if (_options.LogError)
            _logger.LogError(exception, message);
    }
}
