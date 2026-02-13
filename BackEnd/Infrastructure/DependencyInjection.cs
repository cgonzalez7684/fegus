

using Domain.Interfaces.Ingestion;
using Infrastructure.Ingestion.Persistence;
using Infrastructure.Ingestion.Streaming;
using Infrastructure.Interfaces;
using Infrastructure.Persistence.ConnetionFactory;
using Infrastructure.Storage.Ingestion;
using Infrastructure.Streaming.Ingestion;
using Microsoft.Extensions.Options;


namespace Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services)
    {
        
        /*.AddSingleton<IDapperContext>(provider => 
            new DapperContext(configuration.GetConnectionString("connStrLocal")!,
                              configuration.GetConnectionString("connStrNube")!
            ));*/

        services.AddMediatR(cfg =>
        cfg.RegisterServicesFromAssembly(typeof(DependencyInjection).Assembly));
        
        services.AddSingleton<IDbConnectionFactory,NpgsqlConnectionFactory>();
        services.AddScoped<IJwtTokenService, JwtTokenService>();
        services.AddScoped<IAuthRepository, AuthRepository>();
        services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
        services.AddScoped<IDeudorRepository,DeudorRepository>();
        services.AddScoped<IIngestionStreamWriter, PostgresCopyStreamWriter>();
        services.AddScoped<IIngestionSessionRepository, IngestionSessionRepository>();        
        services.AddSingleton<NdjsonStreamReader>();

        return services;
    }

}
