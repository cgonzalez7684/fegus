namespace Common.Share;

public sealed class ExecutionResult<T>
{
    public T? Data { get; set; }
    public int? SqlCode { get; set; }
    public string? SqlMessage { get; set; }
    public int Qty { get; set; }
}