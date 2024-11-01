# НИЯУ МИФИ. Лабораторная работа №6. Краснопольский Иван, Б21-525. 2024

## SQL сценарии

1. [Создание таблиц](scripts/01-create-tables.sql)
2. [Создание схем](scripts/02-create-schemas.sql)
3. [Создание ролей](scripts/03-create-roles.sql)
4. [Проверка ролей](scripts/04-verify-roles.sql)
5. [Создание пользователей](scripts/05-create-users.sql)

## Схема таблиц в базе данных

В текущей базе данных все таблицы создаются без явного указания схемы. Если схема не указана явно, таблицы создаются в
схеме по умолчанию — `public`.

### Добавление схем

Добавление схем целесообразно для организации таблиц по логическим группам. Помимо логического разделения, это упростит
управление доступом:

- Схема `user`: `user`.
- Схема `catalog`: `good`, `category`, `good_category`.
- Схема `sales`: `cart_item`, `ordering`, `ordering_item`, `review`

### Обновление структуры базы данных

#### Создание схем

```sql
CREATE SCHEMA "user";
CREATE SCHEMA catalog;
CREATE SCHEMA sales;
```

#### Перенос таблиц

```sql
ALTER TABLE "user"
    SET SCHEMA "user";

ALTER TABLE good
    SET SCHEMA catalog;
ALTER TABLE category
    SET SCHEMA catalog;
ALTER TABLE good_category
    SET SCHEMA catalog;

ALTER TABLE cart_item
    SET SCHEMA sales;
ALTER TABLE ordering
    SET SCHEMA sales;
ALTER TABLE ordering_item
    SET SCHEMA sales;
ALTER TABLE review
    SET SCHEMA sales;
```

#### Обновление пути поиска

Чтобы по умолчанию обращаться к новым схемам без явного указания их имени, нужно обновить путь поиска:

```sql
SET search_path TO "user", catalog, sales, public;
```

## Роли баз данных

Для нормального функционирование определены такие роли:

### Аналитик (analyst)

**Цель роли**: Только чтение данных из схем catalog и sales.

**Системные привилегии**: `CONNECT`.

**Объектные привилегии**:

- `USAGE` на схемах `catalog` и `sales`
- `SELECT` на всех таблицах в схемах `catalog` и `sales`

### Менеджер сайта (`manager`)

**Цель роли**: Чтение и запись в схеме `catalog`, только чтение в схеме `sales`.

**Системные привилегии**: `CONNECT`.

**Объектные привилегии**:

- `USAGE` на схемах `catalog` и `sales`
- `SELECT`, `INSERT`, `UPDATE`, `DELETE` на всех таблицах в схеме `catalog`
- `SELECT` на всех таблицах в схеме `sales`

### Администратор (`administrator`)

**Цель роли**: Полный доступ (чтение и запись) ко всем схемам.

**Системные привилегии**: `CONNECT`.

**Объектные привилегии**:

- `USAGE` на всех схемах - `user`, `catalog`, `sales`
- `SELECT`, `INSERT`, `UPDATE`, `DELETE` на всех таблицах во всех схемах - `user`, `catalog`, `sales`

### Вложенные роли

Каждая из этих ролей включает в себя вложенные роли: `user_read`, `user_write`, `catalog_read`, `catalog_write`,
`sales_read`, `sales_write`:

- `read` разрешает объектные привилегии `SELECT`
- `write` разрешает объектные привилегии `INSERT`, `UPDATE`, `DELETE`

### Добавление ролей

#### Создание базовых ролей

```sql
CREATE ROLE user_read;
GRANT USAGE ON SCHEMA "user" TO user_read;
GRANT SELECT ON ALL TABLES IN SCHEMA "user" TO user_read;

CREATE ROLE user_write;
GRANT USAGE ON SCHEMA "user" TO user_write;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "user" TO user_write;

CREATE ROLE catalog_read;
GRANT USAGE ON SCHEMA catalog TO catalog_read;
GRANT SELECT ON ALL TABLES IN SCHEMA catalog TO catalog_read;

CREATE ROLE catalog_write;
GRANT USAGE ON SCHEMA catalog TO catalog_write;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA catalog TO catalog_write;

CREATE ROLE sales_read;
GRANT USAGE ON SCHEMA sales TO sales_read;
GRANT SELECT ON ALL TABLES IN SCHEMA sales TO sales_read;

CREATE ROLE sales_write;
GRANT USAGE ON SCHEMA sales TO sales_write;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sales TO sales_write;
```

