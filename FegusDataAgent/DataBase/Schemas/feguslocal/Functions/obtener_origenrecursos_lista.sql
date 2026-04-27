CREATE FUNCTION feguslocal.obtener_origenrecursos_lista(p_id_cliente integer, p_id_load_local bigint) RETURNS SETOF feguslocal.origenrecursos
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.origenrecursos t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
