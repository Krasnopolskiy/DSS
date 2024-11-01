SELECT rolname
FROM pg_roles
WHERE rolname IN ('analyst', 'manager', 'administrator');

SELECT rolname,
       rolsuper,
       rolcreaterole,
       rolcreatedb,
       rolcanlogin
FROM pg_roles
WHERE rolname IN ('analyst', 'manager', 'administrator');

SELECT datname,
       HAS_DATABASE_PRIVILEGE('analyst', datname, 'CONNECT')       AS analyst_connect,
       HAS_DATABASE_PRIVILEGE('manager', datname, 'CONNECT')       AS manager_connect,
       HAS_DATABASE_PRIVILEGE('administrator', datname, 'CONNECT') AS administrator_connect
FROM pg_database
WHERE datname = 'lab6';

SELECT nspname,
       HAS_SCHEMA_PRIVILEGE('analyst', nspname, 'USAGE')       AS analyst,
       HAS_SCHEMA_PRIVILEGE('manager', nspname, 'USAGE')       AS manager,
       HAS_SCHEMA_PRIVILEGE('administrator', nspname, 'USAGE') AS administrator
FROM pg_namespace
WHERE nspname IN ('user', 'catalog', 'sales');

SELECT r.rolname   AS role_name,
       n.nspname   AS schema_name,
       c.relname   AS table_name,
       p.privilege AS privilege_type
FROM pg_roles r
         CROSS JOIN
     pg_namespace n
         JOIN
     pg_class c ON c.relnamespace = n.oid AND c.relkind = 'r' -- только таблицы
         CROSS JOIN
         (VALUES ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE')) AS p(privilege)
WHERE r.rolname IN ('analyst', 'manager', 'administrator')
  AND n.nspname IN ('catalog', 'sales', 'user')
  AND HAS_TABLE_PRIVILEGE(r.rolname, c.oid, p.privilege)
ORDER BY r.rolname, n.nspname, c.relname, p.privilege;
