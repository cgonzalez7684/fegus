namespace Domain.Entities.FegusConfig;

public static class DataLoadState
{
    public const string New        = "NEW";
    public const string Created    = "CREATED";
    public const string Staging    = "STAGING";
    public const string Loading    = "LOADING";
    public const string Validating = "VALIDATING";
    public const string Calculating = "CALCULATING";
    public const string Completed  = "COMPLETED";
    public const string Error      = "ERROR";
    public const string Cancelled  = "CANCELLED";
}
