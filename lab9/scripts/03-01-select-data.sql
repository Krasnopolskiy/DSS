SET enable_seqscan = off;

EXPLAIN
SELECT *
FROM ordering
WHERE ordered_at BETWEEN '2024-01-01' AND '2024-01-31'
ORDER BY ordered_at;

EXPLAIN
SELECT *
FROM good
WHERE seller = 1;

EXPLAIN
SELECT *
FROM good
WHERE price BETWEEN 10000 AND 50000;

EXPLAIN
SELECT *
FROM "user"
WHERE address ILIKE '%Красноярск%';
