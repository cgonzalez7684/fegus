-- PROCEDURE: FegusData.generar_deudores(integer)

-- DROP PROCEDURE IF EXISTS fegusdata.generar_deudores(integer);

CREATE OR REPLACE PROCEDURE fegusdata.generar_deudores(
	IN p_num_registros integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    i INT;
	pId_Cliente fegusdata.deudores.tipodeudorsfn%Type;
BEGIN

	Delete from fegusdata.deudores;

	pId_Cliente = 200;

    FOR i IN 1..p_num_registros LOOP
        INSERT INTO fegusdata.deudores (
    id_cliente,
    tipodeudorsfn,
    tipopersonadeudor,
    iddeudor,
    codigosectoreconomico,
    tipocapacidadpago,
    saldototalsegmentacion,
    tipocondicionespecialdeudor,
    fechacalificacionriesgo,
    tipoindicadorgeneradordivisas,
    tipoasignacioncalificacion,
    categoriacalificacion,
    calificacionriesgo,
    codigoempresacalificadora,
    indicadorvinculadoentidad,
    indicadorvinculadogrupofinanciero,
    idgrupointereseconomico,
    tipocomportamientopago,
    tipoactividadeconomicadeudor,
    tipocomportamientopagosbd,
    tipobeneficiariosbd,
    totaloperacionesreestructuradassbd,
    tipoindicadorgeneradordivisassbd,
    riesgocambiariodeudor,
    montoingresototaldeudor,
    totalcargamensualcsd,
    indicadorcsd,
    fechaultgestion,
    codusuarioultgestion
)
        VALUES (
            pId_Cliente, -- Id_Cliente secuencial
            (random()*2)::int + 1,  -- TipoDeudorSFN (1 o 2)
            (random()*2)::int + 1,  -- TipoPersonaDeudor (1 o 2)
            10000 + i,              -- IdDeudor
            (random()*999)::int,    -- CodigoSectorEconomico
            (random()*3)::int + 1,  -- TipoCapacidadPago
            round((random()*1000000)::numeric, 2), -- SaldoTotalSegmentacion
            (random()*3)::int,      -- TipoCondicionEspecialDeudor
            (CURRENT_DATE - (random()*1825)::int), -- FechaCalificacionRiesgo (últimos 5 años)
            (random()*1)::int,      -- TipoIndicadorGeneradorDivisas (0 o 1)
            (random()*5)::int + 1,  -- TipoAsignacionCalificacion
            (random()*5)::int + 1,  -- CategoriaCalificacion
            (random()*5)::int + 1,  -- CalificacionRiesgo
            (random()*100)::int,    -- CodigoEmpresaCalificadora
            (random()*1)::int,      -- IndicadorVinculadoEntidad
            (random()*1)::int,      -- IndicadorVinculadoGrupoFinanciero
            (random()*5000)::int,   -- IdGrupoInteresEconomico
            (random()*4)::int + 1,  -- TipoComportamientoPago
            (random()*1000)::int,   -- TipoActividadEconomicaDeudor
            (random()*2)::int,      -- TipoComportamientoPagoSBD
            (random()*1)::int,      -- TipoBeneficiarioSBD
            (random()*10)::int,     -- TotalOperacionesRestructuradasSBD
            (random()*1)::int,      -- TipoIndicadorGeneradorDivisasSBD
            (random()*3)::int + 1,  -- RiesgoCambiarioDeudor
            round((random()*2000000)::numeric, 2), -- MontoIngresoTotalDeudor
            round((random()*500000)::numeric, 2),  -- TotalCargaMensualCSD
            (random()*1)::int,      -- IndicadorCSD
            CURRENT_DATE,           -- FechaUltGestion
            'USR' || lpad((random()*999)::int::text, 3, '0') -- CodUsuarioUltGestion
        );
    END LOOP;
END;
$BODY$;
ALTER PROCEDURE fegusdata.generar_deudores(integer)
    OWNER TO postgres;
