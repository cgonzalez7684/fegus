using Application.Feactures.FegusConfig.Commands.DeleteBoxDataLoad;
using Common.Share;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.FegusConfig.BoxDataLoad;

public class DeleteBoxDataLoadEndpoint 
    : Endpoint<DeleteBoxDataLoadCommand, Result<bool>>
{
    private readonly ISender _sender;

    public DeleteBoxDataLoadEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Delete("/fegusconfig/box/{idCliente:int}/{idLoad:int}");

        Policies("AuthenticatedUser");

        Summary(s =>
        {
            s.Summary = "Elimina un registro de fe_box_data_load";
            s.Description = "Invoca el caso de uso DeleteBoxDataLoadCommand";
        });
    }

    public override async Task HandleAsync(DeleteBoxDataLoadCommand req, CancellationToken ct)
    {
        var command = new DeleteBoxDataLoadCommand(req.IdCliente, req.IdLoad);

        Result<bool> result = await _sender.Send(command, ct);

        await Send.ResponseAsync(result);
    }
}