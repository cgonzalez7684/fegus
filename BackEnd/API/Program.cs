

using API.Middleware;
using Application;
using efGate.WebAPI;
using Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
//builder.Services.AddControllers();

builder.Host.UseSerilog((ctx, lc) =>
{
    lc.ReadFrom.Configuration(ctx.Configuration)
      .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
      .Enrich.FromLogContext();
});

builder.Services
.AddApplication()
.AddInfrastructure()
.AddPresentation();





var app = builder.Build();



// Configure the HTTP request pipeline.
//app.MapControllers();

app.UseSerilogRequestLogging(opts =>
{
    opts.EnrichDiagnosticContext = (diagCtx, httpCtx) =>
    {
        diagCtx.Set("TraceId", httpCtx.TraceIdentifier);
        diagCtx.Set("RequestPath", httpCtx.Request.Path.Value);
        diagCtx.Set("RequestMethod", httpCtx.Request.Method);
        diagCtx.Set("RemoteIP", httpCtx.Connection.RemoteIpAddress?.ToString());
        diagCtx.Set("UserAgent", httpCtx.Request.Headers.UserAgent.ToString());
    };
});

app.UseMiddleware<ExceptionLoggingMiddleware>();

// app.UseFastEndpoints();
// app.UseSwaggerGen();

app.UseCors("AllowAll");

app.UseFastEndpoints();
app.UseSwaggerGen();

app.Run();
