using System;
using Common.Share;
using Domain.Entities.Ingestion;
using Domain.Enums;
using Domain.Interfaces.Ingestion;
using MediatR;

namespace Application.Feactures.Ingestion.CreateSession;

public sealed class CreateIngestionSessionCommandHandler
    : ICommandHandler<CreateIngestionSessionCommand, Guid>
{
    private readonly IIngestionSessionRepository _repository;

    public CreateIngestionSessionCommandHandler(
        IIngestionSessionRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<Guid>> Handle(
        CreateIngestionSessionCommand command,
        CancellationToken cancellationToken)
    {
        var session = new IngestionSession(
            Guid.NewGuid(),
            command.IdCliente,
            command.Dataset,
            (int)IngestionSessionStatus.Created,
            0L);

        await _repository.AddAsync(session, cancellationToken);

        return Result<Guid>.Success(session.SessionId);
        

        
    }

   
}
