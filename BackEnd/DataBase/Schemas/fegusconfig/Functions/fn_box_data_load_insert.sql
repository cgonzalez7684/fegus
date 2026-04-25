-- FUNCTION: fegusconfig.fn_box_data_load_insert(integer, character varying, character varying, timestamp without time zone)

-- DROP FUNCTION IF EXISTS fegusconfig.fn_box_data_load_insert(integer, character varying, character varying, timestamp without time zone);

CREATE OR REPLACE FUNCTION fegusconfig.fn_box_data_load_insert(
	p_id_cliente integer,
	p_state_code character varying,
	p_is_active character varying,
	p_asofdate timestamp without time zone)
    RETURNS TABLE(pidload bigint, psqlcode text, psqlmessage text, pqty integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    v_rowcount integer := 0;
BEGIN

    -- Inicializar valores de salida
    pIdLoad     := NULL;
    pSqlCode    := 0;
    pSqlMessage := NULL;
    pQty        := 0;

    -- Insert con RETURNING
    INSERT INTO fegusconfig.fe_box_data_load
    (
        id_cliente,
		id_load_local,
        state_code,
        is_active,
        asofdate
    )
    VALUES
    (
        p_id_cliente,
		0,
        p_state_code,
        p_is_active,
        p_asofdate
    )
    RETURNING id_load INTO pIdLoad;

    -- Obtener filas afectadas
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    pQty := v_rowcount;

    RETURN NEXT;

EXCEPTION
    WHEN OTHERS THEN
        pIdLoad     := NULL;
        pSqlCode    := SQLSTATE;
        pSqlMessage := SQLERRM;
        pQty        := 0;

        RETURN NEXT;
END;
$BODY$;

ALTER FUNCTION fegusconfig.fn_box_data_load_insert(integer, character varying, character varying, timestamp without time zone)
    OWNER TO postgres;
