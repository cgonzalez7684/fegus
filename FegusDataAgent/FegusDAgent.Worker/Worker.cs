using System.Threading.Channels;
using FegusDAgent.Application.UseCases;
using FegusDAgent.Infrastructure.FegusApi;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace FegusDAgent.Worker;

public class Worker(
    ILogger<Worker> logger,
    IServiceScopeFactory scopeFactory,
    IOptions<SaludoWorkerOptions> options,
    IOptions<FegusApiOptions> fegusOptions) : BackgroundService
{
    private long _jobSequence;
    private readonly SemaphoreSlim _jobGate = new(1, 1);

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

        if (!int.TryParse(fegusOptions.Value.IdCliente, out var idCliente) || idCliente <= 0)
            throw new InvalidOperationException("FegusApi:IdCliente must be a valid positive integer.");

        var channel = Channel.CreateBounded<DataLoadJob>(new BoundedChannelOptions(opts.ChannelCapacity)
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
            consumerTasks.Add(RunConsumerAsync(workerId, idCliente, reader, stoppingToken));
        }

        try
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                for (var j = 0; j < opts.ParallelJobsPerTick; j++)
                {
                    var job = new DataLoadJob(Interlocked.Increment(ref _jobSequence));
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
        int idCliente,
        ChannelReader<DataLoadJob> reader,
        CancellationToken stoppingToken)
    {
        try
        {
            await foreach (var job in reader.ReadAllAsync(stoppingToken).ConfigureAwait(false))
            {
                try
                {
                    await using var scope = scopeFactory.CreateAsyncScope();
                    var orchestration = scope.ServiceProvider
                        .GetRequiredService<DataLoadOrchestrationUseCase>();

                    await _jobGate.WaitAsync(stoppingToken).ConfigureAwait(false);
                    bool workDone;
                    try
                    {
                        workDone = await orchestration
                            .ExecuteAsync(idCliente, stoppingToken)
                            .ConfigureAwait(false);
                    }
                    finally
                    {
                        _jobGate.Release();
                    }

                    if (workDone)
                        logger.LogInformation(
                            "Worker {WorkerId} job {JobId}: data load completed for idCliente={IdCliente}.",
                            workerId, job.Id, idCliente);
                    else
                        logger.LogDebug(
                            "Worker {WorkerId} job {JobId}: no NEW box available.",
                            workerId, job.Id);
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    break;
                }
                catch (Exception ex)
                {
                    logger.LogError(ex,
                        "Worker {WorkerId} job {JobId}: error during data load orchestration.",
                        workerId, job.Id);
                }
            }
        }
        catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
        {
            // fin del host
        }
    }

    private readonly record struct DataLoadJob(long Id);
}
