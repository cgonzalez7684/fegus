

using Application;
using efGate.WebAPI;
using Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
//builder.Services.AddControllers();

builder.Services
.AddApplication()
.AddInfrastructure()
.AddPresentation();





var app = builder.Build();

// Configure the HTTP request pipeline.
//app.MapControllers();
app.UseFastEndpoints();
app.UseSwaggerGen();

app.Run();
