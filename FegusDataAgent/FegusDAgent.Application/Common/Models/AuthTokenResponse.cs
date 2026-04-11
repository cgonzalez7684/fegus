using System;

namespace FegusDAgent.Application.Common.Models;

public record AuthTokenResponse(
    string AccessToken,
    string RefreshToken
);
