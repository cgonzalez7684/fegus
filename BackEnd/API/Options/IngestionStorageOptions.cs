using System;

namespace API.Options;

public sealed class IngestionStorageOptions
{
    public string TempStoragePath { get; init; } = default!;
}
