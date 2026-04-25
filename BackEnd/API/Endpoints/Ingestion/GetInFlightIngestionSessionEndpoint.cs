using Application.Feactures.Ingestion.Queries;
using Common.Share;
using Domain.Entities.Ingestion;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.Ingestion;

/// <summary>
/// GET /ingestion/sessions/by-box?idLoad={idLoad}&amp;dataset={dataset}
///
/// Returns the latest CREATED or RECEIVING session for the (idCliente, idLoad, dataset)
/// triple, or 204 No Content if none exists. Used by FegusDataAgent to resume an
/// interrupted ingestion run instead of creating a duplicate session every retry.
/// </summary>
public sealed class GetInFlightIngestionSessionEndpoint
    : Endpoint<GetInFlightIngestionSessionRequest, Result<IngestionSession?>>
{
    private readonly ISender _sender;

    public GetInFlightIngestionSessionEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Get("/ingestion/sessions/by-box");
        Policies("Ingestion");
    }

    public override async Task HandleAsync(
        GetInFlightIngestionSessionRequest req,
        CancellationToken ct)
    {
        var idCliente = int.Parse(User.Claims
            .First(c => c.Type == "idcliente").Value);

        var result = await _sender.Send(
            new GetInFlightIngestionSessionQuery(idCliente, req.IdLoad, req.Dataset),
            ct);

        // No in-flight session: return 204 so the agent can fall through to CreateSession.
        if (result.IsSuccess && result.Value is null)
        {
            await Send.NoContentAsync(ct);
            return;
        }

        await Send.ResponseAsync(result, cancellation: ct);
    }
}

public sealed record GetInFlightIngestionSessionRequest(
    int IdLoad,
    string Dataset
);
