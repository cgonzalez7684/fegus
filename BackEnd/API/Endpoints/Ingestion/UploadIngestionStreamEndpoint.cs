
namespace API.Endpoints.Ingestion;

public sealed class UploadIngestionStreamEndpoint
    : EndpointWithoutRequest
{
    private readonly ISender _sender;

    public UploadIngestionStreamEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/ingestion/sessions/{sessionId:guid}/stream");
        Policies("Ingestion"); // Requiere el rol "ingestion.agent"
        
        
    }

    public override async Task HandleAsync(CancellationToken ct)
    {
        /*var sessionId = Route<Guid>("sessionId");

        if (Files.Count == 0)
            ThrowError("No se recibió archivo");

        var file = Files[0];

        await using var stream = file.OpenReadStream();       

        await _sender.Send(
            new ReceiveIngestionStreamCommand(
                sessionId,
                stream),
            ct);   */

        var sessionId = Route<Guid>("sessionId");

        var stream = HttpContext.Request.Body;

        if (stream is null || !stream.CanRead)
            ThrowError("No se recibió ningún stream en el cuerpo de la solicitud");
       

        await _sender.Send(
            new ReceiveIngestionStreamCommand(
                sessionId,
                stream),
            ct);         



        await Send.OkAsync();

        
    }
}
