SELECT idxname                                                  AS index_name,
       PG_SIZE_PRETTY(PG_RELATION_SIZE(QUOTE_IDENT(idxname)))   AS index_size,
       tablename                                                AS table_name,
       PG_SIZE_PRETTY(PG_RELATION_SIZE(QUOTE_IDENT(tablename))) AS table_size
FROM (VALUES ('idx_ordering_ordered_at', 'ordering'),
             ('idx_good_seller', 'good'),
             ('idx_good_price', 'good'),
             ('idx_user_address', 'user')) AS v(idxname, tablename);
