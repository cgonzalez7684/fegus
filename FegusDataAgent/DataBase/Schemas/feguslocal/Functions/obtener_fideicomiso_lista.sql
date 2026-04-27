CREATE FUNCTION feguslocal.obtener_fideicomiso_lista(p_id_cliente integer, p_id_load_local bigint) RETURNS SETOF feguslocal.fideicomiso
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.fideicomiso t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
