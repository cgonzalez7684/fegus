namespace Application.Feactures.FegusConfig.CreateBoxDataLoad;

public sealed record CreateBoxDataLoadCommand(
    int IdCliente,
    string StateCode,
    string IsActive,
    DateTime? AsofDate
) : ICommand<long?>;