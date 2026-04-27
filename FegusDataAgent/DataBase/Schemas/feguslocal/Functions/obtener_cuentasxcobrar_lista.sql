DROP FUNCTION IF EXISTS feguslocal.obtener_cuentasxcobrar_lista CASCADE;
CREATE FUNCTION feguslocal.obtener_cuentasxcobrar_lista(p_id_cliente integer, p_id_load_local bigint) RETURNS SETOF feguslocal.cuentasxcobrar
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.cuentasxcobrar t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
END; $$;
