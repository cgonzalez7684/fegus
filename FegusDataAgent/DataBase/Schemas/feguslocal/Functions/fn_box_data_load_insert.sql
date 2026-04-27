DROP FUNCTION IF EXISTS feguslocal.fn_box_data_load_insert CASCADE;
CREATE FUNCTION feguslocal.fn_box_data_load_insert(p_id_cliente integer, p_id_load bigint, p_state_code character varying, p_is_active character varying, p_asofdate timestamp without time zone) RETURNS TABLE(pidload bigint, psqlcode text, psqlmessage text, pqty integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_rowcount integer := 0;
BEGIN

    -- Inicializar valores de salida
    pIdLoad     := NULL;
    pSqlCode    := 0;
    pSqlMessage := NULL;
    pQty        := 0;

    -- Insert con RETURNING
    INSERT INTO feguslocal.fe_box_data_load
    (
        id_cliente,
		id_load,
        state_code,
        is_active,
        asofdate
    )
    VALUES
    (
        p_id_cliente,
		p_id_load,
        p_state_code,
        p_is_active,
        p_asofdate
    )
    RETURNING id_load_local INTO pIdLoad;

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
$$;
