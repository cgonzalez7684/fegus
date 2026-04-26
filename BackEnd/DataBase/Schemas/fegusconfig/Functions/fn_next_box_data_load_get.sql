CREATE OR REPLACE FUNCTION fegusconfig.fn_next_box_data_load_get(
    p_id_cliente integer
)
RETURNS TABLE (
    id_cliente          integer,
    id_load             bigint,
    id_load_local       bigint,
    state_code          text,
    is_active           text,
    asofdate            date,
    created_at_utc      timestamp,
    updated_at_utc      timestamp,
    attempt_count       integer,
    last_error_message  text,
    pqty                integer,
    psqlcode            integer,
    psqlmessage         text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id_cliente,
        b.id_load,
        b.id_load_local,
        b.state_code,
        b.is_active,
        b.asofdate,
        b.created_at_utc,
        b.updated_at_utc,
        b.attempt_count,
        b.last_error_message,
        1                AS pqty,
        0                AS psqlcode,
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
            NULL::text, NULL::text, NULL::date,
            NULL::timestamp, NULL::timestamp,
            NULL::integer, NULL::text,
            0, 0, 'NO_ROWS'::text;
    END IF;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT
        NULL::integer, NULL::bigint, NULL::bigint,
        NULL::text, NULL::text, NULL::date,
        NULL::timestamp, NULL::timestamp,
        NULL::integer, NULL::text,
        0, SQLSTATE::int, SQLERRM;
END;
$$;