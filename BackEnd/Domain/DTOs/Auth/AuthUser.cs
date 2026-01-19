using System;

namespace Domain.DTOs.Auth;

public sealed record AuthUser(
    int UserId,
    int ClientId,
    string Username,
    string Email,
    IReadOnlyList<string> Roles,
    IReadOnlyList<string> Permissions
);