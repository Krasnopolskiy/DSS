# НИЯУ МИФИ. Лабораторная работа №3. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Наполнение данными](scripts/02-populate-tables.sql)
3. [Выборка данных](scripts/03-select-data.sql)

## Выполненные запросы

### 1. Определение заказов с долгой доставкой

#### Смысл запроса

Выявить заказы, доставленные покупателям с опозданием, чтобы анализировать причины задержек.

#### Ожидаемый результат

Список названий товаров и количество опозданий, доставка которых была осуществлена на пять и более дней позже заказа.

#### SQL запрос

```sql
WITH late_shipping AS (SELECT id FROM ordering WHERE JULIANDAY(received_at) - JULIANDAY(ordered_at) > 5)
SELECT name, COUNT(*) AS late_shippings
FROM ordering_item
         JOIN good ON good.id = good
WHERE ordering IN late_shipping
GROUP BY good
ORDER BY late_shippings DESC;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | late\_shippings |
|:----------------------------------|:----------------|
| Кофемашина Coffeemaster 5000      | 11              |
| Фитнес-браслет FitBand Active     | 10              |
| Электрочайник Kettle-100          | 10              |
| Смартфон XYZ Pro                  | 8               |
| Беспроводные наушники SoundFree X | 6               |
| Ноутбук ABCnote 15                | 6               |
| Электросамокат Speedy 3000        | 5               |
| Умные часы WatchIt Smart          | 5               |
| Микроволновая печь QuickCook      | 4               |
| Пылесос CleanFast 01              | 4               |

</details>

### 2. Построение иерархии категорий

#### Смысл запроса

Cтруктурированное представление всех категорий товаров, включая информацию о взаимосвязях между родительскими и
дочерними категориями, для управления ассортиментом.

#### Ожидаемый результат

Иерархический список категорий товаров с указанием названия каждой категории, её уровня в иерархии и названия
родительской категории, упорядоченный по уровню и названию категории.

#### SQL запрос

```sql
WITH RECURSIVE hierarchy AS (SELECT c.id,
                                    c.name,
                                    c.parent,
                                    pc.name AS parent_name,
                                    1       AS level
                             FROM category c
                                      LEFT JOIN category pc ON c.parent = pc.id
                             WHERE c.parent IS NULL

                             UNION ALL

                             SELECT c.id,
                                    c.name,
                                    c.parent,
                                    pc.name     AS parent_name,
                                    h.level + 1 AS level
                             FROM category c
                                      JOIN hierarchy h ON c.parent = h.id
                                      LEFT JOIN category pc ON c.parent = pc.id)
SELECT name,
       parent_name,
       level
FROM hierarchy
ORDER BY level, name;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                    | parent\_name    | level |
|:------------------------|:----------------|:------|
| Бытовая техника         | null            | 1     |
| Одежда                  | null            | 1     |
| Электроника             | null            | 1     |
| Детская одежда          | Одежда          | 2     |
| Женская одежда          | Одежда          | 2     |
| Компьютеры              | Электроника     | 2     |
| Крупная бытовая техника | Бытовая техника | 2     |
| Мелкая бытовая техника  | Бытовая техника | 2     |
| Мужская одежда          | Одежда          | 2     |
| Смартфоны               | Электроника     | 2     |
| Android Смартфоны       | Смартфоны       | 3     |
| iOS Смартфоны           | Смартфоны       | 3     |
| Костюмы                 | Мужская одежда  | 3     |
| Настольные компьютеры   | Компьютеры      | 3     |
| Ноутбуки                | Компьютеры      | 3     |
| Платья                  | Женская одежда  | 3     |
| Пиджаки                 | Костюмы         | 4     |

</details>

### 3. Список пользователей, не являющихся продавцами

#### Смысл запроса

Выделить пользователей платформы, которые не участвуют в продаже товаров для направления им специальных предложений.

#### Ожидаемый результат

Список пользователей, которые не разместили ни одного товара на продажу, исключая из общего списка пользователей тех,
кто уже является продавцами.

#### SQL запрос

```sql
SELECT id, name
FROM user
EXCEPT
SELECT seller.id, seller.name
FROM good
         JOIN user seller ON seller.id = seller;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| id | name                |
|:---|:--------------------|
| 3  | Николай Васильев    |
| 4  | Екатерина Михайлова |
| 5  | Максим Андреев      |
| 6  | Светлана Петрова    |
| 7  | Андрей Николаев     |
| 8  | Юлия Викторовна     |
| 9  | Дмитрий Егоров      |
| 10 | Ольга Кузнецова     |

</details>

### 4. Получение товаров определенной категории

#### Смысл запроса

Получение ассортимента товаров в рамках определенной категории.

#### Ожидаемый результат

Список всех товаров в категории "Электроника", включая их названия и цены.

#### SQL запрос

```sql
SELECT g.name, g.price
FROM good g
         JOIN good_category gc ON g.id = gc.good
         JOIN category c ON gc.category = c.id
