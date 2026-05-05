-- FUNCTION: feguslocal.obtener_operacionescredito_lista(bigint)

-- DROP FUNCTION IF EXISTS feguslocal.obtener_operacionescredito_lista(bigint);

CREATE OR REPLACE FUNCTION feguslocal.obtener_operacionescredito_lista(
	p_id_load_local bigint)
    RETURNS SETOF feguslocal.operacionescredito 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.operacionescredito
	set id_load_local = p_id_load_local
	where id_load_local = -1;	

    RETURN QUERY
    SELECT *
    FROM feguslocal.operacionescredito oc
    WHERE oc.id_load_local = p_id_load_local;
END;
$BODY$;

ALTER FUNCTION feguslocal.obtener_operacionescredito_lista(bigint)
    OWNER TO postgres;
