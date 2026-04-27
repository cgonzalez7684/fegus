-- FUNCTION: fegusconfig.fn_next_box_data_load_get(integer)

-- DROP FUNCTION IF EXISTS fegusconfig.fn_next_box_data_load_get(integer);

CREATE OR REPLACE FUNCTION fegusconfig.fn_next_box_data_load_get(
	p_id_cliente integer)
    RETURNS TABLE(id_cliente integer, id_load bigint, id_load_local bigint, state_code text, is_active text, asofdate timestamp without time zone, created_at_utc timestamp without time zone, updated_at_utc timestamp without time zone, attempt_count integer, last_error_message text, pqty integer, psqlcode integer, psqlmessage text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT
        b.id_cliente::integer,
        b.id_load::bigint,
        b.id_load_local::bigint,
        b.state_code::text,
        b.is_active::text,
        b.asofdate::timestamp,
        b.created_at_utc,
        b.updated_at_utc,
        b.attempt_count::integer,
        b.last_error_message::text,
        1::integer       AS pqty,
        0::integer       AS psqlcode,
        'OK'::text       AS psqlmessage
    FROM fegusconfig.fe_box_data_load b
    WHERE b.id_cliente = p_id_cliente
      AND b.is_active  = 'A'
      AND b.state_code <> 'ERROR'
      AND b.state_code <> 'COMPLETED'
    ORDER BY b.created_at_utc ASC
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN QUERY SELECT
            NULL::integer, NULL::bigint, NULL::bigint,
            NULL::text, NULL::text, NULL::timestamp,
            NULL::timestamp, NULL::timestamp,
            NULL::integer, NULL::text,
            0::integer, 0::integer, 'NO_ROWS'::text;
    END IF;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT
        NULL::integer, NULL::bigint, NULL::bigint,
        NULL::text, NULL::text, NULL::timestamp,
        NULL::timestamp, NULL::timestamp,
        NULL::integer, NULL::text,
        0::integer, 0::integer, SQLERRM::text;
END;
$BODY$;

ALTER FUNCTION fegusconfig.fn_next_box_data_load_get(integer)
    OWNER TO postgres;
