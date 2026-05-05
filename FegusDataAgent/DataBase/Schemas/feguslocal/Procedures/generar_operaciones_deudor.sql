-- PROCEDURE: feguslocal.generar_operaciones_deudor(bigint, feguslocal.deudores_type, integer)

-- DROP PROCEDURE IF EXISTS feguslocal.generar_operaciones_deudor(bigint, feguslocal.deudores_type, integer);

CREATE OR REPLACE PROCEDURE feguslocal.generar_operaciones_deudor(
	IN pid_load_local bigint,
	IN p_deudor feguslocal.deudores_type,
	IN p_cantidad integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    i                       int;
    v_idoperacion           text;
    v_dias_morosidad        int;
    v_indicador_modificada  varchar(1);
    v_indicador_codeudores  varchar(1);
    v_indicador_sindicado   varchar(1);
    v_indicador_climatico   varchar(1);
    v_indicador_especial    varchar(1);
BEGIN
    FOR i IN 1..p_cantidad LOOP
        BEGIN
            v_idoperacion          := feguslocal.generar_id_fegus('OPER','seq_operacion');
            v_dias_morosidad       := floor(random() * 201)::int;
            v_indicador_modificada := CASE WHEN random() < 0.20 THEN 'S' ELSE 'N' END;
            v_indicador_codeudores := CASE WHEN random() < 0.30 THEN 'S' ELSE 'N' END;
            v_indicador_sindicado  := CASE WHEN random() < 0.05 THEN 'S' ELSE 'N' END;
            v_indicador_climatico  := CASE WHEN random() < 0.15 THEN 'S' ELSE 'N' END;
            v_indicador_especial   := CASE WHEN random() < 0.10 THEN 'S' ELSE 'N' END;

            INSERT INTO feguslocal.operacionescredito(
                "id_load_local", "TipoOperacionSFN", "TipoPersonaDeudor", "IdDeudor",
                "IdOperacionCredito", "IdLineaCredito", "IndicadorOperacionModificada",
                "IndicadorPresentaCodeudores", "TipoEnfoque", "TipoSegmento", "CodigoEtapa",
                "CodigoCategoriaRiesgo", "TasaIncumplimiento", "LGDMinimoCombinado",
                "LGDPromedio", "LGDRegulatorio", "TipoOperacion", "TipoCatalogoSUGEF",
                "CodigoPaisDestinoCredito", "CodigoProvinciaDestinoCredito",
                "CodigoCantonDestinoCredito", "CodigoDistritoDestinoCredito",
                "CodigoProvinciaDependenciaCredito", "CodigoCantonDependenciaCredito",
                "TipoCarteraCrediticia", "TipoEstadoOperacionCrediticia",
                "DiasMaximaMorosidad", "MontoFormalizadoOperacionCrediticia",
                "TipoMonedaOperacion", "MontoOperacionAutorizado", "CuentaContablePrincipal",
                "SaldoPrincipalOperacionCrediticia", "CuentaContablePrincipalConDepositoPrevio",
                "SaldoPrincipalConDepositoPrevio", "CuentaContableProductosPorCobrar",
                "SaldoProductosPorCobrar", "CuentaContablePorDesembolsarConCompromiso",
                "SaldoPorDesembolsarConCompromiso", "CuentaContableComisiones",
                "SaldoComisionesOperacionesContingentes",
                "CuentaContableSaldoPendienteUtilizacionSinCompromiso",
                "SaldoPendienteUtilizacionSinCompromiso", "MontoDesembolsado",
                "FechaFormalizacion", "FechaVencimiento", "EAD", "SaldoOperacionSegmentacion",
                "TipoFrecuenciaPagoActualPrincipal", "TipoFrecuenciaPagoActualIntereses",
                "FechaVencimientoPeriodoGraciaPrincipal", "TasaLey7472",
                "TasaInteresNominalVigente", "IndicadorTipoTasa",
                "FactorDeTiempoCalculoIntereses", "IndicadorFormaPagoVigentePrincipal",
                "IndicadorFormaPagoVigenteIntereses", "FechaCorteOperacion",
                "FechaProximoPagoPrincipal", "FechaProximoPagoIntereses",
                "FechaAmortizacionHasta", "FechaInteresHasta", "FechaPagoPactadoPrincipal",
                "FechaPagoPactadoIntereses", "PlazoOperacionDias", "TipoCuotaPrincipal",
                "MontoCuotaPrincipalActual", "MontoCuotaInteresesActual",
                "IndicadorOperacionNueva", "MontoRecuperacionPrincipal",
                "MontoOtrosAumentosDePrincipal", "MontoOtrasDisminucionesDePrincipal",
                "IndicadorBacktoBack", "IndicadorCreditoSindicado",
                "IndicadorOperacionEspecial", "TipoMotivoOperacionEspecial",
                "CodigoClausulaLimiteCredito", "FechaCambioTipoTasa",
                "TipoFrecuenciaAjusteTasaInteresVariable",
                "TipoParametroReferenciaTasaInteresVariable",
                "PorcentajeComponenteVariableTasaInteresVariable",
                "PorcentajeComponenteFijoTasaInteresVariable",
                "LimiteInferiorTasaInteresVariable", "LimiteSuperiorTasaInteresVariable",
                "MontoEstimacionEspecifica", "MontoEstimacionAvales",
                "TipoProgramaAutorizadoSBD", "IndicadorCreditoGrupalSolidarioSBD",
                "TipoSectorPrioritarioDeudorSBD", "IdFondeadorSBD",
                "TipoPersonaIdFondeadorSBD", "IndicadorOperacionCedidaEnGarantia",
                "PorcentajePonderadorSPD", "PorcentajePonderadorSPC",
                "PorcentajeIndicadorLTV", "IndicadorCambioClimatico",
                "TipoClasificacionRiesgoClimatico", "TipoMetodologiaClimatica",
                "TipoPotencialidadImpactoClimatico", "updated_at_utc"
            )
            VALUES (
                pid_load_local,
                (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],          -- TipoOperacionSFN
                p_deudor.TipoPersonaDeudor,
                p_deudor.IdDeudor,
                v_idoperacion,                                          -- IdOperacionCredito
                NULL,                                                   -- IdLineaCredito
                v_indicador_modificada,                                 -- IndicadorOperacionModificada
                v_indicador_codeudores,                                 -- IndicadorPresentaCodeudores
                (ARRAY[0,1,2])[floor(random() * 3 + 1)],                -- TipoEnfoque
                (ARRAY[0,1,2,3,4,5,6,7])[floor(random() * 8 + 1)],      -- TipoSegmento
                NULL,                                                   -- CodigoEtapa (confirmado: NULL)
                NULL,                                                   -- CodigoCategoriaRiesgo (confirmado: NULL)
                round((random() * 99.99)::numeric, 2),                  -- TasaIncumplimiento
                round((random() * 100)::numeric, 2),                    -- LGDMinimoCombinado
                round((random() * 100)::numeric, 2),                    -- LGDPromedio
                round((random() * 100)::numeric, 2),                    -- LGDRegulatorio
                (ARRAY[1,2,3,4,5,6,7,8,9])[floor(random() * 9 + 1)],    -- TipoOperacion
                (ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)], -- TipoCatalogoSUGEF
                'CR',                                                   -- CodigoPaisDestinoCredito (confirmado: 'CR')
                NULL,                                                   -- CodigoProvinciaDestinoCredito (confirmado: NULL)
                NULL,                                                   -- CodigoCantonDestinoCredito (confirmado: NULL)
                NULL,                                                   -- CodigoDistritoDestinoCredito (confirmado: NULL)
                NULL,                                                   -- CodigoProvinciaDependenciaCredito (confirmado: NULL)
                NULL,                                                   -- CodigoCantonDependenciaCredito (confirmado: NULL)
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11])[floor(random() * 12 + 1)], -- TipoCarteraCrediticia
                (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],          -- TipoEstadoOperacionCrediticia
                v_dias_morosidad,                                       -- DiasMaximaMorosidad
                round((random() * 50000000)::numeric, 2),               -- MontoFormalizadoOperacionCrediticia
                (ARRAY[1,2])[floor(random() * 2 + 1)],                  -- TipoMonedaOperacion (confirmado: 1 ó 2)
                round((random() * 50000000)::numeric, 2),               -- MontoOperacionAutorizado
                (ARRAY[13131101,13401200,13132125,13233201,13231203,13332125,13131104,
                       13331102,13131203,13331203,13231104,13231204,13131201,13131102,
                       13231101,13131103,13133101,13232125,13233101,13131110,13131210,
                       13231202,13136101,13333201,13331202,13331103,13401100,13133201,
                       13231102,13231201,13333101,13231103,13402100,13402200,13132134,
                       13131204,13131202])[floor(random() * 37 + 1)],   -- CuentaContablePrincipal
                round((random() * 50000000)::numeric, 2),               -- SaldoPrincipalOperacionCrediticia
                NULL,                                                   -- CuentaContablePrincipalConDepositoPrevio
                0,                                                      -- SaldoPrincipalConDepositoPrevio
                (ARRAY[13831101,13832134,13831110,13831102,13831210,13831103,13831202,
                       13836101,13833101,13831204,13833201,13831203,13831104,13831201,
                       13832125])[floor(random() * 15 + 1)],            -- CuentaContableProductosPorCobrar
                round((random() * 1000000)::numeric, 2),                -- SaldoProductosPorCobrar
                (ARRAY[61502200,61901200,61901100])[floor(random() * 3 + 1)], -- CuentaContablePorDesembolsarConCompromiso
                round((random() * 500000)::numeric, 2),                 -- SaldoPorDesembolsarConCompromiso
                NULL,                                                   -- CuentaContableComisiones
                0,                                                      -- SaldoComisionesOperacionesContingentes
                NULL,                                                   -- CuentaContableSaldoPendienteUtilizacionSinCompromiso
                0,                                                      -- SaldoPendienteUtilizacionSinCompromiso
                round((random() * 50000000)::numeric, 2),               -- MontoDesembolsado
                (CURRENT_DATE - (random() * 1825)::int),                -- FechaFormalizacion
                (CURRENT_DATE + (random() * 3650)::int),                -- FechaVencimiento (futura)
                round((random() * 50000000)::numeric, 2),               -- EAD
                round((random() * 50000000)::numeric, 2),               -- SaldoOperacionSegmentacion
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)], -- TipoFrecuenciaPagoActualPrincipal
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)], -- TipoFrecuenciaPagoActualIntereses
                NULL,                                                   -- FechaVencimientoPeriodoGraciaPrincipal
                round((random() * 99.99)::numeric, 2),                  -- TasaLey7472
                round((random() * 99.99)::numeric, 2),                  -- TasaInteresNominalVigente
                (ARRAY['V','F'])[floor(random() * 2 + 1)],              -- IndicadorTipoTasa
                '4',                                                    -- FactorDeTiempoCalculoIntereses
                'V',                                                    -- IndicadorFormaPagoVigentePrincipal
                'V',                                                    -- IndicadorFormaPagoVigenteIntereses
                (CURRENT_DATE - (random() * 365)::int),                 -- FechaCorteOperacion
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaProximoPagoPrincipal
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaProximoPagoIntereses
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaAmortizacionHasta
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaInteresHasta
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaPagoPactadoPrincipal
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaPagoPactadoIntereses
                (ARRAY[180,360,540,720,1080,1800])[floor(random() * 6 + 1)], -- PlazoOperacionDias
                (ARRAY[1,2,3,4,5])[floor(random() * 5 + 1)],            -- TipoCuotaPrincipal
                round((random() * 1000000)::numeric, 2),                -- MontoCuotaPrincipalActual
                round((random() * 1000000)::numeric, 2),                -- MontoCuotaInteresesActual
                CASE WHEN random() < 0.30 THEN 'S' ELSE 'N' END,        -- IndicadorOperacionNueva
                round((random() * 5000000)::numeric, 2),                -- MontoRecuperacionPrincipal
                round((random() * 5000000)::numeric, 2),                -- MontoOtrosAumentosDePrincipal
                round((random() * 5000000)::numeric, 2),                -- MontoOtrasDisminucionesDePrincipal
                CASE WHEN random() < 0.05 THEN 'S' ELSE 'N' END,        -- IndicadorBacktoBack
                v_indicador_sindicado,                                  -- IndicadorCreditoSindicado
                v_indicador_especial,                                   -- IndicadorOperacionEspecial
                CASE WHEN v_indicador_especial = 'S'
                     THEN (ARRAY[0,1,2,3])[floor(random() * 4 + 1)]
                     ELSE NULL END,                                     -- TipoMotivoOperacionEspecial
                0,                                                      -- CodigoClausulaLimiteCredito
                NULL,                                                   -- FechaCambioTipoTasa
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)], -- TipoFrecuenciaAjusteTasaInteresVariable
                (ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])[floor(random() * 18 + 1)], -- TipoParametroReferenciaTasaInteresVariable
                round((random() * 50)::numeric, 2),                     -- PorcentajeComponenteVariableTasaInteresVariable
                round((random() * 50)::numeric, 2),                     -- PorcentajeComponenteFijoTasaInteresVariable
                round((random() * 5)::numeric, 2),                      -- LimiteInferiorTasaInteresVariable
                round((random() * 30)::numeric, 2),                     -- LimiteSuperiorTasaInteresVariable
                round((random() * 5000000)::numeric, 2),                -- MontoEstimacionEspecifica
                round((random() * 1000000)::numeric, 2),                -- MontoEstimacionAvales
                (ARRAY[0,30001,30002,30003,30004,30005,30019,40001,40002,40003,40010])[floor(random() * 11 + 1)], -- TipoProgramaAutorizadoSBD
                CASE WHEN random() < 0.10 THEN 1 ELSE 0 END,            -- IndicadorCreditoGrupalSolidarioSBD
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12,13])[floor(random() * 14 + 1)], -- TipoSectorPrioritarioDeudorSBD
                NULL,                                                   -- IdFondeadorSBD
                NULL,                                                   -- TipoPersonaIdFondeadorSBD
                CASE WHEN random() < 0.05 THEN 'S' ELSE 'N' END,        -- IndicadorOperacionCedidaEnGarantia
                round((random() * 100)::numeric, 2),                    -- PorcentajePonderadorSPD
                round((random() * 100)::numeric, 2),                    -- PorcentajePonderadorSPC
                round((random() * 100)::numeric, 2),                    -- PorcentajeIndicadorLTV
                v_indicador_climatico,                                  -- IndicadorCambioClimatico
                CASE WHEN v_indicador_climatico = 'S'
                     THEN (ARRAY[0,1,2,3])[floor(random() * 4 + 1)]
                     ELSE NULL END,                                     -- TipoClasificacionRiesgoClimatico
                CASE WHEN v_indicador_climatico = 'S'
                     THEN (ARRAY[0,1,2])[floor(random() * 3 + 1)]
                     ELSE NULL END,                                     -- TipoMetodologíaClimático
                CASE WHEN v_indicador_climatico = 'S'
                     THEN (ARRAY[0,1,2,3,4,5,6,7,8,9])[floor(random() * 10 + 1)]
                     ELSE NULL END,                                     -- TipoPotencialidadImpactoClimatico
                CURRENT_DATE
            );

            ----------------------------------------------------------------
            -- Hijos por operación
            ----------------------------------------------------------------
            CALL feguslocal.generar_actividadeconomica(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_naturalezagasto(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_origenrecursos(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_cuentasxcobrar(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_cuentasporcobrarnosasociadas(
                pid_load_local, v_idoperacion, p_deudor.TipoPersonaDeudor::int);
            CALL feguslocal.generar_operacionescompradas(
                pid_load_local, v_idoperacion, p_deudor.IdDeudor, p_deudor.TipoPersonaDeudor::int);

            IF v_indicador_codeudores = 'S' THEN
                CALL feguslocal.generar_codeudores(pid_load_local, v_idoperacion);
            END IF;

            IF v_indicador_sindicado = 'S' THEN
                CALL feguslocal.generar_creditossindicados(pid_load_local, v_idoperacion);
            END IF;

            IF v_indicador_modificada = 'S' THEN
                CALL feguslocal.generar_modificacion(pid_load_local, v_idoperacion);
            END IF;

            IF v_indicador_climatico = 'S' THEN
                CALL feguslocal.generar_cambioclimatico(pid_load_local, v_idoperacion);
            END IF;

            IF v_dias_morosidad > 30 THEN
                CALL feguslocal.generar_cuotasatrasadas(
                    pid_load_local, v_idoperacion, p_deudor.IdDeudor,
                    p_deudor.TipoPersonaDeudor::int, v_dias_morosidad);
            END IF;

            -- Garantías (1-3 por operación, cada una se enruta por tipogarantia)
            CALL feguslocal.generar_garantia_operacion(
                pid_load_local, p_deudor.IdDeudor, p_deudor.TipoPersonaDeudor::int, v_idoperacion);

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_operaciones_deudor] Error en operación %: % | SQLSTATE=% | deudor=%',
                             COALESCE(v_idoperacion, '<n/a>'), SQLERRM, SQLSTATE, p_deudor.IdDeudor;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_operaciones_deudor] Error general: % | SQLSTATE=% | deudor=%',
                     SQLERRM, SQLSTATE, p_deudor.IdDeudor;
        RAISE;
END;
$BODY$;
ALTER PROCEDURE feguslocal.generar_operaciones_deudor(bigint, feguslocal.deudores_type, integer)
    OWNER TO postgres;
