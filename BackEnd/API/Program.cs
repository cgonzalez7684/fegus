using Application.Interfaces;
using Infrastructure.Persistence.ConnetionFactory;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

builder.Services.AddScoped<IDbConnectionFactory, NpgsqlConnectionFactory>();



var app = builder.Build();

// Configure the HTTP request pipeline.
app.MapControllers();

app.Run();
