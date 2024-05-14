# НИЯУ МИФИ. Лабораторная работа №5. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Наполнение данными](scripts/02-populate-tables.sql)
3. [Выборка данных](scripts/03-select-data.sql)

## Использование специфичных типов данных

### Композитные структуры

#### Описание

```sql
CREATE TYPE ADDRESS AS
(
    street VARCHAR(255),
    city   VARCHAR(255),
    state  VARCHAR(255),
    zip    VARCHAR(10)
);
```

```sql
CREATE TABLE "user"
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(255)        NOT NULL,
    email   VARCHAR(255) UNIQUE NOT NULL,
    address ADDRESS
);
```

#### Наполнение

```sql
INSERT INTO "user" (name, email, address)
VALUES ('Артемий Леонидов', 'artem.leonidov@example.com',
        row('ул. Ленина, 10, кв. 15', 'Владивосток', 'Россия', '690091')::ADDRESS),
       ('Валентина Сергеева', 'valentina.sergeeva@example.com',
        row('пр-т Мира, 28, офис 4', 'Красноярск', 'Россия', '660049')::ADDRESS),
       ('Николай Васильев', 'nikolai.vasiliev@example.com',
        row('бул. Космонавтов, 12', 'Москва', 'Россия', '443086')::ADDRESS),
       ('Екатерина Михайлова', 'ekaterina.mikhailova@example.com',
        row('пер. Строителей, 8', 'Тюмень', 'Россия', '625000')::ADDRESS),
       ('Максим Андреев', 'maxim.andreev@example.com',
        row('ул. Советская, 57', 'Иркутск', 'Россия', '664003')::ADDRESS),
       ('Светлана Петрова', 'svetlana.petrova@example.com',
        row('ш. Энтузиастов, 31', 'Волгоград', 'Россия', '400074')::ADDRESS),
       ('Андрей Николаев', 'andrey.nikolaev@example.com',
        row('пр-д Верный, 14', 'Калининград', 'Россия', '236022')::ADDRESS),
       ('Юлия Викторовна', 'yulia.viktorovna@example.com',
        row('ул. Молодёжная, 5', 'Саратов', 'Россия', '410012')::ADDRESS),
       ('Дмитрий Егоров', 'dmitry.egorov@example.com',
        row('наб. Реки Фонтанки, 50', 'Санкт-Петербург', 'Россия', '191023')::ADDRESS),
       ('Ольга Кузнецова', 'olga.kuznetsova@example.com',
        row('ул. Чернышевского, 17', 'Ярославль', 'Россия', '150003')::ADDRESS);
```

#### SQL запрос

```sql
SELECT name, address
FROM "user"
WHERE (address).city = 'Москва'
   OR (address).city = 'Санкт-Петербург';
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name             | address                                                  |
|:-----------------|:---------------------------------------------------------|
| Николай Васильев | ("бул. Космонавтов, 12",Москва,Россия,443086)            |
| Дмитрий Егоров   | ("наб. Реки Фонтанки, 50",Санкт-Петербург,Россия,191023) |

</details>

### Large Object

#### Описание

```sql
CREATE TABLE good_image
(
    good  INTEGER NOT NULL,
    image BYTEA   NOT NULL,
    FOREIGN KEY (good) REFERENCES good (id) ON DELETE CASCADE
);
```

#### Наполнение

> Файлы изображений передаются в контейнер через монтирование тома в точку монтирования `/assets`

```sql
INSERT INTO good_image (good, image)
VALUES (1, pg_read_binary_file('/assets/phone.jpg')),
       (2, pg_read_binary_file('/assets/notebook.jpg')),
       (3, pg_read_binary_file('/assets/kettle.jpg')),
       (4, pg_read_binary_file('/assets/watch.jpg')),
       (5, pg_read_binary_file('/assets/vacuum.jpg')),
       (6, pg_read_binary_file('/assets/headphones.jpg')),
       (7, pg_read_binary_file('/assets/coffemachine.jpg')),
       (8, pg_read_binary_file('/assets/kickscooter.jpg')),
       (9, pg_read_binary_file('/assets/microwave.jpg')),
       (10, pg_read_binary_file('/assets/fitband.jpg'));
