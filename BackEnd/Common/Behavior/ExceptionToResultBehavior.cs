public sealed class ExceptionToResultBehavior<TRequest, TResponse>
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : notnull
{
    public async Task<TResponse> Handle(
        TRequest request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken ct)
    {
        try
        {
            return await next();
        }
        catch (Exception ex)
        {
            // Aquí decides qué mensaje devolver (sin exponer detalles internos)
            var message = MapExceptionToMessage(ex);

            // Si el handler devuelve Result
            if (typeof(TResponse) == typeof(Result))
                return (TResponse)(object)Result.Fail(message);

            // Si el handler devuelve Result<T>
            if (IsResultOfT(typeof(TResponse)))
            {
                // Invoca Result<T>.Fail(string) vía reflexión
                return (TResponse)CreateGenericFailResult(typeof(TResponse), message);
            }

            // Si no es Result/Result<T>, re-lanza (o decide otra política)
            throw;
        }
    }

    private static string MapExceptionToMessage(Exception ex)
    {
        // Puedes personalizar por tipos:
        // - TimeoutException -> "Tiempo de espera agotado..."
        // - DbException -> "Error de base de datos..."
        // - etc.

        if (ex is TimeoutException)
            return "Tiempo de espera agotado al acceder a un servicio.";

        // Default (no filtrar detalles):
        return $"Ocurrió un error interno procesando la solicitud. {ex.Message}";
    }

    private static bool IsResultOfT(Type t)
        => t.IsGenericType && t.GetGenericTypeDefinition() == typeof(Result<>);

    private static object CreateGenericFailResult(Type resultType, string message)
    {
        // 1) Intentar Fail(string) si existe
        var fail1 = resultType.GetMethod("Fail", new[] { typeof(string) });
        if (fail1 is not null)
            return fail1.Invoke(null, new object[] { message })!;

        // 2) Intentar Fail(string, ErrorType) si existe
        var fail2 = resultType.GetMethod("Fail", new[] { typeof(string), typeof(ErrorType) });
        if (fail2 is not null)
            return fail2.Invoke(null, new object[] { message, ErrorType.Technical })!;

        throw new InvalidOperationException($"No se encontró Fail(string) ni Fail(string, ErrorType) en {resultType.Name}");
    }

}
