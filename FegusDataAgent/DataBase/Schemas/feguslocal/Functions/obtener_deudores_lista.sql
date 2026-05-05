DROP FUNCTION IF EXISTS feguslocal.obtener_deudores_lista CASCADE;
CREATE FUNCTION feguslocal.obtener_deudores_lista(p_id_load_local bigint) RETURNS SETOF feguslocal.deudores
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.deudores
	set id_load_local = p_id_load_local
	where id_load_local = -1;	

    RETURN QUERY
    SELECT *
    FROM feguslocal.deudores d
    WHERE d.id_load_local = p_id_load_local;
END;
$$;
