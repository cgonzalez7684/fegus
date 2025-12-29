namespace Common.Share;

public static class StaticValues
{
    public const string pvCodEmpresa = "01001001";
    public const string pvCodEntidad = "3004045205";
    public const string TipoEventoError = "E";
    public const string TipoEventoInformativo = "I";
    public const string constFinCierres = "F1";
    public const string constDescFinCierres = "Finalizo los cierres requeridos de PSBANK (CR,SU,GA)";

    public const string constIniGenSiveca = "P2";
    public const string constDescIniGenSiveca = "Inicio de los procesos de Generacion Sicveca";

    public const string constFinGenSiveca = "F2";
    public const string constDescFinGenSiveca = "Finalizo la ejecucion de los procesos de Generacion Sicveca";

    public const string constIniCursores = "P3";
    public const string constDescIniCursores = "Inicio el levantamiento de los cursores de las tablas ENTs";

    public const string constFinCursores = "F3";
    public const string constDescFinCursores = "Finalizo el levantamiento de los cursores de las tablas ENTs";

    public const string constIniReferencias = "P4";
    public const string constDescIniReferencias = "Inicio del proceso de verificacion de referencias";

    public const string constFinReferencias = "F4";
    public const string constDescFinReferencias = "Finalizo el proceso de verificacion de referencias";

    public const string constIniBulkCopy = "P5";
    public const string constDescIniBulkCopy = "Inicio del proceso de BulkCopy entre PSBANK y PCD";

    public const string constFinBulkCopy = "F5";
    public const string constDescFinBulkCopy = "Finalizo el proceso de BulkCopy entre PSBANK y PCD";

    public const string constIniPcd = "P6";
    public const string constDescIniPcd = "Inicio el proceso calculos de PCD";

    public const string constFinPcd = "F6";
    public const string constDescFinPcd = "Finalizo el proceso calculos de PCD, por estado C2 o estado I, verificar en PCD";

    public const string constIniDescargaPcd = "P7";
    public const string constDescIniDescargaPcd = "Inicio el de descarga de datos PCD a PSBANK";

    public const string constFinDescargaPcd = "F7";
    public const string constDescFinDescargaPcd = "Finalizo la descarga de datos PCD a PSBANK";

    public const string constIniActualizaPcdPsBank = "P8";
    public const string constDescIniActualizaPcdPsBank = "Inicio el proceso de actualizacion de datos descargados hacia PSBANK";

    public const string constFinActualizaPcdPsBank = "F8";
    public const string constDescFinActualizaPcdPsBank = "Finalizo el proceso de actualizacion de datos descargados hacia PSBANK";

    public const string constInconsitenciaPcdBroker = "I";
    public const string constDescInconsitenciaPcdBroker = "Ejecución de PCDBroker inconsistente favor revisar bitacoras";

    public const string constFinCargaDatosAPcd = "F";
    public const string constDescFinCargaDatosAPcd = "Finalizo la carga de datos del sistema interno hacia PCD";
}
