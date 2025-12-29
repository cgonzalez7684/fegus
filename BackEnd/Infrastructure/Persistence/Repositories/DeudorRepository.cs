namespace Infrastructure.Persistence.Repositories;

public class DeudorRepository : IDeudorRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public DeudorRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<DeudorDto?> GetDeudorByIdAsync(int idCliente, string idDeudor)
    {
        using var connection = _connectionFactory.CreateConnection();

        throw new Exception("Esteee es un error");
        
        var sql = """
            SELECT *
            FROM fegusdata.obtener_deudores(@p_id_cliente,@p_iddeudor)           
        """;
        

        /*var sql = """
            SELECT *
            FROM fegusdata.obtener_deudores(200,'454552744')           
        """;*/

        return await connection.QueryFirstOrDefaultAsync<DeudorDto>(
            sql,
            new { IdCliente = idCliente, IdDeudor = idDeudor }
        );
    }
}

