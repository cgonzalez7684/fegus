CREATE PROCEDURE feguslocal.gerancion_datos_dummy(IN p_id_cliente integer, IN p_num_registros integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    i INT;
