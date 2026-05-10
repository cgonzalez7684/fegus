namespace FegusDAgent.Domain.Values;

public readonly record struct SourceRecord<T>(long Seq, T Data);
