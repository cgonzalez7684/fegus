using System;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Deudores;

public sealed class SendDeudoresUseCase
{
    private readonly IEntitySource<Deudor> _source;
    private readonly IIngestionSessionClient _sessionClient;
    private readonly IIngestionStreamSender _streamSender;
    private readonly ICheckpointStore _checkpointStore;

    public SendDeudoresUseCase(
        IEntitySource<Deudor> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,
        ICheckpointStore checkpointStore)
    {
        _source = source;
        _sessionClient = sessionClient;
        _streamSender = streamSender;
        _checkpointStore = checkpointStore;
    }

    public async Task ExecuteAsync(        
        CancellationToken cancellationToken)
    {
        // 1️⃣ Crear sesión de ingestión
        var session = await _sessionClient.CreateSessionAsync(
            dataset: "deudores",            
            cancellationToken);

        // 2️⃣ Recuperar último checkpoint
        var lastSequence = await _checkpointStore
            .GetLastSequenceAsync(session.SessionId, cancellationToken);

        // 3️⃣ Obtener snapshot completo de deudores
        var deudoresStream = _source
            .StreamAsync(cancellationToken);

        // 4️⃣ Enviar datos por streaming
        await _streamSender.StreamAsync(
            session,
            deudoresStream,
            lastSequence,
            cancellationToken);

        // 5️⃣ Confirmar carga
        await _sessionClient.CommitAsync(
            session.SessionId,
            cancellationToken);
    }
}

