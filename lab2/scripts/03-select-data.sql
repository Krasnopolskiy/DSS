SELECT name
FROM category;

SELECT name, description, price
FROM good
WHERE price < 10000;

SELECT name, price, amount
FROM good
ORDER BY price DESC;

SELECT name, (price * amount) AS total_price
FROM good
ORDER BY total_price DESC;

SELECT id, ordered_at, JULIANDAY(received_at) - JULIANDAY(ordered_at) AS shipping_time
FROM ordering
WHERE received_at IS NOT NULL
ORDER BY shipping_time DESC;

SELECT seller, COUNT(*) AS goods, ROUND(AVG(price), 2) AS average_price
FROM good
GROUP BY seller;

SELECT DISTINCT seller
FROM good;

SELECT good, AVG(rating) AS average_rating
FROM review
GROUP BY good
ORDER BY average_rating;

SELECT seller,
       SUM(price * amount)               AS total_price,
       SUM(amount)                       AS goods,
       SUM(amount * price) / SUM(amount) AS average_price
FROM good
GROUP BY seller;
