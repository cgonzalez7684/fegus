

namespace API.Endpoints.Deudores;

public class GetDeudorByIdEndpoint : Endpoint<GetDeudorByIdQuery,Result<GetDeudorByIdResponse>>
{
   
    private readonly ISender _sender;

    public GetDeudorByIdEndpoint(ISender sender)
    {
        _sender = sender;
    }
    public override void Configure()
    {
        Get("/deudores/{idCliente:int}/{idDeudor}");
        Policies("AuthenticatedUser");
        //AllowAnonymous();
        Summary(s =>
        {
           s.Summary = "Obtiene del cliente el deudor solicitado" ;
           s.Description = "Invoca el caso de uso GetDeudorByIdQuery";
        });

    }

    //public override async Task<Result<GetDeudorByIdResponse>> HandleAsync(GetDeudorByIdQuery req, CancellationToken ct)
    public override async Task HandleAsync(GetDeudorByIdQuery req, CancellationToken ct)
    {
      
       //await Send.CreatedAtAsync("/deudores/{idCliente:int}/{idDeudor}",)

        var query = new GetDeudorByIdQuery(req.idCliente, req.idDeudor);

        Result<GetDeudorByIdResponse> result = await _sender.Send(query,ct);

        await Send.ResponseAsync(result);   

        

         

        /*if (result.IsSuccess)
        {
           
        }

        await Send.ErrorsAsync(result);*/
        
        //await Send.OkAsync(result);
        
    }

}


// --------------------------------------------------------
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
