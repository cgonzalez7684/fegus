DROP FUNCTION IF EXISTS feguslocal.obtener_operacionesnoreportadas_lista(p_id_cliente integer, p_id_load_local bigint) CASCADE;
CREATE OR REPLACE FUNCTION feguslocal.obtener_operacionesnoreportadas_lista(p_id_cliente integer, p_id_load_local bigint)  RETURNS SETOF feguslocal.operacionesnoreportadas  LANGUAGE plpgsql AS $function$ 
BEGIN     RETURN QUERY SELECT * FROM feguslocal.operacionesnoreportadas t     WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local; END; $function$
