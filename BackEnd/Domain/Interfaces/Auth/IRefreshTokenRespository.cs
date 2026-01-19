using System;
using Domain.DTOs.Auth;

namespace Domain.Interfaces.Auth;

public interface IRefreshTokenRepository
{
    Task<RefreshTokenRow?> GetByTokenAsync(string token, CancellationToken ct);
    Task SaveAsync(RefreshTokenRow token, CancellationToken ct);
    Task RevokeAsync(int id, CancellationToken ct);
}