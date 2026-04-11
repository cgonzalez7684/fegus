using System;
using Dapper;
using Domain.Entities.FegusConfig;
using Infrastructure.Interfaces;
using System.Data;
using Infrastructure.Persistence.Models;
using Infrastructure.Models;
using Common.Share;

namespace Infrastructure.Persistence.Repositories;

public sealed class BoxDataRepository : IBoxDataRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public BoxDataRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<ExecutionResult<long?>> AddFeBoxDataLoadAsync(
        FeBoxDataLoad dataLoad,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT *
            FROM fegusconfig.fn_box_data_load_insert(
                @p_id_cliente,
                @p_state_code,
                @p_is_active,
                @p_asofdate
            );
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var raw = await conn.QueryFirstAsync<BoxInsertDbRawResult>(
            new CommandDefinition(
                sql,
                new
                {
                    p_id_cliente = dataLoad.IdCliente,
                    p_state_code = dataLoad.StateCode,
                    p_is_active = dataLoad.IsActive,
                    p_asofdate = dataLoad.AsofDate
                },
                cancellationToken: cancellationToken
            )
        );

         return new ExecutionResult<long?>
            {
                Data = raw.Pidload,
                SqlCode = raw.Psqlcode,
                SqlMessage = raw.Psqlmessage,
                Qty = raw.Pqty
            };
    }


    public async Task<ExecutionResult<bool>> UpdateFeBoxDataLoadAsync(
    FeBoxDataLoad dataLoad,
    CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT *
            FROM fegusconfig.fn_box_data_load_update(
                @p_id_cliente,
                @p_id_load,
                @p_state_code,
                @p_is_active                
            );
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var raw = await conn.QueryFirstAsync<DbCommandRawResult>(
            new CommandDefinition(
                sql,
                new
                {
                    p_id_cliente = dataLoad.IdCliente,
                    p_id_load = dataLoad.IdLoad,
                    p_state_code = dataLoad.StateCode,
                    p_is_active = dataLoad.IsActive                    
                },
                cancellationToken: cancellationToken
            )
        );

        return new ExecutionResult<bool>
        {
            Data = raw.Pqty > 0,
            SqlCode = raw.Psqlcode,
            SqlMessage = raw.Psqlmessage,
            Qty = raw.Pqty
        };
    }

    public async Task<ExecutionResult<bool>> DeleteFeBoxDataLoadAsync(
    int idCliente,
    long idLoad,
    CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT *
            FROM fegusconfig.fn_box_data_load_delete(
                @p_id_cliente,
                @p_id_load
            );
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var raw = await conn.QueryFirstAsync<DbCommandRawResult>(
            new CommandDefinition(
                sql,
                new
                {
                    p_id_cliente = idCliente,
                    p_id_load = idLoad
                },
                cancellationToken: cancellationToken
            )
        );

        return new ExecutionResult<bool>
        {
            Data = raw.Pqty > 0,
            SqlCode = raw.Psqlcode,
            SqlMessage = raw.Psqlmessage,
            Qty = raw.Pqty
        };
    }


    public async Task<ExecutionResult<IEnumerable<FeBoxDataLoad>>> GetFeBoxDataLoadAsync(
    int idCliente,
    long? idLoad,
    CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT *
            FROM fegusconfig.fn_box_data_load_get(
                @p_id_cliente,
                @p_id_load
            );
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var rows = await conn.QueryAsync(
            new CommandDefinition(
                sql,
                new
                {
                    p_id_cliente = idCliente,
                    p_id_load = idLoad
                },
                cancellationToken: cancellationToken
            )
        );

        var list = rows
            .Where(r => r.pqty > 0)
            .Select(r => new FeBoxDataLoad
            {
                IdCliente = (int)r.id_cliente,
                IdLoad = (int)r.id_load,
                StateCode = r.state_code,
                IsActive = r.is_active,
                AsofDate = r.asofdate,
                CreatedAtUtc = r.created_at_utc,
                UpdatedAtUtc = r.updated_at_utc
            })
            .ToList();

        return new ExecutionResult<IEnumerable<FeBoxDataLoad>>
        {
            Data = list,
            SqlCode = rows.FirstOrDefault()?.psqlcode,
            SqlMessage = rows.FirstOrDefault()?.psqlmessage,
            Qty = list.Count
        };
    }

    public async Task<ExecutionResult<FeBoxDataLoad>> GetNexFeBoxDataLoadAsync(
    int idCliente,    
    CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT *
            FROM fegusconfig.fn_next_box_data_load_get(@p_id_cliente);
        """;

        await using var conn =
            await _connectionFactory.CreateConnectionAsync(cancellationToken);

        var rows = await conn.QueryAsync(
            new CommandDefinition(
                sql,
                new
                {
                    p_id_cliente = idCliente                    
                },
                cancellationToken: cancellationToken
            )
        );

        var list = rows
            .Where(r => r.pqty > 0)
            .Select(r => new FeBoxDataLoad
            {
                IdCliente = (int)r.id_cliente,
                IdLoad = (int)r.id_load,
                StateCode = r.state_code,
                IsActive = r.is_active,
                AsofDate = r.asofdate,
                CreatedAtUtc = r.created_at_utc,
                UpdatedAtUtc = r.updated_at_utc
            })
            .ToList();

        return new ExecutionResult<FeBoxDataLoad>
        {
            Data = list.FirstOrDefault(),
            SqlCode = rows.FirstOrDefault()?.psqlcode,
            SqlMessage = rows.FirstOrDefault()?.psqlmessage,
            Qty = list.Count
        };
    }

}