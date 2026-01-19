using System;
using Domain.DTOs.Auth;

namespace Domain.Interfaces.Auth;

public interface IAuthRepository
{
    Task<UserRow?> GetUserByIdAsync(int clientId, int userId, CancellationToken ct);

    Task<UserRow?> GetUserAsync(int clientId, string username, CancellationToken ct);
    Task<IReadOnlyList<string>> GetRolesAsync(int clientId, int userId, CancellationToken ct);
    Task<IReadOnlyList<string>> GetEffectivePermissionsAsync(int clientId, int userId, CancellationToken ct);
}
