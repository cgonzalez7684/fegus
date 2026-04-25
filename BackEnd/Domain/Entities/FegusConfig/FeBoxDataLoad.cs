using System;

namespace Domain.Entities.FegusConfig;
    public sealed class FeBoxDataLoad
{
    public int? IdCliente { get; set; }
    public int? IdLoad { get; set; }

    public int? IdLoadLocal { get; set; }
    public string? StateCode { get; set; }
    public string? IsActive { get; set; }
    public DateTime? AsofDate { get; set; }
    public DateTime CreatedAtUtc { get; set; }
    public DateTime? UpdatedAtUtc { get; set; }

    public int? AttemptCount { get; set; }
    public string? LastErrorMessage { get; set; }
}
