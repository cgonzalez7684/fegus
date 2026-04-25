-- FUNCTION: fegusconfig.fn_box_data_load_delete(integer, bigint)

-- DROP FUNCTION IF EXISTS fegusconfig.fn_box_data_load_delete(integer, bigint);

CREATE OR REPLACE FUNCTION fegusconfig.fn_box_data_load_delete(
	p_id_cliente integer,
	p_id_load bigint)
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

    DELETE FROM fegusconfig.fe_box_data_load
    WHERE id_cliente = p_id_cliente
      AND id_load = p_id_load;

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

ALTER FUNCTION fegusconfig.fn_box_data_load_delete(integer, bigint)
    OWNER TO postgres;
