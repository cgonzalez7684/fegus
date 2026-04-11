namespace FegusDAgent.Application.Logging;

public sealed class EventLogOptions
{
    public const string SectionName = "EventLog";

    /// <summary>When false, calls to <see cref="IEventLogger{T}.Info"/> are no-ops.</summary>
    public bool LogInformational { get; set; } = true;

    /// <summary>When false, calls to <see cref="IEventLogger{T}.Error"/> are no-ops.</summary>
    public bool LogError { get; set; } = true;
}
