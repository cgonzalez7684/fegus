

namespace efGate.WebAPI
{
    public static class DependencyInjection
    {

        public static IServiceCollection AddPresentation(this IServiceCollection services)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {

                var azureAd = services.BuildServiceProvider()
                    .GetRequiredService<IConfiguration>()
                    .GetSection("AzureAd");
            

                options.Authority = $"{azureAd["Instance"]}{azureAd["TenantId"]}/v2.0"; 
                options.Audience = azureAd["Audience"];   

                /*options.Authority =
                    "https://login.microsoftonline.com/organizations/v2.0";*/

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true
                };
            });

            services.AddCors(opt =>
            {
                opt.AddPolicy("AllowAll", builder =>
                {
                    builder.AllowAnyOrigin()
                           .AllowAnyMethod()
                           .AllowAnyHeader();
                });
            });


            services.AddAuthorization(op=>
            {
                op.AddPolicy("AuthenticatedUser", policy =>
                {
                    policy.RequireAuthenticatedUser();
                    //policy.RequireClaim("scp", "access_as_user");
                });
            });
            services.AddFastEndpoints();
            services.SwaggerDocument();
            //services.AddEndpointsApiExplorer();

            
            /*services.AddSwaggerGen(options =>
            {
                options.EnableAnnotations();
                //options.ExampleFilters();
            });*/

            //services.AddScoped<IDbConnectionFactory, NpgsqlConnectionFactory>();

            //services.AddEndpoints(Assembly.GetExecutingAssembly());

            // REMARK: If you want to use Controllers, you'll need this.
            //services.AddControllers();


            return services;
        }
    }
}
