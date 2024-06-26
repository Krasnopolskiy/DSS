# НИЯУ МИФИ. Лабораторная работа №2. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Наполнение данными](scripts/02-populate-tables.sql)
3. [Выборка данных](scripts/03-select-data.sql)

## Выполненные запросы

### 1. Список категорий

#### Смысл запроса

Получение всех категорий товаров, которые будут использованы пользователем для навигации по магазину.

#### Ожидаемый результат

Список всех категорий товаров.

#### SQL запрос

```sql
SELECT name
FROM category;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                    |
|:------------------------|
| Электроника             |
| Компьютеры              |
| Смартфоны               |
| Бытовая техника         |
| Крупная бытовая техника |
| Мелкая бытовая техника  |
| Одежда                  |
| Мужская одежда          |
| Женская одежда          |
| Детская одежда          |

</details>

### 2. Список товаров с ценой меньше 10000

#### Смысл запроса

Выборка товаров с ценой менее 10000 рублей для предложения покупателям товаров с более низкой стоимостью.

#### Ожидаемый результат

Список товаров с указанием названия, описания и цены, где цена каждого товара меньше 10000 рублей.

#### SQL запрос

```sql
SELECT name, description, price
FROM good
WHERE price < 10000;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | description                                | price   |
|:----------------------------------|:-------------------------------------------|:--------|
| Электрочайник Kettle-100          | Объем 2 литра с функцией быстрого нагрева. | 2490.00 |
| Беспроводные наушники SoundFree X | Автономность до 12 часов.                  | 7000.00 |
| Микроволновая печь QuickCook      | Объем 23 литра.                            | 9000.00 |
| Фитнес-браслет FitBand Active     | Мониторинг пульса, подсчет калорий.        | 3490.00 |

</details>

### 3. Список товаров, отсортированных по убыванию цены

#### Смысл запроса

Получение списка товаров, отсортированных по убыванию их цены, для анализа ценового спектра товаров.

#### Ожидаемый результат

Список всех товаров с указанием названия, цены и количества на складе, отсортированный по убыванию цены.

#### SQL запрос

```sql
SELECT name, price, amount
FROM good
ORDER BY price DESC;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | price    | amount |
|:----------------------------------|:---------|:-------|
| Ноутбук ABCnote 15                | 89000.00 | 50     |
| Смартфон XYZ Pro                  | 49000.00 | 100    |
| Кофемашина Coffeemaster 5000      | 45000.00 | 40     |
| Электросамокат Speedy 3000        | 29000.00 | 60     |
| Пылесос CleanFast 01              | 19000.00 | 30     |
| Умные часы WatchIt Smart          | 12000.00 | 75     |
| Микроволновая печь QuickCook      | 9000.00  | 80     |
| Беспроводные наушники SoundFree X | 7000.00  | 200    |
| Фитнес-браслет FitBand Active     | 3490.00  | 120    |
| Электрочайник Kettle-100          | 2490.00  | 150    |

</details>

### 4. Список товаров, отсортированных по убыванию общей стоимости на складе

#### Смысл запроса

Анализ общей стоимости товаров на складе, отсортированный по убыванию для определения наиболее ценных категорий товаров
в инвентаре.

#### Ожидаемый результат

Список товаров с общей стоимостью на складе для каждого товара, отсортированный по убыванию общей стоимости.

#### SQL запрос

```sql
SELECT name, (price * amount) AS total_price
FROM good
ORDER BY total_price DESC;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| name                              | total\_price |
|:----------------------------------|:-------------|
| Смартфон XYZ Pro                  | 4900000      |
| Ноутбук ABCnote 15                | 4450000      |
| Кофемашина Coffeemaster 5000      | 1800000      |
| Электросамокат Speedy 3000        | 1740000      |
| Беспроводные наушники SoundFree X | 1400000      |
| Умные часы WatchIt Smart          | 900000       |
| Микроволновая печь QuickCook      | 720000       |
| Пылесос CleanFast 01              | 570000       |
| Фитнес-браслет FitBand Active     | 418800       |
| Электрочайник Kettle-100          | 373500       |

