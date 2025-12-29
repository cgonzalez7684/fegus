namespace Common.Share;

public class Result
{
    public bool IsSuccess { get; }
    public bool IsFailure => !IsSuccess;

    public string? Error { get; }
    public ErrorType? ErrorType { get; }

    protected Result(bool isSuccess, string? error, ErrorType? errorType)
    {
        IsSuccess = isSuccess;
        Error = error;
        ErrorType = errorType;
    }

    public static Result Success()
        => new(true, null, null);

    public static Result Fail(
        string error,
        ErrorType errorType = Share.ErrorType.Validation)
        => new(false, error, errorType);
}
