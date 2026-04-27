CREATE PROCEDURE feguslocal.generar_operaciones_deudor(IN pid_load_local bigint, IN p_deudor feguslocal.deudores_type, IN p_cantidad integer)
    LANGUAGE plpgsql
    AS $$
DECLARE

	cur_operaciones CURSOR FOR
    SELECT *
	FROM feguslocal.operacionescredito;
