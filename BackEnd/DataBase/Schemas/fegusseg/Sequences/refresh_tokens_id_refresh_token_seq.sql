-- SEQUENCE: fegusseg.refresh_tokens_id_refresh_token_seq

-- DROP SEQUENCE IF EXISTS fegusseg.refresh_tokens_id_refresh_token_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.refresh_tokens_id_refresh_token_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.refresh_tokens_id_refresh_token_seq
    OWNED BY fegusseg.refresh_tokens.id_refresh_token;

ALTER SEQUENCE fegusseg.refresh_tokens_id_refresh_token_seq
    OWNER TO postgres;