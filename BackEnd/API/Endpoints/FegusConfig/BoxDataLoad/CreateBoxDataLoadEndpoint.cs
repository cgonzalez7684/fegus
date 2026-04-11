using Application.Feactures.FegusConfig.CreateBoxDataLoad;
using Common.Share;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.FegusConfig.BoxDataLoad;

public class CreateBoxDataLoadEndpoint 
    : Endpoint<CreateBoxDataLoadCommand, Result<long?>>
{
    private readonly ISender _sender;

    public CreateBoxDataLoadEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/fegusconfig/box");

        Policies("AuthenticatedUser");

        Summary(s =>
        {
            s.Summary = "Crea un registro en fe_box_data_load";
            s.Description = "Invoca el caso de uso CreateBoxDataLoadCommand";
        });
    }

    public override async Task HandleAsync(CreateBoxDataLoadCommand req, CancellationToken ct)
    {
        Console.WriteLine($"Inicio: {req}");
        Result<long?> result = await _sender.Send(req, ct);
        Console.WriteLine($"Resultyy: {result.Value}");

        await Send.ResponseAsync(result);
    }
}