
using System.Text;
using Infrastructure.Auth;
using Infrastructure.Storage.Ingestion;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace efGate.WebAPI;


public static class DependencyInjection
{
    public static IServiceCollection AddPresentation(
        this IServiceCollection services,
        IConfiguration configuration)
    {

        services.AddFastEndpoints();

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
            options.AddPolicy("Ingestion", policy =>
                policy.RequireRole("ingestion.agent")                
               );

            // Aquí puedes registrar más policies
        });

        /*var allowedOrigins = configuration
            .GetSection("Cors:AllowedOrigins")
            .Get<string[]>();

        services.AddCors(options =>
        {
            options.AddPolicy("FegusCorsPolicy", policy =>
            {
                    policy
                        .WithOrigins(allowedOrigins ?? Array.Empty<string>())                        
                        .AllowAnyMethod()
                        .AllowAnyHeader();
                });
        });*/

         services.AddCors(options =>
        {
            options.AddPolicy("FegusCorsPolicy", policy =>
            {
                    policy.AllowAnyOrigin()
                    .AllowAnyMethod()
                    .AllowAnyHeader();
                });
        });

        services.Configure<IngestionStorageOptions>(
        configuration.GetSection("IngestionStorage"));

        services.AddSingleton<TempFileStorage>(sp =>
        {
            var options = sp
                .GetRequiredService<IOptions<IngestionStorageOptions>>()
                .Value;

            if (string.IsNullOrWhiteSpace(options.TempStoragePath))
                throw new InvalidOperationException(
                    "Ingestion:TempStoragePath is not configured");

            return new TempFileStorage(options.TempStoragePath);
        });


         

        return services;
    }
}


