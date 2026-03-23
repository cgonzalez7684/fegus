using System;

namespace Infrastructure.Models;
public sealed class DbCommandRawResult
{
    public int? Psqlcode { get; set; }
    public string? Psqlmessage { get; set; }
    public int Pqty { get; set; }
}