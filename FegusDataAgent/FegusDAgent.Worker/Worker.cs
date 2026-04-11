using System.Threading.Channels;
using FegusDAgent.Application.UseCases;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace FegusDAgent.Worker;

public class Worker(
    ILogger<Worker> logger,
    IServiceScopeFactory scopeFactory,
    IOptions<SaludoWorkerOptions> options) : BackgroundService
{
    private long _jobSequence;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var opts = options.Value;

        if (opts.ConsumerCount < 1)
            throw new InvalidOperationException($"{SaludoWorkerOptions.SectionName}:{nameof(SaludoWorkerOptions.ConsumerCount)} debe ser >= 1.");

        if (opts.ParallelJobsPerTick < 1)
            throw new InvalidOperationException($"{SaludoWorkerOptions.SectionName}:{nameof(SaludoWorkerOptions.ParallelJobsPerTick)} debe ser >= 1.");

        if (opts.PollIntervalSeconds < 1)
            throw new InvalidOperationException($"{SaludoWorkerOptions.SectionName}:{nameof(SaludoWorkerOptions.PollIntervalSeconds)} debe ser >= 1.");

        if (opts.ChannelCapacity < 1)
            throw new InvalidOperationException($"{SaludoWorkerOptions.SectionName}:{nameof(SaludoWorkerOptions.ChannelCapacity)} debe ser >= 1.");

        var channel = Channel.CreateBounded<SaludoJob>(new BoundedChannelOptions(opts.ChannelCapacity)
        {
            FullMode = BoundedChannelFullMode.Wait,
            SingleReader = false,
            SingleWriter = true
        });

        var reader = channel.Reader;
        var writer = channel.Writer;

        var consumerTasks = new List<Task>(opts.ConsumerCount);
        for (var i = 0; i < opts.ConsumerCount; i++)
        {
            var workerId = i;
            consumerTasks.Add(RunConsumerAsync(workerId, reader, stoppingToken));
        }

        try
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                for (var j = 0; j < opts.ParallelJobsPerTick; j++)
                {
                    var job = new SaludoJob(Interlocked.Increment(ref _jobSequence));
                    await writer.WriteAsync(job, stoppingToken).ConfigureAwait(false);
                }

                await Task.Delay(TimeSpan.FromSeconds(opts.PollIntervalSeconds), stoppingToken)
                    .ConfigureAwait(false);
            }
        }
        catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
        {
            // cierre normal
        }
        finally
        {
            writer.Complete();
        }

        await Task.WhenAll(consumerTasks).ConfigureAwait(false);
    }

    private async Task RunConsumerAsync(
        int workerId,
        ChannelReader<SaludoJob> reader,
        CancellationToken stoppingToken)
    {
        try
        {
            await foreach (var job in reader.ReadAllAsync(stoppingToken).ConfigureAwait(false))
            {
                try
                {
                    await using var scope = scopeFactory.CreateAsyncScope();
                    var getSaludo = scope.ServiceProvider.GetRequiredService<GetSaludoDeudorUseCase>();

                    var saludo = await getSaludo.ExecuteAsync(stoppingToken).ConfigureAwait(false);

                    if (saludo is not null)
                    {
                        logger.LogInformation(
                            "Worker {WorkerId} job {JobId}: saludo API = {Saludo}",
                            workerId,
                            job.Id,
                            saludo);
                    }
                    else
                    {
                        logger.LogWarning(
                            "Worker {WorkerId} job {JobId}: no se obtuvo respuesta válida del API.",
                            workerId,
                            job.Id);
                    }
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    break;
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "Worker {WorkerId} job {JobId}: error al ejecutar GetSaludoDeudor.", workerId, job.Id);
                }
            }
        }
        catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
        {
            // fin del host
        }
    }

    private readonly record struct SaludoJob(long Id);
}
