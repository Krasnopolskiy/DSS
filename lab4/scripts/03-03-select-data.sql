WITH late_shipping AS (SELECT id
                       FROM ordering
                       WHERE EXTRACT(julian FROM received_at) - EXTRACT(julian FROM ordered_at) > 5)
SELECT good.name, COUNT(*) AS late_shippings
FROM ordering_item oi
         JOIN good ON oi.good = good.id
WHERE oi.ordering IN (SELECT id FROM late_shipping)
GROUP BY good.name
ORDER BY late_shippings DESC;

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

SELECT id, name
FROM "user"
EXCEPT
SELECT seller.id, seller.name
FROM good
         JOIN "user" seller ON seller.id = seller;

SELECT g.name, g.price
FROM good g
         JOIN good_category gc ON g.id = gc.good
         JOIN category c ON gc.category = c.id
WHERE c.name = 'Электроника';

SELECT u.name, SUM(g.price) AS total_price
FROM "user" u
         LEFT JOIN cart_item ca ON ca.buyer = u.id
         LEFT JOIN good g ON ca.good = g.id
GROUP BY u.id
ORDER BY total_price;

SELECT g.name, AVG(r.rating) AS average
FROM good g
         LEFT JOIN review r ON r.good = g.id
GROUP BY g.id
ORDER BY average DESC;

SELECT o.ordered_at, oi.price, oi.good, (oi.price - LAG(oi.price, 1, NULL) OVER (ORDER BY o.ordered_at)) AS delta
FROM ordering_item oi
         JOIN ordering o ON o.id = oi.ordering
WHERE oi.good = 3
ORDER BY o.ordered_at;

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

WITH month_sales AS (SELECT EXTRACT(MONTH FROM o.ordered_at)                                                             AS month,
                            SUM(oi.amount)                                                                               AS sales,
                            SUM(oi.amount * oi.price)                                                                    AS revenue,
                            oi.good                                                                                      AS good_id,
                            g.name                                                                                       AS good_name,
                            ROW_NUMBER()
                            OVER (PARTITION BY EXTRACT(MONTH FROM o.ordered_at) ORDER BY SUM(oi.amount) DESC)            AS sales_rank,
                            ROW_NUMBER()
                            OVER (PARTITION BY EXTRACT(MONTH FROM o.ordered_at) ORDER BY SUM(oi.amount * oi.price) DESC) AS revenue_rank
                     FROM ordering_item oi
                              JOIN ordering o ON o.id = oi.ordering
                              JOIN good g ON g.id = oi.good
                     GROUP BY EXTRACT(MONTH FROM o.ordered_at), oi.good, g.name)
SELECT best_sales.month       AS month,
       best_sales.good_name   AS best_sales,
       best_sales.sales       AS sales,
       best_revenue.good_name AS best_revenue,
       best_revenue.revenue   AS revenue
FROM month_sales best_sales
         JOIN month_sales best_revenue ON best_sales.month = best_revenue.month AND best_revenue.revenue_rank = 1
WHERE best_sales.sales_rank = 1;
