using System;
using System.Runtime.CompilerServices;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;
using FegusDAgent.Infrastructure.Interfaces;
using Npgsql;
using NpgsqlTypes;

namespace FegusDAgent.Infrastructure.Persistence;

public class DeudoresSource : IEntitySource<Deudor>
{

    private readonly IDbConnectionFactory _dbConnectionFactory;

    public DeudoresSource(IDbConnectionFactory dbConnectionFactory)
    {
        _dbConnectionFactory = dbConnectionFactory;
    }
    public async IAsyncEnumerable<Deudor> StreamAsync([EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await using var connection = await _dbConnectionFactory.CreateConnectionAsync(cancellationToken);

        await using var command = connection.CreateCommand();

        command.CommandText = @"
            SELECT
            *
            FROM fegusdata.obtener_deudores_lista()            
            order by iddeudor desc
            ";
       
        

        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        

        while (await reader.ReadAsync(cancellationToken))
        {
            yield return new Deudor
            {
                IdCliente = reader.GetInt32(reader.GetOrdinal("idcliente")),
                TipoPersonaDeudor = reader.GetDecimal(reader.GetOrdinal("tipopersonadeudor")),
                IdDeudor = reader.GetString(reader.GetOrdinal("iddeudor")),
                TipoDeudorSFN = reader.IsDBNull(reader.GetOrdinal("tipodeudorsfn")) ? null : reader.GetInt32(reader.GetOrdinal("tipodeudorsfn")),
                CodigoSectorEconomico = reader.IsDBNull(reader.GetOrdinal("codigosectoreconomico")) ? null : reader.GetDecimal(reader.GetOrdinal("codigosectoreconomico")),
                TipoCapacidadPago = reader.IsDBNull(reader.GetOrdinal("tipocapacidadpago")) ? null : reader.GetInt32(reader.GetOrdinal("tipocapacidadpago")),
                SaldoTotalSegmentacion = reader.IsDBNull(reader.GetOrdinal("saldototalsegmentacion")) ? null : reader.GetDecimal(reader.GetOrdinal("saldototalsegmentacion")),
                TipoCondicionEspecialDeudor = reader.IsDBNull(reader.GetOrdinal("tipocondicionespecialdeudor")) ? null : reader.GetInt32(reader.GetOrdinal("tipocondicionespecialdeudor")),
                FechaCalificacionRiesgo = reader.IsDBNull(reader.GetOrdinal("fechacalificacionriesgo")) ? null : reader.GetString(reader.GetOrdinal("fechacalificacionriesgo")),
                TipoIndicadorGeneradorDivisas = reader.IsDBNull(reader.GetOrdinal("tipoindicadorgeneradordivisas")) ? null : reader.GetInt32(reader.GetOrdinal("tipoindicadorgeneradordivisas")),
                TipoAsignacionCalificacion = reader.IsDBNull(reader.GetOrdinal("tipoasignacioncalificacion")) ? null : reader.GetInt32(reader.GetOrdinal("tipoasignacioncalificacion")),
                CategoriaCalificacion = reader.IsDBNull(reader.GetOrdinal("categoriacalificacion")) ? null : reader.GetDecimal(reader.GetOrdinal("categoriacalificacion")),
                CalificacionRiesgo = reader.IsDBNull(reader.GetOrdinal("calificacionriesgo")) ? null : reader.GetString(reader.GetOrdinal("calificacionriesgo")),
                CodigoEmpresaCalificadora = reader.IsDBNull(reader.GetOrdinal("codigoempresacalificadora")) ? null : reader.GetDecimal(reader.GetOrdinal("codigoempresacalificadora")),
                IndicadorVinculadoEntidad = reader.IsDBNull(reader.GetOrdinal("indicadorvinculadoentidad")) ? null : reader.GetString(reader.GetOrdinal("indicadorvinculadoentidad")),
                IndicadorVinculadoGrupoFinanciero = reader.IsDBNull(reader.GetOrdinal("indicadorvinculadogrupofinanciero")) ? null : reader.GetString(reader.GetOrdinal("indicadorvinculadogrupofinanciero")),
                IdGrupoInteresEconomico = reader.IsDBNull(reader.GetOrdinal("idgrupointereseconomico")) ? null : reader.GetDecimal(reader.GetOrdinal("idgrupointereseconomico")),
                TipoComportamientoPago = reader.IsDBNull(reader.GetOrdinal("tipocomportamientopago")) ? null : reader.GetInt32(reader.GetOrdinal("tipocomportamientopago")),
                TipoActividadEconomicaDeudor = reader.IsDBNull(reader.GetOrdinal("tipoactividadeconomicadeudor")) ? null : reader.GetString(reader.GetOrdinal("tipoactividadeconomicadeudor")),
                TipoComportamientoPagoSBD = reader.IsDBNull(reader.GetOrdinal("tipocomportamientopagosbd")) ? null : reader.GetInt32(reader.GetOrdinal("tipocomportamientopagosbd")),
                TipoBeneficiarioSBD = reader.IsDBNull(reader.GetOrdinal("tipobeneficiariosbd")) ? null : reader.GetInt32(reader.GetOrdinal("tipobeneficiariosbd")),
                TotalOperacionesReestructuradasSBD = reader.IsDBNull(reader.GetOrdinal("totaloperacionesreestructuradassbd")) ? null : reader.GetInt32(reader.GetOrdinal("totaloperacionesreestructuradassbd")),
                TipoIndicadorGeneradorDivisasSBD = reader.IsDBNull(reader.GetOrdinal("tipoindicadorgeneradordivisassbd")) ? null : reader.GetInt32(reader.GetOrdinal("tipoindicadorgeneradordivisassbd")),
                RiesgoCambiarioDeudor = reader.IsDBNull(reader.GetOrdinal("riesgocambiariodeudor")) ? null : reader.GetInt32(reader.GetOrdinal("riesgocambiariodeudor")),
                MontoIngresoTotalDeudor = reader.IsDBNull(reader.GetOrdinal("montoingresototaldeudor")) ? null : reader.GetDecimal(reader.GetOrdinal("montoingresototaldeudor")),
                TotalCargaMensualCSD = reader.IsDBNull(reader.GetOrdinal("totalcargamensualcsd")) ? null : reader.GetDecimal(reader.GetOrdinal("totalcargamensualcsd")),
                IndicadorCSD = reader.IsDBNull(reader.GetOrdinal("indicadorcsd")) ? null : reader.GetDecimal(reader.GetOrdinal("indicadorcsd")),
                SaldoMoratoriaMayorUltMeses1421 = reader.IsDBNull(reader.GetOrdinal("saldomoramayorultmeses1421")) ? null : reader.GetDecimal(reader.GetOrdinal("saldomoramayorultmeses1421")),
                NumMesesMoratoriaMayor1421 = reader.IsDBNull(reader.GetOrdinal("nummesesmoramayor1421")) ? null : reader.GetInt32(reader.GetOrdinal("nummesesmoramayor1421")),
                SaldoMoratoriaMayorUltMeses1516 = reader.IsDBNull(reader.GetOrdinal("saldomoramayorultmeses1516")) ? null : reader.GetDecimal(reader.GetOrdinal("saldomoramayorultmeses1516")),
                NumMesesMoratoriaMayor1516 = reader.IsDBNull(reader.GetOrdinal("nummesesmoramayor1516")) ? null : reader.GetInt32(reader.GetOrdinal("nummesesmoramayor1516")),
                NumDiasAtraso1421 = reader.IsDBNull(reader.GetOrdinal("numdiasatraso1421")) ? null : reader.GetInt32(reader.GetOrdinal("numdiasatraso1421")),
                NumDiasAtraso1516 = reader.IsDBNull(reader.GetOrdinal("numdiasatraso1516")) ? null : reader.GetInt32(reader.GetOrdinal("numdiasatraso1516")),
                FechaUltGestion = reader.GetDateTime(reader.GetOrdinal("fechaultgestion")),
                CodUsuarioUltGestion = reader.IsDBNull(reader.GetOrdinal("codusuarioultgestion")) ? null : reader.GetString(reader.GetOrdinal("codusuarioultgestion"))
            };
           
        }

        
    }
}
