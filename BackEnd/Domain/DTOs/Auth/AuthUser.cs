using System;

namespace Domain.DTOs.Auth;

public sealed record AuthUser(
    int IdUser,
    int IdCliente,
    string Username,
    string Email,
    IReadOnlyList<string> Roles,
    IReadOnlyList<string> Permissions
);