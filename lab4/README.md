# НИЯУ МИФИ. Лабораторная работа №4. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Наполнение данными](scripts/02-populate-tables.sql)
3. [Выборка данных (lab2)](scripts/03-02-select-data.sql)
4. [Выборка данных (lab3)](scripts/03-03-select-data.sql)
5. [Выборка данных (lab4)](scripts/03-04-select-data.sql)

## Использование PostgreSQL

Запуск СУБД осуществляется в Docker образе с использованием оркестратора Docker Compose для удобства описания сервиса:

```yaml
services:
  postgres:
    image: postgres
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=lab4
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - ./scripts:/docker-entrypoint-initdb.d
```

В качестве клиента используется DataGrip.

## Миграция SQLite -> PostgreSQL

### Задание первичного ключа

В SQLite, `INTEGER PRIMARY KEY` автоматически означает столбец с автоинкрементом. В PostgreSQL для создания
автоинкрементного столбца используется `SERIAL`, который связывает столбец с последовательностью для генерации
последовательных значений.

```sql
INTEGER PRIMARY KEY -> SERIAL PRIMARY KEY
```

### Ключевое слово "user"

В PostgreSQL, слово `user` является зарезервированным словом и не может использоваться как идентификатор без кавычек. В
SQLite такого ограничения нет.

```sql
user -> "user"
```

### Извлечение порядкового номера дня из даты

Функция `JULIANDAY` в SQLite возвращает порядковый номер дня для даты, что использовалось для сравнения дат.
В PostgreSQL этой функции нет, поэтому используется `EXTRACT` с параметром `JULIAN`.

```sql
JULIANDAY(received_at) - JULIANDAY(ordered_at) -> EXTRACT(JULIAN FROM received_at) - EXTRACT(JULIAN FROM ordered_at)
```

### Извлечение месяца из даты

В SQLite для форматирования даты используется функция `STRFTIME`. В PostgreSQL для извлечения компонента месяца из
даты используется функция `EXTRACT` с параметром `month`.

```sql
STRFTIME('%m', o.ordered_at) -> EXTRACT(month FROM o.ordered_at)
```

### Выборка с группировкой

В SQLite, разрешается использовать столбцы в выражении `SELECT`, которые не включены в `GROUP BY`. PostgreSQL требует,
чтобы все столбцы, указанные в `SELECT`, которые не являются агрегатными функциями, должны быть частью `GROUP BY`.

PostgreSQL строже относится к использованию столбцов в выражениях SELECT, которые не указаны в GROUP BY или не обернуты
в агрегатные функции.

```sql
SELECT name, COUNT(*) AS late_shippings
FROM ordering_item
         JOIN good ON good.id = good
WHERE ordering IN late_shipping
GROUP BY good
ORDER BY late_shippings DESC;

->

SELECT good.name, COUNT(*) AS late_shippings
FROM ordering_item oi
         JOIN good ON oi.good = good.id
WHERE oi.ordering IN (SELECT id FROM late_shipping)
GROUP BY good.name
ORDER BY late_shippings DESC;
```

### Разница в результатах

Несмотря на некоторые отличия в диалектах, результаты выполнения запросов не отличаются до и после миграции.

## Выполненные запросы

### Определение периода заказов и написания отзывов

#### SQL запрос

```sql
WITH ordered_period AS (SELECT good.id                                       AS good_id,
                               MIN(ordering.ordered_at)                      AS ordered_start,
                               MAX(ordering.ordered_at)                      AS ordered_end,
                               EXTRACT(julian FROM MAX(ordering.ordered_at)) -
                               EXTRACT(julian FROM MIN(ordering.ordered_at)) AS ordered_duration
                        FROM good
                                 JOIN
                             ordering_item ON good.id = ordering_item.good
                                 JOIN
                             ordering ON ordering_item.ordering = ordering.id
                        GROUP BY good.id),
     review_period AS (SELECT good.id                                      AS good_id,
                              MIN(review.reviewed_at)                      AS review_start,
                              MAX(review.reviewed_at)                      AS review_end,
                              EXTRACT(julian FROM MAX(review.reviewed_at)) -
                              EXTRACT(julian FROM MIN(review.reviewed_at)) AS review_duration
                       FROM good
                                JOIN
                            review ON good.id = review.good
                       GROUP BY good.id)
SELECT g.id   AS good_id,
       g.name AS good_id,
       o.ordered_start,
       o.ordered_end,
       o.ordered_duration,
       r.review_start,
       r.review_end,
       r.review_duration
FROM good g
         LEFT JOIN
     ordered_period o ON g.id = o.good_id
         LEFT JOIN
     review_period r ON g.id = r.good_id;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| good\_id | good\_id                          | ordered\_start | ordered\_end | ordered\_duration | review\_start | review\_end | review\_duration |
|:---------|:----------------------------------|:---------------|:-------------|:------------------|:--------------|:------------|:-----------------|
| 1        | Смартфон XYZ Pro                  | 2024-01-02     | 2024-04-22   | 111               | 2024-01-10    | 2024-03-10  | 60               |
| 2        | Ноутбук ABCnote 15                | 2024-01-02     | 2024-04-25   | 114               | 2024-01-15    | 2024-03-15  | 60               |
| 3        | Электрочайник Kettle-100          | 2024-01-02     | 2024-04-25   | 114               | 2024-01-20    | 2024-03-20  | 60               |
| 4        | Умные часы WatchIt Smart          | 2024-01-02     | 2024-04-27   | 116               | 2024-02-05    | 2024-03-25  | 49               |
| 5        | Пылесос CleanFast 01              | 2024-01-11     | 2024-04-27   | 107               | 2024-02-10    | 2024-03-30  | 49               |
| 6        | Беспроводные наушники SoundFree X | 2024-01-08     | 2024-04-27   | 110               | 2024-01-25    | 2024-02-15  | 21               |
| 7        | Кофемашина Coffeemaster 5000      | 2024-01-02     | 2024-04-25   | 114               | 2024-02-20    | 2024-02-28  | 8                |
| 8        | Электросамокат Speedy 3000        | 2024-01-02     | 2024-04-23   | 112               | 2024-02-25    | 2024-03-07  | 11               |
| 9        | Микроволновая печь QuickCook      | 2024-01-02     | 2024-04-27   | 116               | 2024-01-30    | 2024-03-01  | 31               |
| 10       | Фитнес-браслет FitBand Active     | 2024-01-09     | 2024-04-27   | 109               | 2024-02-12    | 2024-03-05  | 22               |

</details>

## Заключение

В ходе данной работы была запущена СУБД PostgreSQL внутри Docker контейнера с использованием оркестратора Docker
Compose. После запуска была проведена миграция с диалекта SQLite на диалект PostgreSQL и рассмотрены различия между
диалектами. Различий между результатами запросов обнаружено не было.
