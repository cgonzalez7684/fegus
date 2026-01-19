
using System.Text;
using Infrastructure.Auth;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace efGate.WebAPI;


public static class DependencyInjection
{
    public static IServiceCollection AddPresentation(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // =========================
        // JWT Options
        // =========================
        services.Configure<JwtOptions>(
            configuration.GetSection("Jwt"));

        var jwtOptions = configuration
            .GetSection("Jwt")
            .Get<JwtOptions>()
            ?? throw new InvalidOperationException("JWT configuration section is missing");

        var keyBytes = Encoding.UTF8.GetBytes(jwtOptions.Key);

        // =========================
        // Authentication (JWT Bearer)
        // =========================
        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.RequireHttpsMetadata = true;
                options.SaveToken = true;

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidIssuer = jwtOptions.Issuer,

                    ValidateAudience = true,
                    ValidAudience = jwtOptions.Audience,

                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(keyBytes),

                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromSeconds(30)
                };
            });

        // =========================
        // Authorization
        // =========================
        services.AddAuthorization(options =>
        {
            options.AddPolicy("AuthenticatedUser", policy =>
                policy.RequireAuthenticatedUser());

            // Ejemplo de policy fija
            options.AddPolicy("CREDIT_VIEW", policy =>
                policy.RequireClaim("perm", "CREDIT_VIEW"));

            // Aquí puedes registrar más policies
        });

        return services;
    }
}


