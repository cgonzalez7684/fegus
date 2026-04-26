DROP FUNCTION IF EXISTS fegusconfig.fn_box_data_load_update(
    integer, bigint, bigint, text, text);

CREATE OR REPLACE FUNCTION fegusconfig.fn_box_data_load_update(
    p_id_cliente            integer,
    p_id_load               bigint,
    p_id_load_local         bigint,
    p_state_code            text,
    p_is_active             text,
    p_attempt_count         integer DEFAULT NULL,
    p_last_error_message    text    DEFAULT NULL
)
RETURNS TABLE (
    pqty        integer,
    psqlcode    integer,
    psqlmessage text
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    UPDATE fegusconfig.fe_box_data_load
    SET id_load_local       = COALESCE(p_id_load_local,      id_load_local),
        state_code          = COALESCE(p_state_code,         state_code),
        is_active           = COALESCE(p_is_active,          is_active),
        attempt_count       = COALESCE(p_attempt_count,      attempt_count),
        last_error_message  = CASE
                                  WHEN p_last_error_message IS NULL
                                      THEN last_error_message
                                  ELSE p_last_error_message
                              END,
        updated_at_utc      = NOW()
    WHERE id_cliente = p_id_cliente
      AND id_load    = p_id_load;

    GET DIAGNOSTICS v_qty = ROW_COUNT;

    RETURN QUERY SELECT v_qty, 0, 'OK'::text;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT 0, SQLSTATE::int, SQLERRM;
END;
$$;