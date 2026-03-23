using System;

namespace Application.Feactures.FegusConfig.Commands.UpdateBoxDataLoad;

public sealed record UpdateBoxDataLoadCommand(
    int IdCliente,
    int IdLoad,
    string StateCode,
    string IsActive
) : ICommand<bool>;