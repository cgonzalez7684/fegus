CREATE FUNCTION feguslocal.obtener_bienesrealizablesnoreportados_lista(p_id_cliente integer, p_id_load_local bigint) RETURNS SETOF feguslocal.bienesrealizablesnoreportados
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.bienesrealizablesnoreportados t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
