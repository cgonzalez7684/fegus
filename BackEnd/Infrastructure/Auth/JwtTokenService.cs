using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Domain.Interfaces.Auth;
using Domain.DTOs.Auth;

namespace Infrastructure.Auth;


public sealed class JwtTokenService : IJwtTokenService
{
    private readonly JwtOptions _opt;

    public JwtTokenService(IOptions<JwtOptions> options)
    {
        _opt = options.Value;
    }

    public string CreateAccessToken(AuthUser user)
    {
        var now = DateTime.UtcNow;

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.UserId.ToString()),
            new("client_id", user.ClientId.ToString()),
            new("username", user.Username),
            new(JwtRegisteredClaimNames.Email, user.Email),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new(JwtRegisteredClaimNames.Iat, ((DateTimeOffset)now).ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64)
        };

        // Roles (para [Authorize(Roles="...")])
        claims.AddRange(user.Roles.Select(r => new Claim(ClaimTypes.Role, r)));

        // Permisos (para policies)
        claims.AddRange(user.Permissions.Select(p => new Claim("perm", p)));

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_opt.Key));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _opt.Issuer,
            audience: _opt.Audience,
            claims: claims,
            notBefore: now,
            expires: now.AddMinutes(_opt.AccessTokenMinutes),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
