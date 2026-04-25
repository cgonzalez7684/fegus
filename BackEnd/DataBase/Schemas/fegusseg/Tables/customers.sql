-- Table: fegusseg.customers

-- DROP TABLE IF EXISTS fegusseg.customers;

CREATE TABLE IF NOT EXISTS fegusseg.customers
(
    idcliente integer NOT NULL,
    cust_dni character varying(50) COLLATE pg_catalog."default" NOT NULL,
    cust_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    entry_date date NOT NULL,
    last_pay date NOT NULL,
    cust_type integer NOT NULL,
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT customers_pkey PRIMARY KEY (idcliente),
    CONSTRAINT uk_custname UNIQUE (cust_name),
    CONSTRAINT uk_dni UNIQUE (cust_dni)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.customers
    OWNER to postgres;

COMMENT ON TABLE fegusseg.customers
    IS 'Financial entities (tenants) subscribed to the FEGUS SaaS platform';

COMMENT ON COLUMN fegusseg.customers.idcliente
    IS 'Primary key. Unique identifier of the customer (tenant)';

COMMENT ON COLUMN fegusseg.customers.cust_dni
    IS 'Legal identification number of the customer (tax ID or national ID)';

COMMENT ON COLUMN fegusseg.customers.cust_name
    IS 'Official name of the financial entity';

COMMENT ON COLUMN fegusseg.customers.entry_date
    IS 'Date when the customer was registered in the FEGUS platform';

COMMENT ON COLUMN fegusseg.customers.last_pay
    IS 'Date of the last successful subscription payment';

COMMENT ON COLUMN fegusseg.customers.cust_type
    IS 'Customer type (e.g. Bank, Cooperative, Finance Company)';

COMMENT ON COLUMN fegusseg.customers.is_active
    IS 'Indicates whether the customer account is active (Y/N)';