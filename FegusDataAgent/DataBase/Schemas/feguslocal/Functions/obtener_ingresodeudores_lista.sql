DROP FUNCTION IF EXISTS feguslocal.obtener_ingresodeudores_lista CASCADE;
CREATE FUNCTION feguslocal.obtener_ingresodeudores_lista(p_id_cliente integer, p_id_load_local bigint) RETURNS SETOF feguslocal.ingresodeudores
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.ingresodeudores t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
END; $$;
