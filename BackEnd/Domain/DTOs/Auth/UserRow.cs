using System;

namespace Domain.DTOs.Auth;

public sealed record UserRow(
    int iduser,
    int idcliente,
    string user_name,
    string user_email,
    string pass_hash,
    string? status,
    string is_active
);
