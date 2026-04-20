using System;
using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Commands.UpdateBoxDataLoad;

public sealed record UpdateBoxDataLoadCommand(
    FeBoxDataLoad pFeBoxDataLoad) : ICommand<bool>;