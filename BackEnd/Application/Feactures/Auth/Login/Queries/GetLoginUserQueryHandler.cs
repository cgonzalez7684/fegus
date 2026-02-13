using Common.Share;
using Domain.DTOs.Auth;
using Domain.Interfaces.Auth;


namespace Application.Feactures.Auth.Login.Queries;


public sealed record GetLoginUserResponse(
    string AccessToken,
    string RefreshToken
);

public sealed record GetLoginUserQuery(
    int idCliente,
    string Username,
    string Password
) : IQuery<GetLoginUserResponse>;


public sealed class GetLoginUserQueryHandler : IQueryHandler<GetLoginUserQuery, GetLoginUserResponse>
{
    private readonly IAuthRepository _repo;
    private readonly IJwtTokenService _jwt;
    private readonly IRefreshTokenRepository _refreshTokenRepo;

    public GetLoginUserQueryHandler(
        IAuthRepository repo,
        IJwtTokenService jwt,
        IRefreshTokenRepository refreshTokenRepo)
    {
        _repo = repo;
        _jwt = jwt;
        this._refreshTokenRepo = refreshTokenRepo;
    }

    public async Task<Result<GetLoginUserResponse>> Handle(
        GetLoginUserQuery request,
        CancellationToken ct)
    {
        var user = await _repo.GetUserAsync(
            request.idCliente,
            request.Username,
            ct);

        if (user is null)
            return Result<GetLoginUserResponse>.Fail("Invalid credentials", ErrorType.Unauthorized);
            

        if (user.is_active != "Y" || user.status != "A")
            return Result<GetLoginUserResponse>.Fail("User inactive or locked", ErrorType.Unauthorized);
            

        if (!BCrypt.Net.BCrypt.Verify(request.Password, user.pass_hash))
           return Result<GetLoginUserResponse>.Fail("Invalid credentials", ErrorType.Unauthorized);
            

        var roles = await _repo.GetRolesAsync(
            user.idcliente,
            user.iduser,
            ct);

        var permissions = await _repo.GetEffectivePermissionsAsync(
            user.idcliente,
            user.iduser,
            ct);

        var authUser = new AuthUser(
            IdUser: user.iduser,
            IdCliente: user.idcliente,
            Username: user.user_name,
            Email: user.user_email,
            Roles: roles,
            Permissions: permissions
        );

        var token = _jwt.CreateAccessToken(authUser);

        var refreshToken = Guid.NewGuid().ToString("N");

        await _refreshTokenRepo.SaveAsync(
            new RefreshTokenRow(
                id_refresh_token: 0,                // SERIAL, no importa
                idcliente: user.idcliente,
                iduser: user.iduser,
                token: refreshToken,
                expires_at: DateTime.UtcNow.AddDays(7),
                is_revoked: false,
                created_at:  DateTime.UtcNow,
                ip: "",                             // TODO: obtener IP
                user_agent: ""                      // TODO: obtener User-Agent
            ),
            ct
        );

        
        return Result<GetLoginUserResponse>.Success(new GetLoginUserResponse(token, refreshToken));

        
    }
}
