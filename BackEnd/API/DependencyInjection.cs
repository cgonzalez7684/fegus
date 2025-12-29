

namespace efGate.WebAPI
{
    public static class DependencyInjection
    {

        public static IServiceCollection AddPresentation(this IServiceCollection services)
        {

            

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