```

#### SQL запрос

```sql
SELECT g.name, gi.image
FROM good g
         JOIN good_image gi ON g.id = gi.good;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | image                                 |
|:----------------------------------|:--------------------------------------|
| Смартфон XYZ Pro                  | 0xFFD8FFE000104A46...7D4DFD44A4A4FFD9 |
| Ноутбук ABCnote 15                | 0xFFD8FFE000104A46...628B88E23FC7FFD9 |
| Электрочайник Kettle-100          | 0xFFD8FFE000104A46...5FB2FD97EF8BFFD9 |
| Умные часы WatchIt Smart          | 0xFFD8FFE000104A46...29FF003FFC11FFD9 |
| Пылесос CleanFast 01              | 0xFFD8FFE000104A46...CAEE82506E7FFFD9 |
| Беспроводные наушники SoundFree X | 0xFFD8FFE000104A46...F8E3F65FF1DFFFD9 |
| Кофемашина Coffeemaster 5000      | 0xFFD8FFE000104A46...A869EE3B3F83FFD9 |
| Электросамокат Speedy 3000        | 0xFFD8FFE000104A46...D57D7D1CEFAFFFD9 |
| Микроволновая печь QuickCook      | 0xFFD8FFE000104A46...8CFF00C25F8FFFD9 |
| Фитнес-браслет FitBand Active     | 0xFFD8FFE000104A46...DA3379D7364FFFD9 |

</details>

### Массивы переменной длины и JSON-объекты

#### Описание

```sql
CREATE TABLE good
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255)   NOT NULL,
    description VARCHAR(255)   NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    amount      INTEGER        NOT NULL,
    seller      INTEGER        NOT NULL,
    attributes  JSONB,
    tags        TEXT [],
    FOREIGN KEY (seller) REFERENCES "user" (id) ON DELETE RESTRICT
);
```

#### Наполнение

