using System;

namespace FegusDAgent.Application.Common.Models;

public record ApiResponse<T>(
    T? Value,
    bool IsSuccess,
    bool IsFailure,
    string? Error,
    string? ErrorType
);