WHERE c.name = 'Электроника';
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | price    |
|:----------------------------------|:---------|
| Умные часы WatchIt Smart          | 12000.00 |
| Беспроводные наушники SoundFree X | 7000.00  |
| Электросамокат Speedy 3000        | 29000.00 |
| Фитнес-браслет FitBand Active     | 3490.00  |

</details>

### 5. Расчёт общей стоимости корзины пользователя

#### Смысл запроса

Подсчёт общей стоимости товаров, добавленных каждым пользователем в корзину.

#### Ожидаемый результат

Список пользователей с суммарной стоимостью товаров, добавленных в их корзины, упорядоченный по убыванию общей
стоимости.

#### SQL запрос

```sql
SELECT u.name, SUM(g.price) AS total_price
FROM user u
         LEFT JOIN cart_item ca ON ca.buyer = u.id
         LEFT JOIN good g ON ca.good = g.id
GROUP BY u.id
ORDER BY total_price;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                | total\_price |
|:--------------------|:-------------|
| Артемий Леонидов    | null         |
| Валентина Сергеева  | null         |
| Светлана Петрова    | 32490        |
| Ольга Кузнецова     | 44490        |
| Андрей Николаев     | 58490        |
| Юлия Викторовна     | 71000        |
| Максим Андреев      | 79490        |
| Николай Васильев    | 94490        |
| Дмитрий Егоров      | 153000       |
| Екатерина Михайлова | 170490       |

</details>

### 6. Средний рейтинг товаров

#### Смысл запроса

Выявление наиболее популярных и качественных товаров.

#### Ожидаемый результат

Список товаров с их средним рейтингом, упорядоченный от наивысшего к наименьшему среднему рейтингу.

#### SQL запрос

```sql
SELECT g.name, AVG(r.rating) AS average
FROM good g
         LEFT JOIN review r ON r.good = g.id
GROUP BY g.id
ORDER BY average DESC;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | average |
|:----------------------------------|:--------|
| Смартфон XYZ Pro                  | 5       |
| Умные часы WatchIt Smart          | 5       |
| Кофемашина Coffeemaster 5000      | 5       |
| Ноутбук ABCnote 15                | 4       |
| Электросамокат Speedy 3000        | 4       |
| Фитнес-браслет FitBand Active     | 4       |
| Беспроводные наушники SoundFree X | 3.5     |
| Электрочайник Kettle-100          | 2.5     |
| Микроволновая печь QuickCook      | 2.5     |
| Пылесос CleanFast 01              | 1.5     |

</details>

### 7. Изменение стоимости конкретного товара

#### Смысл запроса

Получение данных о динамике изменения цен на конкретный товар по времени.

#### Ожидаемый результат

Список заказов с указанием цены товара, даты заказа и изменения цены по сравнению с предыдущим заказом, упорядоченный по
времени заказа.

#### SQL запрос

