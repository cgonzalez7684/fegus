-- PROCEDURE: feguslocal.generar_cuentasxcobrar(bigint, varchar)
--
-- Genera 0 a 2 cuentasxcobrar asociadas a una operación.
-- Catálogo usado: tipo_catalogo. Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_cuentasxcobrar CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_cuentasxcobrar(
    IN pid_load_local bigint,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
BEGIN
    v_cantidad := floor(random() * 3)::int;  -- 0..2

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.cuentasxcobrar (
                id_load_local, idoperacioncredito, idcuentacobrarasociada,
                cuentacontablecuentacobrarasociada, tipocatalogosugef,
                saldocuentacobrarasociada, tipomonedacuentacobrarasociada,
                diasatrasocuentacobrarasociada, fecharegistrocuentacobrarasociada,
                fechavencimientocuentacobrarasociada, concepto, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                feguslocal.generar_id_fegus('CXC','seq_operacion'),
                ((ARRAY[13831101,13832134,13831110,13831102,13831210,
                       13831103])[floor(random() * 6 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)])::varchar,
                round((random() * 1000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                floor(random() * 365)::int,
                (CURRENT_DATE - (random() * 365)::int),
                (CURRENT_DATE + (random() * 730)::int),
                'Concepto generado para test ' || j::text,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_cuentasxcobrar] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cuentasxcobrar] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_cuentasxcobrar(bigint, varchar) OWNER TO postgres;