</details>

### 5. Время доставки заказов

#### Смысл запроса

Вычисление времени доставки заказов (в днях) для анализа эффективности процесса доставки.

#### Ожидаемый результат

Список заказов с указанием идентификатора заказа, даты заказа, и времени доставки в днях, отсортированный по убыванию
времени доставки.

#### SQL запрос

```sql
SELECT id, ordered_at, JULIANDAY(received_at) - JULIANDAY(ordered_at) AS shipping_time
FROM ordering
WHERE received_at IS NOT NULL
ORDER BY shipping_time DESC;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| id | ordered\_at | shipping\_time |
|:---|:------------|:---------------|
| 4  | 2024-02-05  | 12             |
| 6  | 2024-02-15  | 5              |
| 10 | 2024-03-10  | 4              |
| 8  | 2024-03-01  | 3              |
| 1  | 2024-01-10  | 2              |
| 2  | 2024-01-15  | 1              |

</details>

### 6. Средняя цена товаров по продавцам

#### Смысл запроса

Определение средней цены товаров, предлагаемых каждым продавцом, для анализа ценовой политики.

#### Ожидаемый результат

Список продавцов с количеством предложенных товаров и средней ценой товаров каждого продавца.

#### SQL запрос

```sql
SELECT seller, COUNT(*) AS goods, ROUND(AVG(price), 2) AS average_price
FROM good
GROUP BY seller;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| seller | goods | average\_price |
|:-------|:------|:---------------|
| 1      | 6     | 37248.33       |
| 2      | 4     | 10372.5        |

</details>

### 7. Список продавцов

#### Смысл запроса

Получение списка продавцов для определения участников торговой платформы.

#### Ожидаемый результат

Список уникальных идентификаторов продавцов, представленных в базе данных.

#### SQL запрос

```sql
SELECT DISTINCT seller
FROM good;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| seller |
|:-------|
| 1      |
| 2      |

</details>

### 8. Средний рейтинг товаров

#### Смысл запроса

Вычисление среднего рейтинга для каждого товара на основе отзывов пользователей, чтобы определить наиболее и наименее
популярные товары.

#### Ожидаемый результат

Список товаров с их средним рейтингом, отсортированный от товара с наименьшим средним рейтингом к товару с наивысшим
средним рейтингом.

#### SQL запрос

```sql
SELECT good, AVG(rating) AS average_rating
FROM review
GROUP BY good
ORDER BY average_rating;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| good | average\_rating |
|:-----|:----------------|
| 5    | 1.5             |
| 3    | 2.5             |
| 9    | 2.5             |
| 6    | 3.5             |
| 2    | 4               |
| 8    | 4               |
| 10   | 4               |
| 1    | 5               |
| 4    | 5               |
| 7    | 5               |

</details>

### 9. Статистика продаваемых товаров по продавцы

#### Смысл запроса

Получить для каждого продавца общую стоимость продаваемых товаров, общее количество продаваемых товаров, среднюю
стоимость единицы продаваемого товара.

#### Ожидаемый результат

Список идентификаторов продавцов с суммой стоимости продаваемых товаров, суммой числа продаваемых товаров и средней
стоимостью единицы товара.

#### SQL запрос

```sql
SELECT seller,
       SUM(price * amount)               AS total_price,
       SUM(amount)                       AS goods,
       SUM(amount * price) / SUM(amount) AS average_price
FROM good
GROUP BY seller;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| seller | total\_price | goods | average\_price |
|:-------|:-------------|:------|:---------------|
| 1      | 13983500     | 480   | 29132          |
| 2      | 3288800      | 425   | 7738           |

</details>

## Заключение

В ходе данной работы было проведено наполнение таблиц случайными данными для последующей выборки данных. Для выборки
данных были выполнены 9 различных SQL запросов, имитирующих взаимодействие с базой данных интернет-магазина.
