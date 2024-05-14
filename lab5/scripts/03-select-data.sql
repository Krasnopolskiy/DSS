SELECT name, address
FROM "user"
WHERE (address).city = 'Москва'
   OR (address).city = 'Санкт-Петербург';

SELECT g.name, gi.image
FROM good g
         JOIN good_image gi ON g.id = gi.good;

SELECT name, description, tags
FROM good g
WHERE 'gadgets' = ANY (g.tags);

SELECT name, price, attributes
FROM good
WHERE attributes ->> 'Color' = 'Black';
