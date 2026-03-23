using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Queries.GetNextBoxDataLoad;
public sealed record GetNextBoxDataLoadQuery(
    int IdCliente    
) : IQuery<FeBoxDataLoad>;
