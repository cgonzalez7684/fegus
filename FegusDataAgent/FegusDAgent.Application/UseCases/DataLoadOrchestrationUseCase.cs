using FegusDAgent.Application.Common.Options;
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
    SendActividadEconomicaUseCase sendActividadEconomica,
    SendBienesRealizablesUseCase sendBienesRealizables,
    SendBienesRealizablesNoReportadosUseCase sendBienesRealizablesNoReportados,
    SendCambioClimaticoUseCase sendCambioClimatico,
    SendCodeudoresUseCase sendCodeudores,
    SendCreditosSindicadosUseCase sendCreditosSindicados,
    SendCuentasPorCobrarNoAsociadasUseCase sendCuentasPorCobrarNoAsociadas,
    SendCuentasXCobrarUseCase sendCuentasXCobrar,
    SendCuotasAtrasadasUseCase sendCuotasAtrasadas,
    SendFideicomisoUseCase sendFideicomiso,
    SendGarantiasCartasCreditoUseCase sendGarantiasCartasCredito,
    SendGarantiasFacturasCedidasUseCase sendGarantiasFacturasCedidas,
    SendGarantiasFiduciariasUseCase sendGarantiasFiduciarias,
    SendGarantiasMobiliariasUseCase sendGarantiasMobiliarias,
    SendGarantiasOperacionUseCase sendGarantiasOperacion,
    SendGarantiasPolizasUseCase sendGarantiasPolizas,
    SendGarantiasRealesUseCase sendGarantiasReales,
    SendGarantiasValoresUseCase sendGarantiasValores,
    SendGravamenesUseCase sendGravamenes,
    SendIngresoDeudoresUseCase sendIngresoDeudores,
    SendModificacionUseCase sendModificacion,
    SendNaturalezaGastoUseCase sendNaturalezaGasto,
    SendOperacionesBienesRealizablesUseCase sendOperacionesBienesRealizables,
    SendOperacionesCompradasUseCase sendOperacionesCompradas,
    SendOperacionesNoReportadasUseCase sendOperacionesNoReportadas,
    SendOrigenRecursosUseCase sendOrigenRecursos,
    OrchestrationOptions orchestrationOptions,
    IEventLogger<DataLoadOrchestrationUseCase> logger)
{
    private const int ErrorMessageMaxLength = 1024;
    private const string StateNew = "NEW";

    private bool boxUpdated = false; // Track if we've updated the box state to avoid redundant updates
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

        logger.Info($"Processing box for idCliente={idCliente}, AsofDate={box.AsofDate}, IdLoad={box.IdLoad}, AttemptCount={box.AttemptCount}.");

        // 2. Authenticate
        var token = await authenticate.ExecuteAsync(cancellationToken);
        if (string.IsNullOrWhiteSpace(token))
        {
            logger.Error($"Authentication failed for idCliente={idCliente}. Aborting cycle.");
            return false;
        }

        // 2.b Circuit-breaker per box: if we've already failed N times, mark ERROR and stop retrying.
        // Effective only once BackEnd persists AttemptCount (Pass 2). Until then the value
        // round-trips as 0 and this branch never fires.
        if (box.AttemptCount >= orchestrationOptions.MaxAttemptsPerBox)
        {
            box.StateCode = DataLoadState.Error.ToString();
            box.LastErrorMessage = Truncate(
                $"Max attempts ({orchestrationOptions.MaxAttemptsPerBox}) exceeded. Last error: {box.LastErrorMessage ?? "(unknown)"}",
                ErrorMessageMaxLength);
            await updateBox.ExecuteAsync(token, box, cancellationToken);
            logger.Error($"Box idLoad={box.IdLoad} moved to ERROR after {box.AttemptCount} attempts.");
            return false;
        }

        

        if (box.StateCode!.Contains(DataLoadState.New.ToString()))
        {
            // 3. Persist box locally — returns box with IdLoadLocal populated
            FeBoxDataLoad localBox;
            try
            {                
                localBox = await createLocalBox.ExecuteAsync(box, cancellationToken);
            }
            catch (Exception ex)
            {
                logger.Error($"Failed to create local box for idCliente={idCliente}, AsofDate={box.AsofDate}.", ex);
                throw;
            }

            box.IdLoadLocal = localBox.IdLoadLocal; // Ensure we have the local ID for the next step

            

        }
        else
        {
            logger.Info($"Box {box.IdLoad} for the LocalBox {box.IdLoadLocal} for idCliente={idCliente}, AsofDate={box.AsofDate} is already in state '{box.StateCode}'. Skipping creation and update steps.");
        }

        box.StateCode = DataLoadState.Staging.ToString(); // Update state before local creation
        box.AttemptCount += 1; // Persisted by BackEnd once Pass 2 lands; harmless until then.

        // 4. Update remote state, passing the local box (which carries IdLoadLocal)
        boxUpdated = await updateBox.ExecuteAsync(token, box, cancellationToken);
        if (!boxUpdated)
        {
            logger.Error($"Failed to update remote box state for idCliente={idCliente}.");
            return false;
        }

        // 5. Stream datasets in parallel

        try
        {
            await Task.WhenAll(
                sendDeudores.ExecuteAsync(token, box, cancellationToken),
                sendOperacionCredito.ExecuteAsync(token, box, cancellationToken),
                sendActividadEconomica.ExecuteAsync(token, box, cancellationToken),
                sendBienesRealizables.ExecuteAsync(token, box, cancellationToken),
                sendBienesRealizablesNoReportados.ExecuteAsync(token, box, cancellationToken),
                sendCambioClimatico.ExecuteAsync(token, box, cancellationToken),
                sendCodeudores.ExecuteAsync(token, box, cancellationToken),
                sendCreditosSindicados.ExecuteAsync(token, box, cancellationToken),
                sendCuentasPorCobrarNoAsociadas.ExecuteAsync(token, box, cancellationToken),
                sendCuentasXCobrar.ExecuteAsync(token, box, cancellationToken),
                sendCuotasAtrasadas.ExecuteAsync(token, box, cancellationToken),
                sendFideicomiso.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasCartasCredito.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasFacturasCedidas.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasFiduciarias.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasMobiliarias.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasOperacion.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasPolizas.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasReales.ExecuteAsync(token, box, cancellationToken),
                sendGarantiasValores.ExecuteAsync(token, box, cancellationToken),
                sendGravamenes.ExecuteAsync(token, box, cancellationToken),
                sendIngresoDeudores.ExecuteAsync(token, box, cancellationToken),
                sendModificacion.ExecuteAsync(token, box, cancellationToken),
                sendNaturalezaGasto.ExecuteAsync(token, box, cancellationToken),
                sendOperacionesBienesRealizables.ExecuteAsync(token, box, cancellationToken),
                sendOperacionesCompradas.ExecuteAsync(token, box, cancellationToken),
                sendOperacionesNoReportadas.ExecuteAsync(token, box, cancellationToken),
                sendOrigenRecursos.ExecuteAsync(token, box, cancellationToken)
                );

            box.StateCode = DataLoadState.Completed.ToString();
            box.LastErrorMessage = null;
            boxUpdated = await updateBox.ExecuteAsync(token, box, cancellationToken);
            if (!boxUpdated)
            {
                logger.Error($"Failed to update remote box state for idCliente={idCliente}.");
                return false;
            }

        }
        catch (Exception ex)
        {
            box.LastErrorMessage = Truncate(ex.Message, ErrorMessageMaxLength);

            // Only move to ERROR if we've exhausted attempts; otherwise leave in STAGING
            // so the next poll picks the box up and retries.
            if (box.AttemptCount >= orchestrationOptions.MaxAttemptsPerBox)
            {
                box.StateCode = DataLoadState.Error.ToString();
            }

            boxUpdated = await updateBox.ExecuteAsync(token, box, cancellationToken);

            logger.Error($"Dataset streaming failed for idLoadLocal={box.IdLoadLocal} on attempt {box.AttemptCount}/{orchestrationOptions.MaxAttemptsPerBox}.", ex);
            throw;
        }

        logger.Info($"Data load cycle completed for idCliente={idCliente}, idLoadLocal={box.IdLoadLocal}.");
        return true;
    }

    private static string Truncate(string value, int max) =>
        value.Length <= max ? value : value[..max];
}
