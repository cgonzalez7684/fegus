using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Queries.GetBoxDataLoad;

public sealed record GetBoxDataLoadQuery(
    int IdCliente,
    int? IdLoad
) : IQuery<IEnumerable<FeBoxDataLoad>>;