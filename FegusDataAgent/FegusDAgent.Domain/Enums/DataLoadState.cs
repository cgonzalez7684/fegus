using System;

namespace FegusDAgent.Domain.Enums;

public sealed class DataLoadState
{
    public string Value { get; }

    private DataLoadState(string value)
    {
        Value = value;
    }

    public static readonly DataLoadState Staging = new("STAGING");
    public static readonly DataLoadState Validating = new("VALIDATING");
    public static readonly DataLoadState Calculating = new("CALCULATING");
    public static readonly DataLoadState Completed = new("COMPLETED");
    public static readonly DataLoadState Error = new("ERROR");
    public static readonly DataLoadState Cancelled = new("CANCELLED");
    public static readonly DataLoadState Created = new("CREATED");
    public static readonly DataLoadState New = new("NEW");

    public override string ToString() => Value;
}
