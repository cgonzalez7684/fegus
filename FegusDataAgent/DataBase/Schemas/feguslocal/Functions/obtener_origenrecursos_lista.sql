-- FUNCTION: feguslocal.obtener_origenrecursos_lista(integer, bigint)

-- DROP FUNCTION IF EXISTS feguslocal.obtener_origenrecursos_lista(integer, bigint);

CREATE OR REPLACE FUNCTION feguslocal.obtener_origenrecursos_lista(
	p_id_cliente integer,
	p_id_load_local bigint)
    RETURNS SETOF feguslocal.origenrecursos 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY SELECT * FROM feguslocal.origenrecursos t
    WHERE t.id_cliente = p_id_cliente AND t.id_load_local = p_id_load_local;
END; 
$BODY$;

ALTER FUNCTION feguslocal.obtener_origenrecursos_lista(integer, bigint)
    OWNER TO postgres;
