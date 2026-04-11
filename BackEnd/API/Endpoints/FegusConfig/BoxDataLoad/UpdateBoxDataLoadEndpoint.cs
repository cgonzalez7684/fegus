using Application.Feactures.FegusConfig.Commands.UpdateBoxDataLoad;
using Common.Share;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.FegusConfig.BoxDataLoad;

public class UpdateBoxDataLoadEndpoint 
    : Endpoint<UpdateBoxDataLoadCommand, Result<bool>>
{
    private readonly ISender _sender;

    public UpdateBoxDataLoadEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Put("/fegusconfig/box");

        Policies("AuthenticatedUser");

        Summary(s =>
        {
            s.Summary = "Actualiza un registro de fe_box_data_load";
            s.Description = "Invoca el caso de uso UpdateBoxDataLoadCommand";
        });
    }

    public override async Task HandleAsync(UpdateBoxDataLoadCommand req, CancellationToken ct)
    {
        Result<bool> result = await _sender.Send(req, ct);

        await Send.ResponseAsync(result);
    }
}