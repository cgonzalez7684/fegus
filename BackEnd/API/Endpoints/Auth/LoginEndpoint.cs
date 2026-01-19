using Application.Feactures.Auth.Login.Queries;

namespace API.Endpoints.Auth;


public sealed class LoginEndpoint
    : Endpoint<GetLoginUserQuery, Result<GetLoginUserResponse>>
{
    private readonly ISender _sender;

    public LoginEndpoint(ISender sender)
    {
        _sender = sender;
    }

    public override void Configure()
    {
        Post("/auth/login");
        AllowAnonymous();

        Summary(s =>
        {
            s.Summary = "User authentication";
            s.Description = "Authenticates user credentials and returns a JWT access token";
        });
    }

    public override async Task HandleAsync(GetLoginUserQuery req, CancellationToken ct)
    {
        var command = new GetLoginUserQuery(
            req.idCliente,
            req.Username,
            req.Password);

        var result = await _sender.Send(command, ct);

        await Send.ResponseAsync(result);
    }
}
