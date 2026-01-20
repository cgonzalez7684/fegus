using Application.Feactures.Auth.Login.Queries;
using FastEndpoints;
using MediatR;

namespace API.Endpoints.Auth;

public sealed class LogoutEndpoint
    : Endpoint<GetLogoutQuery, Result<GetLogoutResponse>>
{
    private readonly ISender _sender;

    public LogoutEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/auth/logout");
        AllowAnonymous(); // usamos refresh token, no JWT

        Summary(s =>
        {
            s.Summary = "Logout user";
            s.Description = "Revokes the refresh token and ends the session";
        });
    }

    public override async Task HandleAsync(
        GetLogoutQuery req,
        CancellationToken ct)
    {
        var query = new GetLogoutQuery(req.RefreshToken);
        var result = await _sender.Send(query, ct);
        await Send.ResponseAsync(result);
    }
}
