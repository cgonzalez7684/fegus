
namespace Infrastructure.Persistence.Repositories;

public class DeudorRepository : IDeudorRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public DeudorRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<Deudor?> GetDeudorByIdAsync(int idCliente, string idDeudor)
    {

        using var connection = _connectionFactory.CreateConnection();

            //throw new Exception("YYYY QUEEE Esteee es un error");
            
            /*var sql = """
                SELECT *
                FROM fegusdata.obtener_deudores(@p_id_cliente,@p_iddeudor)           
            """;*/

           var sql = @"
            SELECT
            pid_cliente              AS ""IdCliente"",
            ptipopersonadeudor       AS ""TipoPersonaDeudor"",
            piddeudor                AS ""IdDeudor"",
            ptipodeudorsfn           AS ""TipoDeudorSFN"",
            pcodigosectoreconomico   AS ""CodigoSectorEconomico"",
            ptipocapacidadpago       AS ""TipoCapacidadPago"",
            psaldototalsegmentacion  AS ""SaldoTotalSegmentacion"",
            ptipocondicionespecialdeudor AS ""TipoCondicionEspecialDeudor"",
            pfechacalificacionriesgo AS ""FechaCalificacionRiesgo"",
            ptipoindicadorgeneradordivisas AS ""TipoIndicadorGeneradorDivisas"",
            ptipoasignacioncalificacion AS ""TipoAsignacionCalificacion"",
            pcategoriacalificacion   AS ""CategoriaCalificacion"",
            pcalificacionriesgo      AS ""CalificacionRiesgo"",
            pcodigoempresacalificadora AS ""CodigoEmpresaCalificadora"",
            pindicadorvinculadoentidad AS ""IndicadorVinculadoEntidad"",
            pindicadorvinculadogrupofinanciero AS ""IndicadorVinculadoGrupoFinanciero"",
            pidgrupointereseconomico AS ""IdGrupoInteresEconomico"",
            ptipocomportamientopago  AS ""TipoComportamientoPago"",
            ptipoactividadeconomicadeudor AS ""TipoActividadEconomicaDeudor"",
            ptipocomportamientopagosbd AS ""TipoComportamientoPagoSBD"",
            ptipobeneficiariosbd     AS ""TipoBeneficiarioSBD"",
            ptotaloperacionesreestructuradassbd AS ""TotalOperacionesReestructuradasSBD"",
            ptipoindicadorgeneradordivisassbd AS ""TipoIndicadorGeneradorDivisasSBD"",
            priesgocambiariodeudor   AS ""RiesgoCambiarioDeudor"",
            pmontoingresototaldeudor AS ""MontoIngresoTotalDeudor"",
            ptotalcargamensualcsd    AS ""TotalCargaMensualCSD"",
            pindicadorcsd            AS ""IndicadorCSD"",
            pfechaultgestion::timestamp AS ""FechaUltGestion"",
            pcodusuarioultgestion    AS ""CodUsuarioUltGestion""
            FROM fegusdata.obtener_deudores(@p_id_cliente, @p_iddeudor);
            ";
            

            return await connection.QueryFirstOrDefaultAsync<Deudor>(
                sql,
                new { p_id_cliente = idCliente, p_iddeudor = idDeudor }
            );
    }
}

