using FegusDAgent.Worker;

using FegusDAgent.Application.UseCases.Deudores;
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

var builder = Host.CreateApplicationBuilder(args);

var configuration = builder.Configuration;

// ==============================
// Worker
// ==============================
builder.Services.AddHostedService<Worker>();

// ==============================
// Application
// ==============================
builder.Services.AddScoped<SendDeudoresUseCase>();

// ==============================
// Infrastructure – Database
// ==============================
builder.Services.AddSingleton<IDbConnectionFactory,NpgsqlConnectionFactory>();
    

// ==============================
// Infrastructure – Sources
// ==============================
builder.Services.AddScoped<IEntitySource<Deudor>, DeudoresSource>();

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
// Infrastructure – Checkpoints
// ==============================
builder.Services.AddSingleton<ICheckpointStore>(
    _ => new FileCheckpointStore(
        configuration["Checkpoints:Folder"]!));

var host = builder.Build();
host.Run();
