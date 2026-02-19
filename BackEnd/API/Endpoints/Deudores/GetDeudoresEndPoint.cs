namespace API.Endpoints.Deudores;

public class GetDeudoresEndpoint : Endpoint<GetDeudoresQuery,Result<GetDeudoresResponse>>
{
   
    private readonly ISender _sender;

    public GetDeudoresEndpoint(ISender sender)
    {
        _sender = sender;
    }
    public override void Configure()
    {
        Get("/crediticio/deudores/{idCliente:int}");
        Policies("AuthenticatedUser");
        //AllowAnonymous();
        Summary(s =>
        {
           s.Summary = "Obtiene del cliente el deudor solicitado" ;
           s.Description = "Invoca el caso de uso GetDeudoresQuery";
        });

    }
    
    public override async Task HandleAsync(GetDeudoresQuery req, CancellationToken ct)
    {
      
        var query = new GetDeudoresQuery(req.idCliente);

        Result<GetDeudoresResponse> result = await _sender.Send(query,ct);

        await Send.ResponseAsync(result);  
    }

}