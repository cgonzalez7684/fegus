using FegusDAgent.Application.Logging;
using FegusDAgent.Application.UseCases.Fegus;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Application.UseCases.FegusLocal;
using FegusDAgent.Application.UseCases.Ingestion;
using FegusDAgent.Domain.Enums;

namespace FegusDAgent.Application.UseCases;

/// <summary>
/// Orchestrates the full data load cycle:
/// authenticate → poll box → create local record → update remote state → stream datasets in parallel.
/// </summary>
public sealed class DataLoadOrchestrationUseCase(
    AuthenticateUseCase authenticate,
    GetNextBoxDataLoadUseCase getNextBox,
    CreateBoxDataLoadLocalUseCase createLocalBox,
    UpdateFeBoxDataLoadUseCase updateBox,
    SendDeudoresUseCase sendDeudores,
    SendOperacionCreditoUseCase sendOperacionCredito,
    IEventLogger<DataLoadOrchestrationUseCase> logger)
{
    private const string StateNew = "NEW";
    private HashSet<string> NotAllowedInitialStates = 
    new() {  
            DataLoadState.Validating.ToString()
            , DataLoadState.Calculating.ToString() 
            , DataLoadState.Completed.ToString()
            , DataLoadState.Error.ToString()
            , DataLoadState.Cancelled.ToString()
        };

    /// <summary>
    /// Runs one full data load cycle.
    /// Returns <c>true</c> if datasets were streamed; <c>false</c> if there was nothing to do.
    /// </summary>
    public async Task<bool> ExecuteAsync(int idCliente, CancellationToken cancellationToken = default)
    {       

        // 1. Returns early if no box was found or its state is not one that allows a new ingestion to start.
        var box = await getNextBox.ExecuteAsync(idCliente, cancellationToken);
        if (box is null || box.StateCode is null || NotAllowedInitialStates.Contains(box.StateCode!))
        {
            logger.Info($"No box available for idCliente={idCliente}.");
            return false;
        }

        logger.Info($"Processing box for idCliente={idCliente}, AsofDate={box.AsofDate}, IdLoad={box.IdLoad}.");

        // 2. Authenticate
        var token = await authenticate.ExecuteAsync(cancellationToken);
        if (string.IsNullOrWhiteSpace(token))
        {
            logger.Error($"Authentication failed for idCliente={idCliente}. Aborting cycle.");
            return false;
        }

        
        if (box.StateCode!.Contains(DataLoadState.New.ToString()))
        {
            // 3. Persist box locally — returns box with IdLoadLocal populated
            FeBoxDataLoad localBox;
            try
            {
                box.StateCode = DataLoadState.Created.ToString(); // Update state before local creation
                localBox = await createLocalBox.ExecuteAsync(box, cancellationToken);
            }
            catch (Exception ex)
            {
                logger.Error($"Failed to create local box for idCliente={idCliente}, AsofDate={box.AsofDate}.", ex);
                throw;
            }

            box.IdLoadLocal = localBox.IdLoadLocal; // Ensure we have the local ID for the next step

            // 4. Update remote state, passing the local box (which carries IdLoadLocal)
            var updated = await updateBox.ExecuteAsync(token, box, cancellationToken);
            if (!updated)
            {
                logger.Error($"Failed to update remote box state for idCliente={idCliente}.");
                return false;
            }

        }
        else
        {
            logger.Info($"Box {box.IdLoad} for the LocalBox {box.IdLoadLocal} for idCliente={idCliente}, AsofDate={box.AsofDate} is already in state '{box.StateCode}'. Skipping creation and update steps.");
        }

        // 5. Stream datasets in parallel       

        try
        {
            await Task.WhenAll(
                sendDeudores.ExecuteAsync(token, box, cancellationToken)
                //sendOperacionCredito.ExecuteAsync(token, box, cancellationToken)
                );
        }
        catch (Exception ex)
        {
            logger.Error($"Dataset streaming failed for idLoadLocal={box.IdLoadLocal}.", ex);
            throw;
        }

        logger.Info($"Data load cycle completed for idCliente={idCliente}, idLoadLocal={box.IdLoadLocal}.");
        return true;
    }
}
