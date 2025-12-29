namespace Common.Share
{
    public class LoggerUtil
    {

        private readonly IConfiguration _configuration;
        //private readonly IHttpContextAccessor _httpContextAccessor;
        private string traceMessagesEnabled = string.Empty;
        private string message = string.Empty;
        private string metaEndPoint = string.Empty;
        private static readonly ILogger _logger = LogManager.GetCurrentClassLogger();

        public LoggerUtil(IConfiguration configuration)
        {

            this._configuration = configuration;            
            traceMessagesEnabled = _configuration.GetSection("TraceMessagesEnabled").Value!;
        }

        public void WriteMessageByType(LogTypeEnum logType, object valor)
        {

            //var context = _httpContextAccessor.HttpContext;

            //if (context != null)
            //{
            //    var endpoint = context.Features.Get<IEndpointFeature>()?.Endpoint;

            //    if (endpoint != null)
            //    {
            //        var actionDescriptor = endpoint.Metadata.GetMetadata<ControllerActionDescriptor>();
            //        if (actionDescriptor != null)
            //        {
            //            var controllerName = actionDescriptor.ControllerName;
            //            var actionName = actionDescriptor.ActionName;

            //            // AquÃƒÆ’Ã‚Â­ puedes agregar la lÃƒÆ’Ã‚Â³gica para registrar el evento junto con el nombre del mÃƒÆ’Ã‚Â©todo del API.
            //            metaEndPoint = $"[{controllerName}.{actionName}] ";
            //        }


            //    }


            //}

            //Determinar que tipo de valor estan pasando como parametro
            Type tipo = valor.GetType();

            if (tipo.IsPrimitive || tipo == typeof(string) || tipo == typeof(decimal))
            {
                message = Convert.ToString(valor)!; //si es texto solo se asigna
            }
            else
            {
                message = JsonSerializer.Serialize(valor); //si es un objeto se serializa
            }


            //message = $"EndPoint({metaEndPoint}). Message: {message}";

            switch (logType)
            {
                case Enums.LogTypeEnum.Info:
                    _logger.Info(message);
                    break;
                //if (!string.IsNullOrEmpty(traceMessagesEnabled) && traceMessagesEnabled.ToUpper().Equals("TRUE"))
                //    _logger.Info(message);
                //break;
                case LogTypeEnum.Error:
                    _logger.Error(message);
                    break;
            }
        }
    }
}
