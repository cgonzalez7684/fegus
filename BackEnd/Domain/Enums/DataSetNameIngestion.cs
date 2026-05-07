namespace Domain.Enums;
public sealed class DataSetNameIngestion
{
    public string Value { get; }

    private DataSetNameIngestion(string value)
    {
        Value = value;
    }

    public static readonly DataSetNameIngestion Deudores                      = new("Deudores");
    public static readonly DataSetNameIngestion OperacionesCredito             = new("OperacionesCredito");
    public static readonly DataSetNameIngestion GarantiasOperacion             = new("GarantiasOperacion");

    public static readonly DataSetNameIngestion ActividadEconomica             = new("ActividadEconomica");
    public static readonly DataSetNameIngestion BienesRealizables              = new("BienesRealizables");
    public static readonly DataSetNameIngestion BienesRealizablesNoReportados  = new("BienesRealizablesNoReportados");
    public static readonly DataSetNameIngestion CambioClimatico                = new("CambioClimatico");
    public static readonly DataSetNameIngestion Codeudores                     = new("Codeudores");
    public static readonly DataSetNameIngestion CreditosSindicados             = new("CreditosSindicados");
    public static readonly DataSetNameIngestion CuentasPorCobrarNoAsociadas    = new("CuentasPorCobrarNoAsociadas");
    public static readonly DataSetNameIngestion Fideicomiso                    = new("Fideicomiso");
    public static readonly DataSetNameIngestion GarantiasCartasCredito         = new("GarantiasCartasCredito");
    public static readonly DataSetNameIngestion GarantiasFacturasCedidas       = new("GarantiasFacturasCedidas");
    public static readonly DataSetNameIngestion GarantiasFiduciarias           = new("GarantiasFiduciarias");
    public static readonly DataSetNameIngestion GarantiasMobiliarias           = new("GarantiasMobiliarias");
    public static readonly DataSetNameIngestion GarantiasPolizas               = new("GarantiasPolizas");
    public static readonly DataSetNameIngestion GarantiasReales                = new("GarantiasReales");
    public static readonly DataSetNameIngestion GarantiasValores               = new("GarantiasValores");
    public static readonly DataSetNameIngestion Gravamenes                     = new("Gravamenes");
    public static readonly DataSetNameIngestion IngresoDeudores                = new("IngresoDeudores");
    public static readonly DataSetNameIngestion Modificacion                   = new("Modificacion");
    public static readonly DataSetNameIngestion NaturalezaGasto                = new("NaturalezaGasto");
    public static readonly DataSetNameIngestion OperacionesBienesRealizables   = new("OperacionesBienesRealizables");
    public static readonly DataSetNameIngestion OperacionesCompradas           = new("OperacionesCompradas");
    public static readonly DataSetNameIngestion OperacionesNoReportadas        = new("OperacionesNoReportadas");
    public static readonly DataSetNameIngestion OrigenRecursos                 = new("OrigenRecursos");

    public override string ToString() => Value;
}
