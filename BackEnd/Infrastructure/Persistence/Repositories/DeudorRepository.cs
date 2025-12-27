using System;
using Application.DataObjects;
using Application.Interfaces;
using Dapper;

namespace Infrastructure.Persistence.Repositories;

public class DeudorRepository : IDeudorRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public DeudorRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<DeudorDto?> ObtenerDeudorAsync(int idCliente, string idDeudor)
    {
        using var connection = _connectionFactory.CreateConnection();

        var sql = """
            SELECT *
            FROM fegusdata.obtener_deudores(@p_id_cliente,@p_iddeudor)           
        """;

        return await connection.QueryFirstOrDefaultAsync<DeudorDto>(
            sql,
            new { IdCliente = idCliente, IdDeudor = idDeudor }
        );
    }
}

