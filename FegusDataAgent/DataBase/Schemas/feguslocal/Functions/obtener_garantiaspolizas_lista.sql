-- FUNCTION: feguslocal.obtener_garantiaspolizas_lista(bigint, bigint)

-- DROP FUNCTION IF EXISTS feguslocal.obtener_garantiaspolizas_lista(bigint, bigint);

CREATE OR REPLACE FUNCTION feguslocal.obtener_garantiaspolizas_lista(
	p_id_load_local bigint,
	p_last_seq bigint DEFAULT 0)
    RETURNS SETOF feguslocal.garantiaspolizas
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiaspolizas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiaspolizas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$BODY$;

ALTER FUNCTION feguslocal.obtener_garantiaspolizas_lista(bigint, bigint)
    OWNER TO postgres;
