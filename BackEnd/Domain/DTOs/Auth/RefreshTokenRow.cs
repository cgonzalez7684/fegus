using System;

namespace Domain.DTOs.Auth;


public class RefreshTokenRow
{
    public RefreshTokenRow(int id_refresh_token, int idcliente, int iduser, string token, DateTime expires_at, bool is_revoked, DateTime created_at, string ip, string user_agent)
    {
        this.id_refresh_token = id_refresh_token;
        this.idcliente = idcliente;
        this.iduser = iduser;
        this.token = token;
        this.expires_at = expires_at;
        this.is_revoked = is_revoked;
        this.created_at = created_at;
        this.ip = ip;
        this.user_agent = user_agent;
    }
    
    public int id_refresh_token { get; set; }
    public int idcliente { get; set; }
    public int iduser { get; set; }
    public string token { get; set; } = string.Empty;
    public DateTime expires_at { get; set; }
    public bool is_revoked { get; set; }
    public DateTime created_at { get; set; }
    public string ip { get; set; } = string.Empty;
    public string user_agent { get; set; } = string.Empty;
}
