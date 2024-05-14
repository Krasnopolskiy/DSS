# НИЯУ МИФИ. Лабораторная работа №4. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Наполнение данными](scripts/02-populate-tables.sql)
3. [Выборка данных (lab2)](scripts/03-02-select-data.sql)
4. [Выборка данных (lab3)](scripts/03-03-select-data.sql)

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

## Заключение

В ходе данной работы была запущена СУБД PostgreSQL внутри Docker контейнера с использованием оркестратора Docker
Compose. После запуска была проведена миграция с диалекта SQLite на диалект PostgreSQL и рассмотрены различия между
диалектами. Различий между результатами запросов обнаружено не было.
