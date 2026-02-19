using Common.Share;

namespace Application.Feactures.Deudores.Queries;

public sealed record GetDeudoresResponse(IEnumerable<Deudor> result);

public sealed record GetDeudoresQuery(int idCliente):IQuery<GetDeudoresResponse>;

public class GetDeudoresQueryHandler : IQueryHandler<GetDeudoresQuery, GetDeudoresResponse>
{
    private readonly IDeudorRepository _deudorRepository;

    public GetDeudoresQueryHandler(IDeudorRepository deudorRepository)
    {
        this._deudorRepository = deudorRepository;
    }
    public async Task<Result<GetDeudoresResponse>> Handle(GetDeudoresQuery request, CancellationToken cancellationToken)
    {

        IEnumerable<Deudor> aux = await _deudorRepository.GetDeudoresAsync(request.idCliente);

        return Result<GetDeudoresResponse>.Success(new GetDeudoresResponse(aux));
        
    }
}
