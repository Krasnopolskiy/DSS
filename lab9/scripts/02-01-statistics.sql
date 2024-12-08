SELECT schemaname,
       relname             AS "table_name",
       n_live_tup          AS "rows_count",
       n_dead_tup          AS "dead_rows",
       n_mod_since_analyze AS "changes_since_analyze",
       last_analyze        AS "last_analyze",
       last_autoanalyze    AS "last_autoanalyze"
FROM pg_stat_user_tables
WHERE schemaname = 'public';
