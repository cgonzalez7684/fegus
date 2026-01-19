using Application.Feactures.Auth.Login.Queries;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.Auth;

public sealed class RefreshTokenEndpoint
    : Endpoint<GetRefreshTokenQuery, Result<GetRefreshTokenResponse>>
{
    private readonly ISender _sender;

    public RefreshTokenEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/auth/refresh");
        AllowAnonymous();

        Summary(s =>
        {
            s.Summary = "Refresh access token";
            s.Description = "Generates a new JWT using a valid refresh token";
        });
    }

    public override async Task HandleAsync(
        GetRefreshTokenQuery req,
        CancellationToken ct)
    {
        var command = new GetRefreshTokenQuery(req.RefreshToken);
        var result = await _sender.Send(command, ct);
        await Send.ResponseAsync(result);
    }
}
