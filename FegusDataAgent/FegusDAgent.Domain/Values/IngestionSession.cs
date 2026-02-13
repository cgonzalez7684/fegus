namespace FegusDAgent.Domain.Values;
public sealed record IngestionSession(
    string SessionId,
    string UploadUrl,
    int RecommendedChunkSize
);
