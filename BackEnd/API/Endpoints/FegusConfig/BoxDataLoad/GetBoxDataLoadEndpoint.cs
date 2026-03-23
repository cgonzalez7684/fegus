using Application.Feactures.FegusConfig.Queries.GetBoxDataLoad;
using Common.Share;
using Domain.Entities.FegusConfig;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.FegusConfig.BoxDataLoad;

public class GetBoxDataLoadEndpoint 
    : Endpoint<GetBoxDataLoadQuery, Result<IEnumerable<FeBoxDataLoad>>>
{
    private readonly ISender _sender;

    public GetBoxDataLoadEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Get("/fegusconfig/box/{idCliente:int}/{idLoad?}");

        Policies("AuthenticatedUser");

        Summary(s =>
        {
            s.Summary = "Obtiene registros de fe_box_data_load";
            s.Description = "Invoca el caso de uso GetBoxDataLoadQuery";
        });
    }

    public override async Task HandleAsync(GetBoxDataLoadQuery req, CancellationToken ct)
    {
        var query = new GetBoxDataLoadQuery(req.IdCliente, req.IdLoad);

        Result<IEnumerable<FeBoxDataLoad>> result = await _sender.Send(query, ct);

        await Send.ResponseAsync(result);
    }
}