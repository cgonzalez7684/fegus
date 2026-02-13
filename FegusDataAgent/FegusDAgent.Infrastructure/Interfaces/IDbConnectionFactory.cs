using System;
using System.Data;
using Npgsql;

namespace FegusDAgent.Infrastructure.Interfaces;

public interface IDbConnectionFactory
{
    IDbConnection CreateConnection();

    Task<NpgsqlConnection> CreateConnectionAsync(CancellationToken cancellationToken = default);
}
