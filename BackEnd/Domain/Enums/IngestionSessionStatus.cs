using System;

namespace Domain.Enums;

public enum IngestionSessionStatus
{
    Created = 1,
    Receiving = 2,
    Completed = 3,
    Failed = 4
}
