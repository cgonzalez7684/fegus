namespace API.Middleware;


public sealed class ExceptionLoggingMiddleware(RequestDelegate next)
{
    public async Task Invoke(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (Exception ex)
        {
            var errorId = Guid.NewGuid().ToString("N");
            var traceId = Activity.Current?.TraceId.ToString() ?? context.TraceIdentifier;

            Log.ForContext("ErrorId", errorId)
               .ForContext("TraceId", traceId)
               .ForContext("RequestPath", context.Request.Path.Value)
               .ForContext("RequestMethod", context.Request.Method)
               .ForContext("Assembly", ex.TargetSite?.DeclaringType?.Assembly.FullName)
               .ForContext("Class", ex.TargetSite?.DeclaringType?.FullName)
               .ForContext("Method", ex.TargetSite?.Name)
               .Error(ex, "Unhandled exception");

            context.Response.StatusCode = StatusCodes.Status500InternalServerError;
            context.Response.ContentType = "application/json";

            // Respuesta segura (sin stack trace)
            await context.Response.WriteAsJsonAsync(new
            {
                isSuccess = false,
                errorType = "Technical",
                error = $"Ocurrió un error interno. Código: {errorId}"
            });
        }
    }
}
