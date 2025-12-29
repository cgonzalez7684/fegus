using Common.Share;

namespace Application.Feactures.Deudores.Queries;

public sealed record GetDeudorByIdResponse(DeudorDto pDeudorDto);

public sealed record GetDeudorByIdQuery(int idCliente, string idDeudor):IQuery<GetDeudorByIdResponse>;

public class GetDeudorByIdQueryHandler : IQueryHandler<GetDeudorByIdQuery, GetDeudorByIdResponse>
{
    private readonly IDeudorRepository _deudorRepository;

    public GetDeudorByIdQueryHandler(IDeudorRepository deudorRepository)
    {
        this._deudorRepository = deudorRepository;
    }
    public async Task<Result<GetDeudorByIdResponse>> Handle(GetDeudorByIdQuery request, CancellationToken cancellationToken)
    {

         

        DeudorDto? aux = await _deudorRepository.GetDeudorByIdAsync(request.idCliente,request.idDeudor);
        
        return Result<GetDeudorByIdResponse>.Fail("esto es un error",ErrorType.Conflict);

        //return Result<GetDeudorByIdResponse>.Success(new GetDeudorByIdResponse(aux!));
        
        

    }
}