```sql
INSERT INTO good (id, name, description, price, amount, seller, tags, attributes)
VALUES (1, 'Смартфон XYZ Pro', '8 ГБ оперативной памяти, 256 ГБ встроенной памяти.', 49000.00, 100, 1,
        ARRAY ['smartphone', 'electronics', 'gadgets'],
        '{
          "RAM": "8GB",
          "Storage": "256GB",
          "Color": "Black"
        }'::JSONB),
       (2, 'Ноутбук ABCnote 15', 'Диагональ экрана 15.6 дюймов, видеокарта GTX 1660 Ti.', 89000.00, 50, 1,
        ARRAY ['laptop', 'electronics', 'computers'],
        '{
          "Screen Size": "15.6 inches",
          "GPU": "GTX 1660 Ti",
          "RAM": "16GB",
          "Color": "Black"
        }'::JSONB),
       (3, 'Электрочайник Kettle-100', 'Объем 2 литра с функцией быстрого нагрева.', 2490.00, 150, 1,
        ARRAY ['kettle', 'kitchen appliances'],
        '{
          "Capacity": "2L",
          "Feature": "Fast Heating"
        }'::JSONB),
       (4, 'Умные часы WatchIt Smart', 'Шагомер, мониторинг сна и возможность ответа на вызовы.', 12000.00, 75, 2,
        ARRAY ['smartwatch', 'electronics', 'gadgets'],
        '{
          "Features": [
            "Pedometer",
            "Sleep Monitoring",
            "Call Answering"
          ]
        }'::JSONB),
       (5, 'Пылесос CleanFast 01', 'Влажная уборка, программирование по времени.', 19000.00, 30, 2,
        ARRAY ['vacuum cleaner', 'cleaning', 'appliances'],
        '{
          "Features": [
            "Wet Cleaning",
            "Scheduled Cleaning"
          ]
        }'::JSONB),
       (6, 'Беспроводные наушники SoundFree X', 'Автономность до 12 часов.', 7000.00, 200, 2,
        ARRAY ['headphones', 'electronics', 'gadgets'],
        '{
          "Battery Life": "12 hours",
          "Connectivity": "Wireless"
        }'::JSONB),
       (7, 'Кофемашина Coffeemaster 5000', 'Возможность приготовления эспрессо, капучино и латте.', 45000.00, 40, 1,
        ARRAY ['coffee machine', 'kitchen appliances'],
        '{
          "Features": [
            "Espresso",
            "Cappuccino",
            "Latte"
          ],
          "Color": "Black"
        }'::JSONB),
       (8, 'Электросамокат Speedy 3000', 'Максимальная скорость до 25 км/ч, запас хода до 30 км.', 29000.00, 60, 1,
        ARRAY ['electric scooter', 'electronics', 'transport'],
        '{
          "Max Speed": "25 km/h",
          "Range": "30 km"
        }'::JSONB),
       (9, 'Микроволновая печь QuickCook', 'Объем 23 литра.', 9000.00, 80, 1,
        ARRAY ['microwave', 'kitchen appliances'],
        '{
          "Capacity": "23L"
        }'::JSONB),
       (10, 'Фитнес-браслет FitBand Active', 'Мониторинг пульса, подсчет калорий.', 3490.00, 120, 2,
        ARRAY ['fitness tracker', 'electronics', 'gadgets'],
        '{
          "Features": [
            "Heart Rate Monitoring",
            "Calorie Counting"
          ]
        }'::JSONB);
```

#### SQL запросы

```sql
SELECT name, description, tags
FROM good g
WHERE 'gadgets' = ANY(g.tags);

SELECT name, price, attributes
FROM good
WHERE attributes ->> 'Color' = 'Black';
```

#### Полученные результаты

<details>
    <summary>Таблица 1</summary>

| name                              | description                                             | tags                                  |
|:----------------------------------|:--------------------------------------------------------|:--------------------------------------|
| Смартфон XYZ Pro                  | 8 ГБ оперативной памяти, 256 ГБ встроенной памяти.      | {smartphone,electronics,gadgets}      |
| Умные часы WatchIt Smart          | Шагомер, мониторинг сна и возможность ответа на вызовы. | {smartwatch,electronics,gadgets}      |
| Беспроводные наушники SoundFree X | Автономность до 12 часов.                               | {headphones,electronics,gadgets}      |
| Фитнес-браслет FitBand Active     | Мониторинг пульса, подсчет калорий.                     | {fitness tracker,electronics,gadgets} |

</details>

<details>
    <summary>Таблица 2</summary>

| name                         | price    | attributes                                                                            |
|:-----------------------------|:---------|:--------------------------------------------------------------------------------------|
| Смартфон XYZ Pro             | 49000.00 | {"RAM": "8GB", "Color": "Black", "Storage": "256GB"}                                  |
| Ноутбук ABCnote 15           | 89000.00 | {"GPU": "GTX 1660 Ti", "RAM": "16GB", "Color": "Black", "Screen Size": "15.6 inches"} |
| Кофемашина Coffeemaster 5000 | 45000.00 | {"Color": "Black", "Features": \["Espresso", "Cappuccino", "Latte"\]}                 |

</details>

## Заключение

В ходе данной работы были использованы специфичные типы данных: композитные структуры, Large Object, JSONB для хранения
JSON-объектов, и массивы произовльной длины. Для использования этих структур прежние таблицы были модифицированы
соответствующим образом, а также добавлены необходимые новые. Затем, таблицы были наполнены данными, которые в
последствии были получены с помощью соответствующих SQL запросов. 
