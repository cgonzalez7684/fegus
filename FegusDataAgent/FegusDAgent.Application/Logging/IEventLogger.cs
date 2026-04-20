namespace FegusDAgent.Application.Logging;

public interface IEventLogger<T>
{
    void Info(string message);
    void Error(string message, Exception? exception = null);
}
