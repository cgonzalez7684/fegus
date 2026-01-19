using Dapper;
using Domain.DTOs.Auth;
using Domain.Interfaces;
using Domain.Interfaces.Auth;
using Npgsql;

namespace Infrastructure.Persistence.Repositories;


public sealed class AuthRepository : IAuthRepository
{
    private readonly string _cs;
    public AuthRepository(IConfiguration cfg) => _cs = cfg.GetConnectionString("Postgres")!;

    private NpgsqlConnection Open() => new(_cs);

    public async Task<UserRow?> GetUserByIdAsync(int clientId, int userId, CancellationToken ct){
        const string sql = """
        SELECT u.iduser, u.idcliente, u.user_name, u.user_email, u.pass_hash, u.status, u.is_active
        FROM fegusseg.users u
        WHERE u.idcliente = @client_id AND u.iduser = @user_id
        LIMIT 1;
        """;

        await using var cn = Open();
        return await cn.QuerySingleOrDefaultAsync<UserRow>(new CommandDefinition(
            sql, new { client_id = clientId, user_id = userId }, cancellationToken: ct));
    }

    public async Task<UserRow?> GetUserAsync(int clientId, string username, CancellationToken ct)
    {
        const string sql = """
        SELECT u.iduser, u.idcliente, u.user_name, u.user_email, u.pass_hash, u.status, u.is_active
        FROM fegusseg.users u
        WHERE u.idcliente = @client_id AND u.user_name = @username
        LIMIT 1;
        """;

        await using var cn = Open();
        return await cn.QuerySingleOrDefaultAsync<UserRow>(new CommandDefinition(
            sql, new { client_id = clientId, username }, cancellationToken: ct));
    }

    public async Task<IReadOnlyList<string>> GetRolesAsync(int clientId, int userId, CancellationToken ct)
    {
        const string sql = """
        SELECT r.role_name
        FROM fegusseg.user_roles ur
        JOIN fegusseg.roles r
          ON r.idrole = ur.idrole AND r.idcliente = ur.idcliente
        WHERE ur.idcliente = @client_id AND ur.iduser = @user_id
          AND r.is_active = 'Y';
        """;

        await using var cn = Open();
        var rows = await cn.QueryAsync<string>(new CommandDefinition(
            sql, new { client_id = clientId, user_id = userId }, cancellationToken: ct));
        return rows.ToList();
    }

    public async Task<IReadOnlyList<string>> GetEffectivePermissionsAsync(int clientId, int userId, CancellationToken ct)
    {
        const string sql = """
        SELECT DISTINCT p.permiss_code
        FROM fegusseg.user_roles ur
        JOIN fegusseg.role_permissions rp
          ON rp.idrole = ur.idrole AND rp.idcliente = ur.idcliente
        JOIN fegusseg.permissions p
          ON p.idpermiss = rp.idpermiss AND p.idcliente = rp.idcliente
        WHERE ur.idcliente = @client_id AND ur.iduser = @user_id AND p.is_active = 'Y'

        UNION

        SELECT DISTINCT p.permiss_code
        FROM fegusseg.user_permissions up
        JOIN fegusseg.permissions p
          ON p.idpermiss = up.idpermiss AND p.idcliente = up.idcliente
        WHERE up.idcliente = @client_id AND up.iduser = @user_id AND p.is_active = 'Y';
        """;

        await using var cn = Open();
        var rows = await cn.QueryAsync<string>(new CommandDefinition(
            sql, new { client_id = clientId, user_id = userId }, cancellationToken: ct));
        return rows.ToList();
    }
}
