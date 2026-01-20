

using Infrastructure.Persistence.ConnetionFactory;

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
        
        services.AddScoped<IDbConnectionFactory,NpgsqlConnectionFactory>();
        services.AddScoped<IJwtTokenService, JwtTokenService>();
        services.AddScoped<IAuthRepository, AuthRepository>();
        services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
        services.AddScoped<IDeudorRepository,DeudorRepository>();
        
        

        

        return services;
    }

}
