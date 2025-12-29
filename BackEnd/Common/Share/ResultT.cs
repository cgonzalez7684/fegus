namespace Common.Share;

public class Result<T> : Result
{
    public T? Value { get; }

    private Result(
        bool isSuccess,
        T? value,
        string? error,
        ErrorType? errorType)
        : base(isSuccess, error, errorType)
    {
        Value = value;
    }

    public static Result<T> Success(T value)
        => new(true, value, null, null);

    public static new Result<T> Fail(
        string error,
        ErrorType errorType = Share.ErrorType.Validation)
        => new(false, default, error, errorType);
}
