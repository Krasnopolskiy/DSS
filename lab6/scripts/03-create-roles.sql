CREATE ROLE user_read;
GRANT USAGE ON SCHEMA "user" TO user_read;
GRANT SELECT ON ALL TABLES IN SCHEMA "user" TO user_read;

CREATE ROLE user_write;
GRANT USAGE ON SCHEMA "user" TO user_write;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "user" TO user_write;

CREATE ROLE catalog_read;
GRANT USAGE ON SCHEMA catalog TO catalog_read;
GRANT SELECT ON ALL TABLES IN SCHEMA catalog TO catalog_read;

CREATE ROLE catalog_write;
GRANT USAGE ON SCHEMA catalog TO catalog_write;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA catalog TO catalog_write;

CREATE ROLE sales_read;
GRANT USAGE ON SCHEMA sales TO sales_read;
GRANT SELECT ON ALL TABLES IN SCHEMA sales TO sales_read;

CREATE ROLE sales_write;
GRANT USAGE ON SCHEMA sales TO sales_write;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sales TO sales_write;

CREATE ROLE analyst;
GRANT catalog_read TO analyst;
GRANT sales_read TO analyst;
GRANT CONNECT ON DATABASE lab6 TO analyst;
GRANT USAGE ON SCHEMA catalog TO analyst;
GRANT USAGE ON SCHEMA sales TO analyst;

CREATE ROLE manager;
GRANT catalog_read TO manager;
GRANT catalog_write TO manager;
GRANT sales_read TO manager;
GRANT CONNECT ON DATABASE lab6 TO manager;
GRANT USAGE ON SCHEMA catalog TO manager;
GRANT USAGE ON SCHEMA sales TO manager;

CREATE ROLE administrator;
GRANT user_read TO administrator;
GRANT user_write TO administrator;
GRANT catalog_read TO administrator;
GRANT catalog_write TO administrator;
GRANT sales_read TO administrator;
GRANT sales_write TO administrator;
GRANT CONNECT ON DATABASE lab6 TO administrator;
GRANT USAGE ON SCHEMA "user" TO administrator;
GRANT USAGE ON SCHEMA catalog TO administrator;
GRANT USAGE ON SCHEMA sales TO administrator;

ALTER DEFAULT PRIVILEGES IN SCHEMA catalog GRANT SELECT ON TABLES TO analyst;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT ON TABLES TO analyst;

ALTER DEFAULT PRIVILEGES IN SCHEMA catalog GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT ON TABLES TO manager;

ALTER DEFAULT PRIVILEGES IN SCHEMA "user" GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO administrator;
ALTER DEFAULT PRIVILEGES IN SCHEMA catalog GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO administrator;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO administrator;
