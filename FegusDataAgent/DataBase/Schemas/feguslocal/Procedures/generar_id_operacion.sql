-- FUNCTION: feguslocal.generar_id_operacion(integer)

-- DROP FUNCTION IF EXISTS feguslocal.generar_id_operacion(integer);

CREATE OR REPLACE FUNCTION feguslocal.generar_id_operacion(
	longitud integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    caracteres text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    salida text := '';
BEGIN
    FOR i IN 1..longitud LOOP
        salida := salida || substr(caracteres, (random()*length(caracteres)+1)::int, 1);
    END LOOP;

    RETURN salida;
END 
$BODY$;

ALTER FUNCTION feguslocal.generar_id_operacion(integer)
    OWNER TO postgres;
