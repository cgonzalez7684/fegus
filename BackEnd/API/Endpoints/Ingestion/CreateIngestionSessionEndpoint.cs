using System;
using Application.Feactures.Ingestion.CreateSession;

namespace API.Endpoints.Ingestion;

public sealed class CreateIngestionSessionEndpoint
    : Endpoint<CreateIngestionSessionRequest, CreateIngestionSessionResponse>
{
    private readonly ISender _sender;

    public CreateIngestionSessionEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/ingestion/sessions");
        Policies("Ingestion"); // Requiere el rol "ingestion.agent"
        //AllowAnonymous();
    }

    public override async Task HandleAsync(
        CreateIngestionSessionRequest req,
        CancellationToken ct)
    {
        var idCliente = int.Parse(User.Claims
            .First(c => c.Type == "idcliente").Value);

        var result = await _sender.Send(
            new CreateIngestionSessionCommand(idCliente, req.IdLoad, req.Dataset),
            ct);

        if (result.IsFailure)
        {
            AddError(result.Error!);
            ThrowIfAnyErrors();
        }

        await Send.ResponseAsync(new CreateIngestionSessionResponse
        {
            SessionId = result.Value
        });

    }
}

public sealed record CreateIngestionSessionRequest(    
    int IdLoad,
    string Dataset
);

public sealed record CreateIngestionSessionResponse
{
    public Guid SessionId { get; init; }
}

