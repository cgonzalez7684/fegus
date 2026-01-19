using System;
using Common.Share;
using Domain.DTOs.Auth;
using Domain.Interfaces.Auth;

namespace Application.Feactures.Auth.Login.Queries;


public sealed record GetRefreshTokenResponse(string NewAccessToken);
public sealed record GetRefreshTokenQuery(string RefreshToken) : IQuery<GetRefreshTokenResponse>;

public class GetRefreshTokenQueryHandler : IQueryHandler<GetRefreshTokenQuery, GetRefreshTokenResponse>
{   
    private readonly IRefreshTokenRepository _repo;
    private readonly IJwtTokenService _jwt;
    private readonly IAuthRepository _authRepo;

    public GetRefreshTokenQueryHandler(
        IRefreshTokenRepository repo,
        IJwtTokenService jwt,
        IAuthRepository authRepo)
    {
        _repo = repo;
        _jwt = jwt;
        _authRepo = authRepo;
    }

    public async Task<Result<GetRefreshTokenResponse>> Handle(GetRefreshTokenQuery request, CancellationToken ct)
    {
        var stored = await _repo.GetByTokenAsync(
            request.RefreshToken, ct);

        if (stored is null)
            return Result<GetRefreshTokenResponse>.Fail("Invalid refresh token", ErrorType.Unauthorized);
            

        if (stored.is_revoked || stored.expires_at <= DateTime.UtcNow)
            return Result<GetRefreshTokenResponse>.Fail("Expired or revoked refresh token", ErrorType.Unauthorized);
            

        // Revocar token usado (rotación)
        await _repo.RevokeAsync(stored.id_refresh_token, ct);

        // Recargar usuario
        var user = await _authRepo.GetUserByIdAsync(
            stored.idcliente, stored.iduser, ct);

        if (user is null)
            return Result<GetRefreshTokenResponse>.Fail("User not found", ErrorType.Unauthorized);
            

        var roles = await _authRepo.GetRolesAsync(
            stored.idcliente, stored.iduser, ct);

        var perms = await _authRepo.GetEffectivePermissionsAsync(
            stored.idcliente, stored.iduser, ct);

        var authUser = new AuthUser(
            user.iduser,
            user.idcliente,
            user.user_name,
            user.user_email,
            roles,
            perms
        );

        var newAccessToken = _jwt.CreateAccessToken(authUser);

        return Result<GetRefreshTokenResponse>.Success(new GetRefreshTokenResponse(newAccessToken));

        
    }


}
