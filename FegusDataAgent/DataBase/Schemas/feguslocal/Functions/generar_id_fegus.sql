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

    -- GREATEST(...) prevents LPAD from truncating when the sequence value exceeds p_longitud digits.
    RETURN p_prefijo || LPAD(v_next::text, GREATEST(p_longitud, LENGTH(v_next::text)), '0');
END;
$$;

ALTER FUNCTION feguslocal.generar_id_fegus(text, text, integer)
    OWNER TO postgres;