#### Создание высокоуровневых ролей

```sql
CREATE ROLE analyst;
GRANT catalog_read TO analyst;
GRANT sales_read TO analyst;
GRANT CONNECT ON DATABASE lab6 TO analyst;
GRANT USAGE ON SCHEMA catalog TO analyst;
GRANT USAGE ON SCHEMA sales TO analyst;

CREATE ROLE manager;
GRANT catalog_read TO manager;
GRANT catalog_write TO manager;
GRANT sales_read TO manager;
GRANT CONNECT ON DATABASE lab6 TO manager;
GRANT USAGE ON SCHEMA catalog TO manager;
GRANT USAGE ON SCHEMA sales TO manager;

CREATE ROLE administrator;
GRANT user_read TO administrator;
GRANT user_write TO administrator;
GRANT catalog_read TO administrator;
GRANT catalog_write TO administrator;
GRANT sales_read TO administrator;
GRANT sales_write TO administrator;
GRANT CONNECT ON DATABASE lab6 TO administrator;
GRANT USAGE ON SCHEMA "user" TO administrator;
GRANT USAGE ON SCHEMA catalog TO administrator;
GRANT USAGE ON SCHEMA sales TO administrator;
```

#### Настройка привилегий по умолчанию для будущих таблиц

```sql
ALTER DEFAULT PRIVILEGES IN SCHEMA catalog GRANT SELECT ON TABLES TO analyst;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT ON TABLES TO analyst;

ALTER DEFAULT PRIVILEGES IN SCHEMA catalog GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT ON TABLES TO manager;

ALTER DEFAULT PRIVILEGES IN SCHEMA "user" GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO administrator;
ALTER DEFAULT PRIVILEGES IN SCHEMA catalog GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO administrator;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO administrator;
```

### Проверка ролей

### Проверка существования

#### SQL запрос

```sql
SELECT rolname
FROM pg_roles
WHERE rolname IN ('analyst', 'manager', 'administrator');
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| rolname       |
|:--------------|
| analyst       |
| manager       |
| administrator |

</details>

### Проверка атрибутов

#### SQL запрос

```sql
SELECT rolname,
       rolsuper,
       rolcreaterole,
       rolcreatedb,
       rolcanlogin
FROM pg_roles
WHERE rolname IN ('analyst', 'manager', 'administrator');
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| rolname       | rolsuper | rolcreaterole | rolcreatedb | rolcanlogin |
|:--------------|:---------|:--------------|:------------|:------------|
| analyst       | false    | false         | false       | false       |
| manager       | false    | false         | false       | false       |
| administrator | false    | false         | false       | false       |

</details>

### Проверка привилегий CONNECT

#### SQL запрос

```sql
SELECT datname,
       has_database_privilege('analyst', datname, 'CONNECT')       AS analyst_connect,
       has_database_privilege('manager', datname, 'CONNECT')       AS manager_connect,
       has_database_privilege('administrator', datname, 'CONNECT') AS administrator_connect
FROM pg_database
WHERE datname = 'lab6';
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| datname | analyst\_connect | manager\_connect | administrator\_connect |
|:--------|:-----------------|:-----------------|:-----------------------|
| lab6    | true             | true             | true                   |

</details>

### Проверка привилегий USAGE

#### SQL запрос

```sql
SELECT nspname,
       has_schema_privilege('analyst', nspname, 'USAGE')       AS analyst,
       has_schema_privilege('manager', nspname, 'USAGE')       AS manager,
       has_schema_privilege('administrator', nspname, 'USAGE') AS administrator
FROM pg_namespace
WHERE nspname IN ('user', 'catalog', 'sales');
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| nspname | analyst | manager | administrator |
|:--------|:--------|:--------|:--------------|
| user    | false   | false   | true          |
| catalog | true    | true    | true          |
| sales   | true    | true    | true          |

</details>

### Проверка привилегий на таблицах

#### SQL запрос

