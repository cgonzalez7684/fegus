using System;
using System.ComponentModel;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Infrastructure.Checkpoints;

public sealed class FileCheckpointStore : ICheckpointStore
{
    private readonly string _basePath;

    public FileCheckpointStore(string basePath)
    {
        _basePath = basePath;
        Directory.CreateDirectory(_basePath);
    }

    public async Task<long> GetLastSequenceAsync(
        string sessionId,
        CancellationToken cancellationToken)
    {
        var path = Path.Combine(_basePath, $"{sessionId}.chk");

        if (!File.Exists(path))
            return 0;

        var text = await File.ReadAllTextAsync(path, cancellationToken);
        return long.Parse(text);
    }

    public async Task SaveSequenceAsync(
        string sessionId,
        long sequence,
        CancellationToken cancellationToken)
    {
        var path = Path.Combine(_basePath, $"{sessionId}.chk");
        await File.WriteAllTextAsync(
            path,
            sequence.ToString(),
            cancellationToken);
    }
}
