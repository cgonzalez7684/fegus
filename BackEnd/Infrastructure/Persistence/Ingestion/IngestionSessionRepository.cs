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
    long IdLoad,
    string Dataset,
    string SessionStateCode,
    long LastSequencePersisted,
    DateTime CreatedAtUtc
    );


    public IngestionSessionRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IngestionSession> AddAsync(
        IngestionSession session,
        CancellationToken cancellationToken)
    {
        const string sql = """
            INSERT INTO fegusconfig.fe_ingestion_sessions
            (id_cliente, id_load, session_id, dataset, session_state_code, last_sequence, created_at_utc)
            VALUES (@IdCliente, @IdLoad, @SessionId, @Dataset, @Session_state_code, @LastSequence, @CreatedAtUtc)
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        await conn.ExecuteAsync(
            new CommandDefinition(sql, new
            {
                session.IdCliente,
                session.IdLoad,
                session.SessionId,
                session.Dataset,
                Session_state_code = session.SessionStateCode,
                LastSequence = session.LastSequencePersisted,
                session.CreatedAtUtc
            }, cancellationToken: cancellationToken));

        return session;    
    }

    public async Task<IngestionSession?> GetByIdAsync(
        Guid sessionId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                session_id      AS SessionId,
                id_cliente       AS IdCliente, 
                id_load          AS IdLoad,               
                dataset         AS Dataset,
                session_state_code AS SessionStateCode,
                last_sequence   AS LastSequencePersisted,
                created_at_utc  AS CreatedAtUtc
            FROM fegusconfig.fe_ingestion_sessions
            WHERE session_id = @SessionId
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var row = await conn.QuerySingleOrDefaultAsync<IngestionSessionDbRow>(
            new CommandDefinition(sql, new { SessionId = sessionId }, cancellationToken: cancellationToken));

        if (row is null)
            return null;

        var session = new IngestionSession(
            row.SessionId,
            row.IdCliente,
            (int)row.IdLoad,
            row.Dataset,
            row.SessionStateCode,
            row.LastSequencePersisted
        );
        session.UpdateLastSequence((long)row.LastSequencePersisted);

         if (row.SessionStateCode == Domain.Enums.IngestionSessionStatus.Completed.ToString())
                session.MarkCompleted();
            else if (row.SessionStateCode == Domain.Enums.IngestionSessionStatus.Failed.ToString())
                session.MarkFailed();

        /*if (Enum.TryParse(row.SessionStateCode, out Domain.Enums.IngestionSessionStatus status))
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
            UPDATE fegusconfig.fe_ingestion_sessions
            SET
                session_state_code = @SessionStateCode,
                last_sequence = @LastSequence
            WHERE 
                id_cliente = @IdCliente AND session_id = @SessionId
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        await conn.ExecuteAsync(
            new CommandDefinition(sql, new
            {                
                SessionStateCode = session.SessionStateCode,
                LastSequence = session.LastSequencePersisted,
                IdCliente = session.IdCliente,
                SessionId = session.SessionId,
            }, cancellationToken: cancellationToken));
    }
}
