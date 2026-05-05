-- FUNCTION: feguslocal.obtener_fideicomiso_lista(integer, bigint)

-- DROP FUNCTION IF EXISTS feguslocal.obtener_fideicomiso_lista(integer, bigint);

CREATE OR REPLACE FUNCTION feguslocal.obtener_fideicomiso_lista(	
	p_id_load_local bigint)
    RETURNS SETOF feguslocal.fideicomiso 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.fideicomiso
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.fideicomiso t
    WHERE t.id_load_local = p_id_load_local;
END; 
$BODY$;

ALTER FUNCTION feguslocal.obtener_fideicomiso_lista(bigint)
    OWNER TO postgres;
