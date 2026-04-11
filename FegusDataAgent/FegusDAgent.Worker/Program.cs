using FegusDAgent.Worker;

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
using FegusDAgent.Infrastructure.Checkpoints;
using FegusDAgent.Infrastructure.FegusApi;

var builder = Host.CreateApplicationBuilder(args);

var configuration = builder.Configuration;

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

// ==============================
// Infrastructure – Database
// ==============================
builder.Services.AddSingleton<IDbConnectionFactory,NpgsqlConnectionFactory>();
    

// ==============================
// Infrastructure – Sources
// ==============================
builder.Services.AddScoped<IEntitySource<Deudor>, DeudoresSource>();
builder.Services.AddScoped<IEntitySource<OperacionCredito>, OperacionCreditoSource>();

// ==============================
// Infrastructure – Ingestion API
// ==============================
builder.Services.AddHttpClient<IIngestionSessionClient, HttpIngestionSessionClient>(client =>
{
    client.BaseAddress = new Uri(configuration["IngestionApi:BaseUrl"]!);
    client.Timeout = TimeSpan.FromMinutes(10);
});

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
});

// ==============================
// Infrastructure – Checkpoints
// ==============================
builder.Services.AddSingleton<ICheckpointStore>(
    _ => new FileCheckpointStore(
        configuration["Checkpoints:Folder"]!));

var host = builder.Build();
host.Run();
