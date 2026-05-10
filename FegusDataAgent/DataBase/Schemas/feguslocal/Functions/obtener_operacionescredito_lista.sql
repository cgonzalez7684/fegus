-- FUNCTION: feguslocal.obtener_operacionescredito_lista(bigint, bigint)

-- DROP FUNCTION IF EXISTS feguslocal.obtener_operacionescredito_lista(bigint, bigint);

CREATE OR REPLACE FUNCTION feguslocal.obtener_operacionescredito_lista(
	p_id_load_local bigint,
	p_last_seq bigint DEFAULT 0)
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
    WHERE oc.id_load_local = p_id_load_local
    AND oc.seq > p_last_seq
    ORDER BY oc.seq;
END;
$BODY$;

ALTER FUNCTION feguslocal.obtener_operacionescredito_lista(bigint, bigint)
    OWNER TO postgres;
