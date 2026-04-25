-- FUNCTION: feguslocal.generar_id_fegus(text, text, integer)

-- DROP FUNCTION IF EXISTS feguslocal.generar_id_fegus(text, text, integer);

CREATE OR REPLACE FUNCTION feguslocal.generar_id_fegus(
	p_prefijo text,
	p_secuencia text,
	p_longitud integer DEFAULT 6)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_next bigint;
    v_sql text;
BEGIN
    -- Construcción dinámica de nextval
    v_sql := format('SELECT nextval(''feguslocal.%I'')', p_secuencia);
    
    EXECUTE v_sql INTO v_next;

    RETURN p_prefijo || LPAD(v_next::text, p_longitud, '0');
END;
$BODY$;

ALTER FUNCTION feguslocal.generar_id_fegus(text, text, integer)
    OWNER TO postgres;
