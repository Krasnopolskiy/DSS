# НИЯУ МИФИ. Лабораторная работа №7. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Наполнение данными](scripts/02-populate-tables.sql)
3. [READ COMMITTED - A](scripts/03-read-commited-a.sql)
4. [READ COMMITTED - B](scripts/03-read-commited-b.sql)
5. [REPEATABLE READ - A](scripts/04-repeatable-read-a.sql)
6. [REPEATABLE READ - B](scripts/04-repeatable-read-b.sql)
7. [SERIALIZABLE - A](scripts/05-serializable-a.sql)
8. [SERIALIZABLE - B](scripts/05-serializable-b.sql)

## Изоляция READ COMMITTED

### Транзакция A

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

UPDATE good
SET price = 19000.00
WHERE name = 'Смартфон XYZ Pro';

INSERT INTO good (id, name, description, price, amount, seller)
VALUES (20, 'Ноутбук ABC Lite', 'Диагональ экрана 15.6 дюймов, видеокарта GTX 1660 Ti.', 19000.00, 10, 1);
```

### Транзакция B

```sql
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
```

#### Данные сессии B до COMMIT сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул
- Внесение изменений - запрос завис

#### Данные сессии B после ROLLBACK сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул
- Внесение изменений - запрос выполнился

#### Данные сессии B после COMMIT сессии A

- Обновленный товар - получена новая цена
- Добавленный товар - запрос вернул название добавленного товара
- Внесение изменений - запрос выполнился

#### Обоснование

Dirty read разрешен на данном уровне изоляции, поэтому транзакция B может прочитать данные, которые были обновлены за
рамками этой транзакции. Также READ COMMITED позволяет фантомное чтение, поэтому добавленные данные также доступны.
Запрос на добавление изменений завис, так как строчка была заблокирована транзакцией A, и отвис сразу как только
транзакция A была выполнена или отменена.

## Изоляция REPEATABLE READ

### Транзакция A

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

UPDATE good
SET price = 19000.00
WHERE name = 'Смартфон XYZ Pro';

INSERT INTO good (id, name, description, price, amount, seller)
VALUES (20, 'Ноутбук ABC Lite', 'Диагональ экрана 15.6 дюймов, видеокарта GTX 1660 Ti.', 19000.00, 10, 1);
```

### Транзакция B

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT price
FROM good
WHERE name = 'Смартфон XYZ Pro';

SELECT name
FROM good
WHERE name = 'Ноутбук ABC Lite';

UPDATE good
SET price = 59000.00
WHERE name = 'Смартфон XYZ Pro';
```

#### Данные сессии B до COMMIT сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул

#### Данные сессии B после ROLLBACK сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул

#### Данные сессии B после COMMIT сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул

#### Обоснование

Dirty read на данном уровне изоляции уже невозможен, поэтому транзакция B не может прочитать данные, которые были
обновлены за рамками этой транзакции. Хотя фактически REPETABLE READ позволяет фантомное чтение, PostgreSQL фактически
приводит этот уровень изоляции к уровню SERIALIZABLE, поэтому добавленные данные также недоступны. Запрос на обновление
данных ведет себя аналогично как с уровнем изоляции READ COMMITED.

## Изоляция SERIALIZABLE

### Транзакция A

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

UPDATE good
SET price = 19000.00
WHERE name = 'Смартфон XYZ Pro';

INSERT INTO good (id, name, description, price, amount, seller)
VALUES (20, 'Ноутбук ABC Lite', 'Диагональ экрана 15.6 дюймов, видеокарта GTX 1660 Ti.', 19000.00, 10, 1);
```

### Транзакция B

```sql
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT price
FROM good
WHERE name = 'Смартфон XYZ Pro';

SELECT name
FROM good
WHERE name = 'Ноутбук ABC Lite';

UPDATE good
SET price = 59000.00
WHERE name = 'Смартфон XYZ Pro';
```

#### Данные сессии B до COMMIT сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул

#### Данные сессии B после ROLLBACK сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул

#### Данные сессии B после COMMIT сессии A

- Обновленный товар - получена старая цена
- Добавленный товар - запрос ничего не вернул

#### Обоснование

Результаты аналогичны результатам REPEATABLE READ: dirty read и фантомное чтение невозможны на данном уровне изоляции.
Запрос на обновление данных ведет себя аналогично как с уровнем изоляции READ COMMITED.

## Заключение

В ходе данной работы было проведено наблюдение за работой двух транзакций с разными уровнями изоляций. Было выяснено,
что уровень изоляции READ COMMITED запрещает грязное чтение, но позволяет фантомное чтение. Уровни изоляции REPEATABLE
READ и SERIALIZABLE одинаково запрещают грязное чтение и не позволяют фантомное чтение. На всех трех уровнях изоляции
нельзя внести изменения в данные, которые изменяются другой транзакцией до тех пор, пока она не будет выполнена или
отменена.
