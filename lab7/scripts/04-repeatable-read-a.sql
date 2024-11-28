BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

UPDATE good
SET price = 19000.00
WHERE name = 'Смартфон XYZ Pro';

INSERT INTO good (id, name, description, price, amount, seller)
VALUES (20, 'Ноутбук ABC Lite', 'Диагональ экрана 15.6 дюймов, видеокарта GTX 1660 Ti.', 19000.00, 10, 1);

ROLLBACK;