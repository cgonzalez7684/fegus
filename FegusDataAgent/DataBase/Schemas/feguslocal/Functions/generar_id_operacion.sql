CREATE FUNCTION feguslocal.generar_id_operacion(longitud integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    caracteres text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
