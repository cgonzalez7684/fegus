CREATE FUNCTION feguslocal.fn_box_data_load_insert(p_id_cliente integer, p_id_load bigint, p_state_code character varying, p_is_active character varying, p_asofdate timestamp without time zone) RETURNS TABLE(pidload bigint, psqlcode text, psqlmessage text, pqty integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_rowcount integer := 0;
