CREATE FUNCTION feguslocal.obtener_operacionescredito_lista(p_id_load_local bigint) RETURNS SETOF feguslocal.operacionescredito
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.operacionescredito
	set id_load_local = p_id_load_local
	where id_load_local = -1;
