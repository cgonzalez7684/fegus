using System;
using Common.Share;
using Domain.Interfaces.Auth;

namespace Application.Feactures.Auth.Login.Queries;


public sealed record GetLogoutResponse(string Message);
public sealed record GetLogoutQuery(string RefreshToken) : IQuery<GetLogoutResponse>;

public class GetLogoutQueryHandler : IQueryHandler<GetLogoutQuery, GetLogoutResponse>
{
    private readonly IRefreshTokenRepository _repo;

    public GetLogoutQueryHandler(
        IRefreshTokenRepository repo)
    {
        _repo = repo;
    }

    public async Task<Result<GetLogoutResponse>> Handle(GetLogoutQuery request, CancellationToken ct)
    {
        var stored = await _repo.GetByTokenAsync(
            request.RefreshToken, ct);

        if (stored is null)
            return Result<GetLogoutResponse>.Fail("Invalid refresh token", ErrorType.Unauthorized);

        await _repo.RevokeAsync(stored.id_refresh_token, ct);

        return Result<GetLogoutResponse>.Success(
            new GetLogoutResponse("Logged out successfully"));
    }
}
