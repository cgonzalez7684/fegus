using System;
using Common.Share;
using MediatR;

namespace Application.Feactures.Deudores.Queries;


public sealed record GetSaludoDeudorResponse(string Saludo);
public sealed record GetSaludoDeudorQuery() : IQuery<GetSaludoDeudorResponse>;



public class GetSaludoDeudorQueryHandler : IQueryHandler<GetSaludoDeudorQuery, GetSaludoDeudorResponse>
{
    public async Task<Result<GetSaludoDeudorResponse>> Handle(GetSaludoDeudorQuery request, CancellationToken cancellationToken)
    {
        return Result<GetSaludoDeudorResponse>.Success(new GetSaludoDeudorResponse("¡Hola, Mundo!"));        
    }

 
}
