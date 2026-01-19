using System;
using Domain.DTOs.Auth;
using Domain.Interfaces.Auth;

namespace Infrastructure.Persistence.Repositories;

public sealed class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly string _cs;
    public RefreshTokenRepository(IConfiguration cfg)
        => _cs = cfg.GetConnectionString("Postgres")!;

    private NpgsqlConnection Open() => new(_cs);

    public async Task<RefreshTokenRow?> GetByTokenAsync(
        string token, CancellationToken ct)
    {
        const string sql = """
        SELECT *
        FROM fegusseg.refresh_tokens
        WHERE token = @token
        LIMIT 1;
        """;

        await using var cn = Open();
        return await cn.QuerySingleOrDefaultAsync<RefreshTokenRow>(
            new CommandDefinition(sql, new { token }, cancellationToken: ct));
    }

    public async Task SaveAsync(
        RefreshTokenRow token, CancellationToken ct)
    {
        const string sql = """
        INSERT INTO fegusseg.refresh_tokens
        (idcliente, iduser, token, expires_at)
        VALUES (@idcliente, @iduser, @token, @expires_at);
        """;

        await using var cn = Open();
        await cn.ExecuteAsync(
            new CommandDefinition(sql, token, cancellationToken: ct));
    }

    public async Task RevokeAsync(int id, CancellationToken ct)
    {
        const string sql = """
        UPDATE fegusseg.refresh_tokens
        SET is_revoked = TRUE
        WHERE id_refresh_token = @id;
        """;

        await using var cn = Open();
        await cn.ExecuteAsync(
            new CommandDefinition(sql, new { id }, cancellationToken: ct));
    }
}
