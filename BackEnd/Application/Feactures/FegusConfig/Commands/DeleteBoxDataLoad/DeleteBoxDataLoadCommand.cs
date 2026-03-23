namespace Application.Feactures.FegusConfig.Commands.DeleteBoxDataLoad;

public sealed record DeleteBoxDataLoadCommand(
    int IdCliente,
    int IdLoad
) : ICommand<bool>;