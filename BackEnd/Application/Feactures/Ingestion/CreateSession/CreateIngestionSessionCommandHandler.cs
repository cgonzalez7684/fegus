using System;
using Common.Share;
using Domain.Entities.Ingestion;
using Domain.Enums;
using Domain.Interfaces.Ingestion;
using MediatR;

namespace Application.Feactures.Ingestion.CreateSession;

public sealed class CreateIngestionSessionCommandHandler
    : ICommandHandler<CreateIngestionSessionCommand, IngestionSession>
{
    private readonly IIngestionSessionRepository _repository;

    public CreateIngestionSessionCommandHandler(
        IIngestionSessionRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<IngestionSession>> Handle(
        CreateIngestionSessionCommand command,
        CancellationToken cancellationToken)
    {
        var session = new IngestionSession(
            Guid.NewGuid(),
            command.IdCliente,
            command.IdLoad,
            command.Dataset,
            IngestionSessionStatus.Created.ToString(),
            0L);

        var aux = await _repository.AddAsync(session, cancellationToken);

        return Result<IngestionSession>.Success(aux);
        

        
    }

   
}
