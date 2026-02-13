using Dapper;
using Domain.Entities.Ingestion;
using Domain.Interfaces.Ingestion;
using Infrastructure.Interfaces;
using Infrastructure.Persistence.ConnetionFactory;

namespace Infrastructure.Ingestion.Persistence;


public sealed class IngestionSessionRepository : IIngestionSessionRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    private sealed record IngestionSessionDbRow(
    Guid SessionId,
    int IdCliente,
    string Dataset,
    int Status,
    long LastSequencePersisted,
    DateTime CreatedAtUtc
    );


    public IngestionSessionRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task AddAsync(
        IngestionSession session,
        CancellationToken cancellationToken)
    {
        const string sql = """
            INSERT INTO fegusdata.ingestion_sessions
            (id_cliente,session_id, dataset, status, last_sequence, created_at_utc)
            VALUES (@IdCliente, @SessionId, @Dataset, @Status, @LastSequence, @CreatedAtUtc)
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        await conn.ExecuteAsync(
            new CommandDefinition(sql, new
            {
                session.IdCliente,
                session.SessionId,
                session.Dataset,
                Status = Convert.ToInt32(session.Status),
                LastSequence = session.LastSequencePersisted,
                session.CreatedAtUtc
            }, cancellationToken: cancellationToken));
    }

    public async Task<IngestionSession?> GetByIdAsync(
        Guid sessionId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                session_id      AS SessionId,
                id_cliente       AS IdCliente,                
                dataset         AS Dataset,
                status          AS Status,
                last_sequence   AS LastSequencePersisted,
                created_at_utc  AS CreatedAtUtc
            FROM fegusdata.ingestion_sessions
            WHERE session_id = @SessionId
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var row = await conn.QuerySingleOrDefaultAsync<IngestionSessionDbRow>(
            new CommandDefinition(sql, new { SessionId = sessionId }, cancellationToken: cancellationToken));

        if (row is null)
            return null;

        var session = new IngestionSession(
            row.SessionId,                 // Guid
            row.IdCliente,                 // int
            row.Dataset,                    // string
            row.Status,
            row.LastSequencePersisted
        );
        session.UpdateLastSequence((long)row.LastSequencePersisted);

         if (row.Status == (int)Domain.Enums.IngestionSessionStatus.Completed)
                session.MarkCompleted();
            else if (row.Status == (int)Domain.Enums.IngestionSessionStatus.Failed)
                session.MarkFailed();

        /*if (Enum.TryParse(row.Status, out Domain.Enums.IngestionSessionStatus status))
        {
            if (status == Domain.Enums.IngestionSessionStatus.Completed)
                session.MarkCompleted();
            else if (status == Domain.Enums.IngestionSessionStatus.Failed)
                session.MarkFailed();
        }*/

        return session;
    }

    public async Task UpdateAsync(
        IngestionSession session,
        CancellationToken cancellationToken)
    {
        const string sql = """
            UPDATE fegusdata.ingestion_sessions
            SET
                status = @Status,
                last_sequence = @LastSequence
            WHERE 
                id_cliente = @IdCliente AND session_id = @SessionId
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        await conn.ExecuteAsync(
            new CommandDefinition(sql, new
            {                
                Status = Convert.ToInt32(session.Status),
                LastSequence = session.LastSequencePersisted,
                session.IdCliente,
                session.SessionId,
            }, cancellationToken: cancellationToken));
    }
}
