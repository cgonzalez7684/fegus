using Infrastructure.Interfaces;

namespace Infrastructure.Persistence.Loading;

public sealed class LoadingRepository : ILoadingRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public LoadingRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IReadOnlyList<(int IdCliente, long IdLoad)>> GetBoxesReadyForLoadingAsync(
        CancellationToken ct)
    {
        // Boxes in STAGING where every session is COMPLETED and at least one session exists.
        const string sql = """
            SELECT b.id_cliente, b.id_load
            FROM fegusconfig.fe_box_data_load b
            WHERE b.state_code = 'STAGING'
              AND b.is_active  = 'A'
              AND EXISTS (
                  SELECT 1
                  FROM fegusconfig.fe_ingestion_sessions s
                  WHERE s.id_cliente = b.id_cliente
                    AND s.id_load    = b.id_load
              )
              AND NOT EXISTS (
                  SELECT 1
                  FROM fegusconfig.fe_ingestion_sessions s
                  WHERE s.id_cliente          = b.id_cliente
                    AND s.id_load             = b.id_load
                    AND s.session_state_code != 'COMPLETED'
              )
            ORDER BY b.created_at_utc ASC;
            """;

        await using var conn = await _connectionFactory.CreateConnectionAsync(ct);

        var rows = await conn.QueryAsync<(int id_cliente, long id_load)>(
            new CommandDefinition(sql, cancellationToken: ct));

        return rows
            .Select(r => (r.id_cliente, r.id_load))
            .ToList();
    }

    public async Task<IReadOnlyList<DatasetLoadResult>> LoadAllDatasetsAsync(
        int idCliente,
        long idLoad,
        CancellationToken ct)
    {
        const string sql = """
            SELECT dataset, pqty, psqlcode, psqlmessage
            FROM fegusdata.fn_load_all_datasets_from_raw(@p_id_cliente, @p_id_load);
            """;

        await using var conn = await _connectionFactory.CreateConnectionAsync(ct);

        var rows = await conn.QueryAsync(
            new CommandDefinition(
                sql,
                new { p_id_cliente = idCliente, p_id_load = idLoad },
                cancellationToken: ct));

        return rows
            .Select(r => new DatasetLoadResult(
                (string)r.dataset,
                (int)r.pqty,
                (string)(r.psqlcode ?? "00000"),
                (string)(r.psqlmessage ?? "OK")))
            .ToList();
    }
}
