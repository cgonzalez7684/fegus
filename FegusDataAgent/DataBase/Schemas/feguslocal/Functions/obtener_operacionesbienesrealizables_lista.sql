DROP FUNCTION IF EXISTS feguslocal.obtener_operacionesbienesrealizables_lista CASCADE;
CREATE FUNCTION feguslocal.obtener_operacionesbienesrealizables_lista(p_id_cliente integer, p_id_load_local bigint) RETURNS SETOF feguslocal.operacionesbienesrealizables
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.operacionesbienesrealizables t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
END; $$;
