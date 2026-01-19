using System;

namespace Domain.DTOs.Auth;

public sealed record RefreshTokenRow(
    int id_refresh_token,
    int idcliente,
    int iduser,
    string token,
    DateTime expires_at,
    bool is_revoked,
    string ip,
    string user_agent
);
