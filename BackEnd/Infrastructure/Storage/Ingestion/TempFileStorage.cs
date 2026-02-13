using System;

namespace Infrastructure.Storage.Ingestion;

public sealed class TempFileStorage
{
    private readonly string _basePath;

    public TempFileStorage(string basePath)
    {
        _basePath = basePath;
        Directory.CreateDirectory(_basePath);
    }

    public string GetSessionFilePath(Guid sessionId)
    {
        return Path.Combine(_basePath, $"{sessionId}.ndjson");
    }
}