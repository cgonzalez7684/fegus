-- FUNCTION: fegusconfig.fn_box_data_load_get(integer, bigint)

-- DROP FUNCTION IF EXISTS fegusconfig.fn_box_data_load_get(integer, bigint);

CREATE OR REPLACE FUNCTION fegusconfig.fn_box_data_load_get(
	p_id_cliente integer,
	p_id_load bigint DEFAULT NULL::bigint)
    RETURNS TABLE(id_cliente integer, id_load bigint, state_code character varying, is_active character varying, asofdate timestamp without time zone, created_at_utc timestamp without time zone, updated_at_utc timestamp without time zone, psqlcode integer, psqlmessage text, pqty integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_rowcount integer := 0;
BEGIN	

    RETURN QUERY
    SELECT
        b.id_cliente,
        b.id_load,
        b.state_code,
        b.is_active,
        b.asofdate,
        b.created_at_utc,
        b.updated_at_utc,
        0,--NULL::text,
        NULL::text,
        1
    FROM fegusconfig.fe_box_data_load b
    WHERE b.id_cliente = p_id_cliente
      AND (p_id_load IS NULL OR b.id_load = p_id_load);

    GET DIAGNOSTICS v_rowcount = ROW_COUNT;

    IF v_rowcount = 0 THEN
        RETURN QUERY
        SELECT
            0, 0, NULL, NULL, NULL, NULL, NULL,
            0,
            'No se encontraron registros',
            0;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY
        SELECT
            NULL, NULL, NULL, NULL, NULL, NULL, NULL,
            SQLSTATE,
            SQLERRM,
            0;
END;
$BODY$;

ALTER FUNCTION fegusconfig.fn_box_data_load_get(integer, bigint)
    OWNER TO postgres;
