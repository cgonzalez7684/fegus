using System;
using System.Data;
using FegusDAgent.Domain.Interfaces;
using Microsoft.Extensions.Configuration;
using Npgsql;
using FegusDAgent.Infrastructure.Interfaces;

namespace FegusDAgent.Infrastructure.ConnectionFactory;

public class NpgsqlConnectionFactory : IDbConnectionFactory
{
    private readonly string _connectionString;

    public NpgsqlConnectionFactory(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("Postgres")!;
    }

    public IDbConnection CreateConnection()
    {
        var connection = new NpgsqlConnection(_connectionString);
        connection.Open();
        
        return connection;
    }

    public async Task<NpgsqlConnection> CreateConnectionAsync(CancellationToken cancellationToken = default)
    {
        var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync(cancellationToken);        
        return connection;
    }

   
}
