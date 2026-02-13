using Application.Feactures.Ingestion.Queries;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.Ingestion;

public sealed class GetIngestionSessionStatusEndpoint
    : EndpointWithoutRequest<IngestionSessionStatusResponse>
{
    private readonly ISender _sender;

    public GetIngestionSessionStatusEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Get("/ingestion/sessions/{sessionId:guid}");
        Policies("Ingestion"); // Requiere el rol "ingestion.agent"
    }

    public override async Task HandleAsync(CancellationToken ct)
    {
        var sessionId = Route<Guid>("sessionId");

        var session = await _sender.Send(
            new GetIngestionSessionStatusQuery(sessionId),
            ct);

        await Send.ResponseAsync(new IngestionSessionStatusResponse
        {
            SessionId = session.Value!.SessionId,
            Dataset = session.Value.Dataset!,
            Status = session.Value.Status.ToString(),
            LastSequencePersisted = session.Value.LastSequencePersisted
        });
    }
}

public sealed record IngestionSessionStatusResponse
{
    public Guid SessionId { get; init; }
    public string Dataset { get; init; } = default!;
    public string Status { get; init; } = default!;
    public long LastSequencePersisted { get; init; }
}
