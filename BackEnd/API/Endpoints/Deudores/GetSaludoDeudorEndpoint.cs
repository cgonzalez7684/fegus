namespace API.Endpoints.Deudores;

public sealed class GetSaludoDeudorEndpoint
    : Endpoint<EmptyRequest, Result<GetSaludoDeudorResponse>>
{
    private readonly ISender _sender;

    public GetSaludoDeudorEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Get("/deudores/saludo");
        AllowAnonymous();
    }

    public override async Task HandleAsync(EmptyRequest req, CancellationToken ct)
    {
        var result = await _sender.Send(new GetSaludoDeudorQuery(), ct);
        await Send.ResponseAsync(result);
    }
}