```sql
SELECT o.ordered_at, oi.price, oi.good, (oi.price - LAG(oi.price, 1, NULL) OVER (ORDER BY o.ordered_at)) AS delta
FROM ordering_item oi
         JOIN ordering o ON o.id = oi.ordering
WHERE oi.good = 3
ORDER BY o.ordered_at;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| ordered\_at | price   | good | delta               |
|:------------|:--------|:-----|:--------------------|
| 2024-01-02  | 2638.79 | 3    | null                |
| 2024-01-02  | 2976.29 | 3    | 337.5               |
| 2024-01-08  | 2513.03 | 3    | -463.25999999999976 |
| 2024-01-09  | 2404.87 | 3    | -108.16000000000031 |
| 2024-01-15  | 2539.25 | 3    | 134.3800000000001   |
| 2024-01-21  | 2750.69 | 3    | 211.44000000000005  |
| 2024-01-22  | 2952.75 | 3    | 202.05999999999995  |
| 2024-01-26  | 2410.05 | 3    | -542.6999999999998  |
| 2024-01-27  | 2314.77 | 3    | -95.2800000000002   |
| 2024-02-05  | 2431.1  | 3    | 116.32999999999993  |
| 2024-02-06  | 2770.78 | 3    | 339.6800000000003   |
| 2024-02-06  | 2900.47 | 3    | 129.6899999999996   |
| 2024-02-08  | 2422.61 | 3    | -477.8599999999997  |
| 2024-02-09  | 2575.06 | 3    | 152.44999999999982  |
| 2024-02-09  | 2480.74 | 3    | -94.32000000000016  |
| 2024-02-09  | 2575.75 | 3    | 95.01000000000022   |
| 2024-02-09  | 2424.07 | 3    | -151.67999999999984 |
| 2024-02-14  | 2794.59 | 3    | 370.52              |
| 2024-02-26  | 2627.71 | 3    | -166.8800000000001  |
| 2024-03-06  | 2778.14 | 3    | 150.42999999999984  |
| 2024-03-07  | 2760.93 | 3    | -17.210000000000036 |
| 2024-03-12  | 2743.36 | 3    | -17.56999999999971  |
| 2024-03-17  | 2935.09 | 3    | 191.73000000000002  |
| 2024-03-17  | 2882.15 | 3    | -52.940000000000055 |
| 2024-03-24  | 2559.93 | 3    | -322.22000000000025 |
| 2024-03-26  | 2524.42 | 3    | -35.50999999999976  |
| 2024-04-02  | 2393.28 | 3    | -131.13999999999987 |
| 2024-04-04  | 2752    | 3    | 358.7199999999998   |
| 2024-04-09  | 2551.8  | 3    | -200.19999999999982 |
| 2024-04-09  | 2902.33 | 3    | 350.52999999999975  |
| 2024-04-10  | 2536.07 | 3    | -366.25999999999976 |
| 2024-04-10  | 2642.74 | 3    | 106.66999999999962  |
| 2024-04-13  | 2467.62 | 3    | -175.1199999999999  |
| 2024-04-13  | 2499.17 | 3    | 31.550000000000182  |
| 2024-04-22  | 2547.08 | 3    | 47.909999999999854  |
| 2024-04-25  | 2971.25 | 3    | 424.1700000000001   |
| 2024-04-25  | 2253.64 | 3    | -717.6100000000001  |

</details>

### 8. Поиск товаров, которые одновременно популярны и доступны

#### Смысл запроса

Идентифицировать товары, которые одновременно входят в топ-5 по среднему рейтингу и топ-5 по доступности (самые
дешевые).

#### Ожидаемый результат

Список товаров, которые являются одновременно высоко оцененными и доступными по цене.

#### SQL запрос

```sql
WITH most_popular AS (SELECT g.name, AVG(r.rating) AS average_rating, g.price
                      FROM good g
                               LEFT JOIN review r ON r.good = g.id
                      GROUP BY g.id, g.name, g.price
                      ORDER BY AVG(r.rating) DESC
                      LIMIT 5),
     cheapest AS (SELECT name, price
                  FROM good
                  ORDER BY price
                  LIMIT 5)
SELECT name, price
FROM most_popular
INTERSECT
SELECT name, price
FROM cheapest;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                     | price    |
|:-------------------------|:---------|
| Умные часы WatchIt Smart | 12000.00 |

</details>

### 9. Товары с наибольшими продажами и наибольшей выручкой по месяцам

#### Смысл запроса

Идентифицировать товары, количество единиц которых продавались чаще и товары, принесшие большую выручку всего по
месяцам.

#### Ожидаемый результат

Список по месяцам с названием наиболее продаваемого товара, количеством продаж, названием товара с наибольшей выручкой и
размер выручки.

#### SQL запрос

```sql
WITH month_sales AS (SELECT STRFTIME('%m', o.ordered_at)                                                                          AS month,
                            SUM(oi.amount)                                                                                        AS sales,
                            SUM(oi.amount * oi.price)                                                                             AS revenue,
                            oi.good                                                                                               AS good_id,
                            g.name                                                                                                AS good_name,
                            ROW_NUMBER() OVER (PARTITION BY STRFTIME('%m', o.ordered_at) ORDER BY SUM(oi.amount) DESC)            AS sales_rank,
                            ROW_NUMBER() OVER (PARTITION BY STRFTIME('%m', o.ordered_at) ORDER BY SUM(oi.amount * oi.price) DESC) AS revenue_rank
                     FROM ordering_item oi
                              JOIN ordering o ON o.id = oi.ordering
                              JOIN good g ON g.id = oi.good
                     GROUP BY STRFTIME('%m', o.ordered_at), oi.good)
SELECT best_sales.month       AS month,
       best_sales.good_name   AS best_sales,
       best_sales.sales       AS sales,
       best_revenue.good_name AS best_revenue,
       best_revenue.revenue   AS revenue
FROM month_sales best_sales
         JOIN month_sales best_revenue ON best_sales.month = best_revenue.month AND best_revenue.revenue_rank = 1
WHERE best_sales.sales_rank = 1;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| month | best\_sales                   | sales | best\_revenue                | revenue   |
|:------|:------------------------------|:------|:-----------------------------|:----------|
| 01    | Умные часы WatchIt Smart      | 20    | Ноутбук ABCnote 15           | 849291.95 |
| 02    | Электрочайник Kettle-100      | 23    | Смартфон XYZ Pro             | 753448.94 |
| 03    | Электросамокат Speedy 3000    | 23    | Ноутбук ABCnote 15           | 829099.89 |
| 04    | Фитнес-браслет FitBand Active | 28    | Кофемашина Coffeemaster 5000 | 825119.23 |

</details>

## Заключение

В ходе данной работы было проведено наполнение таблиц случайными данными для последующей выборки данных. Для выборки
данных были выполнены 9 различных SQL запросов, имитирующих взаимодействие с базой данных интернет-магазина.
