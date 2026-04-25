-- FUNCTION: fegusconfig.fn_box_data_load_update(integer, bigint, bigint, character varying, character varying, integer, text)

-- DROP FUNCTION IF EXISTS fegusconfig.fn_box_data_load_update(integer, bigint, bigint, character varying, character varying, integer, text);

CREATE OR REPLACE FUNCTION fegusconfig.fn_box_data_load_update(
	p_id_cliente integer,
	p_id_load bigint,
	p_id_load_local bigint,
	p_state_code character varying,
	p_is_active character varying,
	p_attempt_count integer DEFAULT NULL::integer,
	p_last_error_message text DEFAULT NULL::text)
    RETURNS TABLE(psqlcode text, psqlmessage text, pqty integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_rowcount integer := 0;
BEGIN

    pSqlCode    := 0;
    pSqlMessage := NULL;
    pQty        := 0;

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

    GET DIAGNOSTICS v_rowcount = ROW_COUNT;

    pQty := v_rowcount;

    RETURN NEXT;

EXCEPTION
    WHEN OTHERS THEN
        pSqlCode    := SQLSTATE;
        pSqlMessage := SQLERRM;
        pQty        := 0;

        RETURN NEXT;
END;
$BODY$;

ALTER FUNCTION fegusconfig.fn_box_data_load_update(integer, bigint, bigint, character varying, character varying, integer, text)
    OWNER TO postgres;