```sql
SELECT r.rolname   AS role_name,
       n.nspname   AS schema_name,
       c.relname   AS table_name,
       p.privilege AS privilege_type
FROM pg_roles r
         CROSS JOIN
     pg_namespace n
         JOIN
     pg_class c ON c.relnamespace = n.oid AND c.relkind = 'r' -- только таблицы
         CROSS JOIN
         (VALUES ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE')) AS p(privilege)
WHERE r.rolname IN ('analyst', 'manager', 'administrator')
  AND n.nspname IN ('catalog', 'sales', 'user')
  AND HAS_TABLE_PRIVILEGE(r.rolname, c.oid, p.privilege)
ORDER BY r.rolname, n.nspname, c.relname, p.privilege;
```

#### Полученный результат

<details>
    <summary>Таблица</summary>

| role\_name    | schema\_name | table\_name    | privilege\_type |
|:--------------|:-------------|:---------------|:----------------|
| administrator | catalog      | category       | DELETE          |
| administrator | catalog      | category       | INSERT          |
| administrator | catalog      | category       | SELECT          |
| administrator | catalog      | category       | UPDATE          |
| administrator | catalog      | good           | DELETE          |
| administrator | catalog      | good           | INSERT          |
| administrator | catalog      | good           | SELECT          |
| administrator | catalog      | good           | UPDATE          |
| administrator | catalog      | good\_category | DELETE          |
| administrator | catalog      | good\_category | INSERT          |
| administrator | catalog      | good\_category | SELECT          |
| administrator | catalog      | good\_category | UPDATE          |
| administrator | sales        | cart\_item     | DELETE          |
| administrator | sales        | cart\_item     | INSERT          |
| administrator | sales        | cart\_item     | SELECT          |
| administrator | sales        | cart\_item     | UPDATE          |
| administrator | sales        | ordering       | DELETE          |
| administrator | sales        | ordering       | INSERT          |
| administrator | sales        | ordering       | SELECT          |
| administrator | sales        | ordering       | UPDATE          |
| administrator | sales        | ordering\_item | DELETE          |
| administrator | sales        | ordering\_item | INSERT          |
| administrator | sales        | ordering\_item | SELECT          |
| administrator | sales        | ordering\_item | UPDATE          |
| administrator | sales        | review         | DELETE          |
| administrator | sales        | review         | INSERT          |
| administrator | sales        | review         | SELECT          |
| administrator | sales        | review         | UPDATE          |
| administrator | user         | user           | DELETE          |
| administrator | user         | user           | INSERT          |
| administrator | user         | user           | SELECT          |
| administrator | user         | user           | UPDATE          |
| analyst       | catalog      | category       | SELECT          |
| analyst       | catalog      | good           | SELECT          |
| analyst       | catalog      | good\_category | SELECT          |
| analyst       | sales        | cart\_item     | SELECT          |
| analyst       | sales        | ordering       | SELECT          |
| analyst       | sales        | ordering\_item | SELECT          |
| analyst       | sales        | review         | SELECT          |
| manager       | catalog      | category       | DELETE          |
| manager       | catalog      | category       | INSERT          |
| manager       | catalog      | category       | SELECT          |
| manager       | catalog      | category       | UPDATE          |
| manager       | catalog      | good           | DELETE          |
| manager       | catalog      | good           | INSERT          |
| manager       | catalog      | good           | SELECT          |
| manager       | catalog      | good           | UPDATE          |
| manager       | catalog      | good\_category | DELETE          |
| manager       | catalog      | good\_category | INSERT          |
| manager       | catalog      | good\_category | SELECT          |
| manager       | catalog      | good\_category | UPDATE          |
| manager       | sales        | cart\_item     | SELECT          |
| manager       | sales        | ordering       | SELECT          |
| manager       | sales        | ordering\_item | SELECT          |
| manager       | sales        | review         | SELECT          |

</details>

## Создание тестовых пользователей

```sql
CREATE USER ann WITH PASSWORD 'password';
GRANT analyst TO ann;

CREATE USER mike WITH PASSWORD 'password';
GRANT manager TO mike;

CREATE USER andrew WITH PASSWORD 'password';
GRANT administrator TO andrew;
```

## Заключение

В ходе данной работы была проведена декомпозиция схемы public на три схемы, соответствующие логическим сегментам
предметной области. Затем, для полученной структуры были разработаны и реализованы роли, ограничивающие возможности
пользователей базы данных. Для проверки ролей были созданы тестовые пользователи, от которых было произведено
подключение к базе данных и выполнение запросов, требующих разный набор привилегий. 
