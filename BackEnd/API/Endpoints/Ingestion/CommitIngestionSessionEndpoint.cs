using Application.Feactures.Ingestion.CommitSession;
using FastEndpoints;
using MediatR;


namespace API.Endpoints.Ingestion;

public sealed class CommitIngestionSessionEndpoint
    : EndpointWithoutRequest
{
    private readonly ISender _sender;

    public CommitIngestionSessionEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/ingestion/sessions/{sessionId:guid}/commit");
        Policies("Ingestion"); // Requiere el rol "ingestion.agent"
    }

    public override async Task HandleAsync(CancellationToken ct)
    {
        var sessionId = Route<Guid>("sessionId");

        await _sender.Send(
            new CommitIngestionSessionCommand(sessionId),
            ct);

        await Send.OkAsync();
    }
}

