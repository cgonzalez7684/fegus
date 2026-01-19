using System;
using Domain.DTOs.Auth;

namespace Domain.Interfaces.Auth;

public interface IJwtTokenService
{
    string CreateAccessToken(AuthUser user);
}