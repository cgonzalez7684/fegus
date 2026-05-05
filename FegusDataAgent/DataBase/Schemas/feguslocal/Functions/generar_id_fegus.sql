DROP FUNCTION IF EXISTS feguslocal.generar_id_fegus CASCADE;
CREATE FUNCTION feguslocal.generar_id_fegus(p_prefijo text, p_secuencia text, p_longitud integer DEFAULT 6) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_next bigint;
    v_sql text;
BEGIN
    -- Construcci├│n din├ímica de nextval
    v_sql := format('SELECT nextval(''feguslocal.%I'')', p_secuencia);
    
    EXECUTE v_sql INTO v_next;

    RETURN p_prefijo || LPAD(v_next::text, p_longitud, '0');
END;
$$;
