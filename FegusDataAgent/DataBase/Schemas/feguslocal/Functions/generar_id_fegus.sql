CREATE FUNCTION feguslocal.generar_id_fegus(p_prefijo text, p_secuencia text, p_longitud integer DEFAULT 6) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_next bigint;
