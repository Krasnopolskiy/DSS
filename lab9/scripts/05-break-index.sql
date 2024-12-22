SET enable_seqscan = off;

INSERT INTO "user" (name, email, address)
SELECT 'Пользователь ' || i,
       'user-' || i || '@example.com',
       'Москва, ' || MD5(RANDOM()::TEXT)
FROM GENERATE_SERIES(1, 100000) AS s(i);

ANALYZE VERBOSE;

EXPLAIN
SELECT *
FROM "user"
WHERE address ILIKE '%Красноярск%';
