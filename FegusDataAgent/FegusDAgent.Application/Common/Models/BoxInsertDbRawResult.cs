using System;

namespace FegusDAgent.Application.Common.Models;

public sealed class BoxInsertDbRawResult
{
    public long? pidload { get; set; }
    public string? psqlcode { get; set; }
    public string? psqlmessage { get; set; }
    public int pqty { get; set; }
}