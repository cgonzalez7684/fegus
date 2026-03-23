using Application.Feactures.FegusConfig.Queries.GetNextBoxDataLoad;
using Common.Share;
using Domain.Entities.FegusConfig;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.FegusConfig.BoxDataLoad;

public class GetNextBoxDataLoadEndpoint
    : Endpoint<GetNextBoxDataLoadQuery, Result<FeBoxDataLoad>>
{
    private readonly ISender _sender;

    public GetNextBoxDataLoadEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Get("/fegusconfig/box/{idCliente:int}");

        AllowAnonymous();

        Summary(s =>
        {
            s.Summary = "Obtiene el siguiente registro de fe_box_data_load";
            s.Description = "Invoca el caso de uso GetNextBoxDataLoadQuery";
        });
    }

    public override async Task HandleAsync(GetNextBoxDataLoadQuery req, CancellationToken ct)
    {
        var query = new GetNextBoxDataLoadQuery(req.IdCliente);

        Result<FeBoxDataLoad> result = await _sender.Send(query, ct);

        await Send.ResponseAsync(result);
    }
}
