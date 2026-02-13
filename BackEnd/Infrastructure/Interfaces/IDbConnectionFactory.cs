namespace Infrastructure.Interfaces;

public interface IDbConnectionFactory
{
    IDbConnection CreateConnection();

    Task<NpgsqlConnection> CreateConnectionAsync(CancellationToken cancellationToken = default);
}

