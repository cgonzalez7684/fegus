namespace FegusDAgent.Infrastructure.Ingestion;

public sealed class IngestionApiOptions
{
    public const string SectionName = "IngestionApi";

    public string BaseUrl { get; set; } = string.Empty;
    public string CreateSessionPath { get; set; } = "/ingestion/sessions";
    public string GetStatusPath { get; set; } = "/ingestion/sessions";
    public string CommitPath { get; set; } = "/ingestion/sessions";

    public string StreamPath { get; set; } = "/ingestion/sessions";

    public string InFlightSessionPath { get; set; } = "/ingestion/sessions/by-box";
}
