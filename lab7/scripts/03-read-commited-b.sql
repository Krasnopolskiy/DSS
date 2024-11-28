BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT price
FROM good
WHERE name = 'Смартфон XYZ Pro';

SELECT name
FROM good
WHERE name = 'Ноутбук ABC Lite';

UPDATE good
SET price = 59000.00
WHERE name = 'Смартфон XYZ Pro';

COMMIT;