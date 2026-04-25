-- FUNCTION: fegusconfig.fn_next_box_data_load_get(integer)

-- DROP FUNCTION IF EXISTS fegusconfig.fn_next_box_data_load_get(integer);

CREATE OR REPLACE FUNCTION fegusconfig.fn_next_box_data_load_get(
	p_id_cliente integer)
    RETURNS TABLE(id_cliente integer, id_load bigint, id_load_local bigint, state_code character varying, is_active character varying, asofdate timestamp without time zone, created_at_utc timestamp without time zone, updated_at_utc timestamp without time zone, attempt_count integer, last_error_message text, psqlcode integer, psqlmessage text, pqty integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_rowcount integer := 0;
BEGIN    

    RAISE NOTICE 'Inicio función - p_id_cliente: %', p_id_cliente;

    RETURN QUERY
    SELECT
        b.id_cliente::integer,
        b.id_load::bigint,
		b.id_load_local::bigint,
        b.state_code,
        b.is_active,
        b.asofdate,
        b.created_at_utc,
        b.updated_at_utc,
		b.attempt_count,
        b.last_error_message,
        0::integer,
        NULL::text,
        1::integer
    FROM fegusconfig.fe_box_data_load b
    WHERE b.id_cliente = p_id_cliente
      AND b.state_code IN ('NEW','RELOADING')
      AND b.is_active = 'A'
    ORDER BY b.created_at_utc ASC
    LIMIT 1;

    GET DIAGNOSTICS v_rowcount = ROW_COUNT;

    RAISE NOTICE 'Filas encontradas: %', v_rowcount;

    IF v_rowcount = 0 THEN

        RAISE NOTICE 'No se encontraron registros NEW';

        RETURN QUERY
        SELECT
            0::integer,
            0::bigint,
			0::bigint,
            NULL::varchar,
            NULL::varchar,
            NULL::timestamp,
            NULL::timestamp,
            NULL::timestamp,
			NULL::integer,
			NULL::text,
            0::integer,
            'No hay registros con estado NEW'::text,
            0::integer;
    END IF;

    RAISE NOTICE 'Fin ejecución normal';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error capturado: % - %', SQLSTATE, SQLERRM;

        RETURN QUERY
        SELECT
            0::integer,
            0::bigint,
			0::bigint,
            NULL::varchar,
            NULL::varchar,
            NULL::timestamp,
            NULL::timestamp,
            NULL::timestamp,
			NULL::integer,
			NULL::text,
            -1::integer,
            SQLERRM::text,
            0::integer;
END;
$BODY$;

ALTER FUNCTION fegusconfig.fn_next_box_data_load_get(integer)
    OWNER TO postgres;
