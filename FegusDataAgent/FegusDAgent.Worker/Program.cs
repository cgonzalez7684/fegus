using FegusDAgent.Worker;

using FegusDAgent.Application.Common.Options;
using FegusDAgent.Application.UseCases;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.ConnectionFactory;
using FegusDAgent.Infrastructure.Ingestion.Streaming;
using FegusDAgent.Infrastructure.Persistence;
using FegusDAgent.Infrastructure.Interfaces;
using Microsoft.Extensions.Hosting;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Infrastructure.Ingestion;
using Microsoft.Extensions.Http;
using Microsoft.Extensions.Http.Resilience;
using FegusDAgent.Infrastructure.FegusApi;
using FegusDAgent.Application.UseCases.Fegus;
using FegusDAgent.Application.UseCases.FegusLocal;
using FegusDAgent.Application.UseCases.Ingestion;
using FegusDAgent.Application.Logging;
using FegusDAgent.Infrastructure.Logging;
using NLog.Extensions.Logging;
using Polly;
using Polly.Retry;

var builder = Host.CreateApplicationBuilder(args);

var configuration = builder.Configuration;

// ==============================
// Logging — NLog
// ==============================
builder.Logging.ClearProviders();
builder.Logging.AddNLog();

// ==============================
// EventLog options + IEventLogger<>
// ==============================
builder.Services.Configure<EventLogOptions>(
    configuration.GetSection(EventLogOptions.SectionName));
builder.Services.AddTransient(typeof(IEventLogger<>), typeof(EventLogger<>));

builder.Services.Configure<SaludoWorkerOptions>(
    configuration.GetSection(SaludoWorkerOptions.SectionName));

// ==============================
// Worker
// ==============================
builder.Services.AddHostedService<Worker>();

// ==============================
// Application
// ==============================
builder.Services.AddScoped<SendDeudoresUseCase>();
builder.Services.AddScoped<SendOperacionCreditoUseCase>();
builder.Services.AddScoped<GetSaludoDeudorUseCase>();
builder.Services.AddScoped<GetNextBoxDataLoadUseCase>();
builder.Services.AddScoped<AuthenticateUseCase>();
builder.Services.AddScoped<UpdateFeBoxDataLoadUseCase>();
builder.Services.AddScoped<CreateBoxDataLoadLocalUseCase>();
builder.Services.AddScoped<DataLoadOrchestrationUseCase>();

// OrchestrationOptions: bridge SaludoWorker config into the Application layer
// without dragging IOptions into Application.
builder.Services.AddSingleton(sp =>
{
    var workerOpts = sp.GetRequiredService<Microsoft.Extensions.Options.IOptions<SaludoWorkerOptions>>().Value;
    return new OrchestrationOptions
    {
        MaxAttemptsPerBox = workerOpts.MaxAttemptsPerBox
    };
});



builder.Services.Configure<FegusApiOptions>(configuration.GetSection(FegusApiOptions.SectionName));
builder.Services.AddSingleton<FegusApiTokenProvider>();
builder.Services.AddSingleton<IFegusAuthClient>(sp => sp.GetRequiredService<FegusApiTokenProvider>());
builder.Services.AddHttpClient("FegusApiAuth", client =>
{
    client.BaseAddress = new Uri(configuration["FegusApi:BaseUrl"]!.TrimEnd('/') + "/");
})
.AddResilienceHandler("transient-retry", AddTransientRetryStrategy);

builder.Services.AddHttpClient<IFegusConfigClient, HttpFegusConfigClient>(client =>
{
    client.BaseAddress = new Uri(configuration["FegusApi:BaseUrl"]!.TrimEnd('/') + "/");
    client.Timeout = TimeSpan.FromSeconds(30);
})
.AddResilienceHandler("transient-retry", AddTransientRetryStrategy);


// ==============================
// Infrastructure – Database
// ==============================
builder.Services.AddSingleton<IDbConnectionFactory,NpgsqlConnectionFactory>();
    

// ==============================
// Infrastructure – Local Repository
// ==============================
builder.Services.AddScoped<IFegusLocalRepository, FegusLocalRepository>();

// ==============================
// Infrastructure – Sources
// ==============================
builder.Services.AddScoped<IEntitySource<Deudor>, DeudoresSource>();
builder.Services.AddScoped<IEntitySource<OperacionCredito>, OperacionCreditoSource>();

// ==============================
// Infrastructure – Ingestion API
// ==============================
builder.Services.Configure<IngestionApiOptions>(configuration.GetSection(IngestionApiOptions.SectionName));
builder.Services.AddHttpClient<IIngestionSessionClient, HttpIngestionSessionClient>(client =>
{
    client.BaseAddress = new Uri(configuration["IngestionApi:BaseUrl"]!);
    client.Timeout = TimeSpan.FromMinutes(10);
})
.AddResilienceHandler("transient-retry", AddTransientRetryStrategy);

// Streaming sender intentionally has NO retry handler: the request body is a one-shot
// gzip stream over ProducerStream and cannot be replayed. Resume on failure happens at
// the use-case level by reusing the in-flight session and continuing from
// LastSequencePersisted.
builder.Services.AddHttpClient<IIngestionStreamSender, HttpIngestionStreamSender>(client =>
{
    client.BaseAddress = new Uri(configuration["IngestionApi:BaseUrl"]!);
    client.Timeout = TimeSpan.FromMinutes(30);
});

// ==============================
// Infrastructure – API Fegus (crediticio / deudores)
// ==============================
builder.Services.AddHttpClient<ISaludoDeudorClient, HttpSaludoDeudorClient>(client =>
{
    var baseUrl = configuration["FegusApi:BaseUrl"]
        ?? throw new InvalidOperationException("Falta configuración FegusApi:BaseUrl.");
    client.BaseAddress = new Uri(baseUrl.TrimEnd('/') + "/");
    client.Timeout = TimeSpan.FromSeconds(30);
})
.AddResilienceHandler("transient-retry", AddTransientRetryStrategy);

var host = builder.Build();
host.Run();

static void AddTransientRetryStrategy(ResiliencePipelineBuilder<HttpResponseMessage> b)
{
    b.AddRetry(new HttpRetryStrategyOptions
    {
        MaxRetryAttempts = 4,
        BackoffType = DelayBackoffType.Exponential,
        UseJitter = true,
        Delay = TimeSpan.FromSeconds(1),
        MaxDelay = TimeSpan.FromSeconds(30),
        ShouldHandle = static args => ValueTask.FromResult(HttpClientResiliencePredicates.IsTransient(args.Outcome))
    });
}
