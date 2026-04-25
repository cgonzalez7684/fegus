-- PROCEDURE: fegusseg.sp_generate_test_security_data(integer, integer, integer, integer)

-- DROP PROCEDURE IF EXISTS fegusseg.sp_generate_test_security_data(integer, integer, integer, integer);

CREATE OR REPLACE PROCEDURE fegusseg.sp_generate_test_security_data(
	IN p_customers integer DEFAULT 3,
	IN p_users_per_customer integer DEFAULT 5,
	IN p_roles_per_customer integer DEFAULT 3,
	IN p_permissions_per_customer integer DEFAULT 10)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_customer_id    INTEGER;
    v_user_id        INTEGER;
    v_role_id        INTEGER;
    v_perm_id        INTEGER;
    i                INTEGER;
    j                INTEGER;
    k                INTEGER;
BEGIN
    FOR i IN 1..p_customers LOOP

        -- =========================
        -- CREATE CUSTOMER
        -- =========================
        INSERT INTO fegusseg.customers (
            idcliente,
            cust_dni,
            cust_name,
            entry_date,
            last_pay,
            cust_type,
            is_active
        )
        VALUES (
            1000 + i,
            'DNI-' || (1000 + i),
            'Customer_' || i,
            CURRENT_DATE - (RANDOM() * 100)::INT,
            CURRENT_DATE,
            (RANDOM() * 3)::INT + 1,
            'Y'
        )
        ON CONFLICT (cust_dni) DO NOTHING;

        v_customer_id := 1000 + i;

        -- =========================
        -- CREATE ROLES
        -- =========================
        FOR j IN 1..p_roles_per_customer LOOP
            INSERT INTO fegusseg.roles (
                idcliente,
                role_name,
                description,
                is_active
            )
            VALUES (
                v_customer_id,
                'ROLE_' || j,
                'Auto-generated role ' || j,
                'Y'
            )
            ON CONFLICT (idcliente, role_name) DO NOTHING;
        END LOOP;

        -- =========================
        -- CREATE PERMISSIONS
        -- =========================
        FOR j IN 1..p_permissions_per_customer LOOP
            INSERT INTO fegusseg.permissions (
                idcliente,
                permiss_code,
                description,
                is_active
            )
            VALUES (
                v_customer_id,
                'P' || LPAD(j::TEXT, 5, '0'),
                'Auto-generated permission ' || j,
                'Y'
            )
            ON CONFLICT (idcliente, permiss_code) DO NOTHING;
        END LOOP;

        -- =========================
        -- CREATE USERS
        -- =========================
        FOR j IN 1..p_users_per_customer LOOP
            INSERT INTO fegusseg.users (
                idcliente,
                user_name,
                user_email,
                pass_hash,
                status,
                is_active
            )
            VALUES (
                v_customer_id,
                'user_' || j,
                'user_' || j || '@customer' || i || '.com',
                md5(random()::text),
                'A',
                'Y'
            )
            ON CONFLICT (idcliente, user_name) DO NOTHING;
        END LOOP;

        -- =========================
        -- ASSIGN ROLES TO USERS
        -- =========================
        FOR v_user_id IN
            SELECT iduser FROM fegusseg.users WHERE idcliente = v_customer_id
        LOOP
            INSERT INTO fegusseg.user_roles (
                idcliente,
                iduser,
                idrole
            )
            SELECT
                v_customer_id,
                v_user_id,
                r.idrole
            FROM fegusseg.roles r
            WHERE r.idcliente = v_customer_id
            ORDER BY RANDOM()
            LIMIT 1
            ON CONFLICT DO NOTHING;
        END LOOP;

        -- =========================
        -- ASSIGN PERMISSIONS TO ROLES
        -- =========================
        FOR v_role_id IN
            SELECT idrole FROM fegusseg.roles WHERE idcliente = v_customer_id
        LOOP
            INSERT INTO fegusseg.role_permissions (
                idcliente,
                idrole,
                idpermiss
            )
            SELECT
                v_customer_id,
                v_role_id,
                p.idpermiss
            FROM fegusseg.permissions p
            WHERE p.idcliente = v_customer_id
            ORDER BY RANDOM()
            LIMIT (RANDOM() * 4 + 1)::INT
            ON CONFLICT DO NOTHING;
        END LOOP;

        -- =========================
        -- DIRECT USER PERMISSIONS
        -- =========================
        FOR v_user_id IN
            SELECT iduser FROM fegusseg.users WHERE idcliente = v_customer_id
        LOOP
            INSERT INTO fegusseg.user_permissions (
                idcliente,
                iduser,
                idpermiss
            )
            SELECT
                v_customer_id,
                v_user_id,
                p.idpermiss
            FROM fegusseg.permissions p
            WHERE p.idcliente = v_customer_id
            ORDER BY RANDOM()
            LIMIT 1
            ON CONFLICT DO NOTHING;
        END LOOP;

    END LOOP;

    RAISE NOTICE 'Test security data generation completed successfully.';
END;
$BODY$;
ALTER PROCEDURE fegusseg.sp_generate_test_security_data(integer, integer, integer, integer)
    OWNER TO postgres;
