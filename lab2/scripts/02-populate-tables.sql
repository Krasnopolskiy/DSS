INSERT INTO user (name, email, address)
VALUES ('Артемий Леонидов', 'artem.leonidov@example.com', 'ул. Ленина, 10, кв. 15, Владивосток, Россия, 690091'),
       ('Валентина Сергеева', 'valentina.sergeeva@example.com', 'пр-т Мира, 28, офис 4, Красноярск, Россия, 660049'),
       ('Николай Васильев', 'nikolai.vasiliev@example.com', 'бул. Космонавтов, 12, Самара, Россия, 443086'),
       ('Екатерина Михайлова', 'ekaterina.mikhailova@example.com', 'пер. Строителей, 8, Тюмень, Россия, 625000'),
       ('Максим Андреев', 'maxim.andreev@example.com', 'ул. Советская, 57, Иркутск, Россия, 664003'),
       ('Светлана Петрова', 'svetlana.petrova@example.com', 'ш. Энтузиастов, 31, Волгоград, Россия, 400074'),
       ('Андрей Николаев', 'andrey.nikolaev@example.com', 'пр-д Верный, 14, Калининград, Россия, 236022'),
       ('Юлия Викторовна', 'yulia.viktorovna@example.com', 'ул. Молодёжная, 5, Саратов, Россия, 410012'),
       ('Дмитрий Егоров', 'dmitry.egorov@example.com', 'наб. Реки Фонтанки, 50, Санкт-Петербург, Россия, 191023'),
       ('Ольга Кузнецова', 'olga.kuznetsova@example.com', 'ул. Чернышевского, 17, Ярославль, Россия, 150003');

INSERT INTO category (id, name, parent)
VALUES (1, 'Электроника', NULL),
       (2, 'Компьютеры', 1),
       (3, 'Смартфоны', 1),
       (4, 'Бытовая техника', NULL),
       (5, 'Крупная бытовая техника', 4),
       (6, 'Мелкая бытовая техника', 4),
       (7, 'Одежда', NULL),
       (8, 'Мужская одежда', 7),
       (9, 'Женская одежда', 7),
       (10, 'Детская одежда', 7);

INSERT INTO good (id, name, description, price, amount, seller)
VALUES (1, 'Смартфон XYZ Pro', '8 ГБ оперативной памяти, 256 ГБ встроенной памяти.', 49000.00, 100, 1),
       (2, 'Ноутбук ABCnote 15', 'Диагональ экрана 15.6 дюймов, видеокарта GTX 1660 Ti.', 89000.00, 50, 1),
       (3, 'Электрочайник Kettle-100', 'Объем 2 литра с функцией быстрого нагрева.', 2490.00, 150, 1),
       (4, 'Умные часы WatchIt Smart', 'Шагомер, мониторинг сна и возможность ответа на вызовы.', 12000.00, 75, 2),
       (5, 'Пылесос CleanFast 01', 'Влажная уборка, программирование по времени.', 19000.00, 30, 2),
       (6, 'Беспроводные наушники SoundFree X', 'Автономность до 12 часов.', 7000.00, 200, 2),
       (7, 'Кофемашина Coffeemaster 5000', 'Возможность приготовления эспрессо, капучино и латте.', 45000.00, 40, 1),
       (8, 'Электросамокат Speedy 3000', 'Максимальная скорость до 25 км/ч, запас хода до 30 км.', 29000.00, 60, 1),
       (9, 'Микроволновая печь QuickCook', 'Объем 23 литра.', 9000.00, 80, 1),
       (10, 'Фитнес-браслет FitBand Active', 'Мониторинг пульса, подсчет калорий.', 3490.00, 120, 2);

INSERT INTO good_category (good, category)
VALUES (1, 3),
       (2, 2),
       (3, 6),
       (4, 1),
       (5, 5),
       (6, 1),
       (7, 5),
       (8, 1),
       (9, 5),
       (10, 1);

INSERT INTO cart_item (buyer, good)
VALUES (3, 5),
       (3, 7),
       (4, 2),
       (4, 10),
       (3, 3),
       (3, 9),
       (4, 1),
       (4, 8),
       (5, 6),
       (5, 4),
       (6, 10),
       (7, 3),
       (7, 1),
       (8, 7),
       (8, 6),
       (9, 5),
       (9, 2),
       (10, 4),
       (10, 8),
       (5, 9),
       (5, 1),
       (3, 4),
       (5, 3),
       (6, 8),
       (7, 6),
       (8, 5),
       (9, 7),
       (10, 10),
       (3, 6);

INSERT INTO ordering (id, buyer, ordered_at, received_at, status)
VALUES (1, 6, '2024-01-10', '2024-01-12', 'RECEIVED'),
       (2, 9, '2024-01-15', '2024-01-16', 'SHIPPING'),
       (3, 3, '2024-01-20', NULL, 'PENDING'),
       (4, 4, '2024-02-05', '2024-02-17', 'RECEIVED'),
       (5, 5, '2024-02-10', NULL, 'PENDING'),
       (6, 6, '2024-02-15', '2024-02-20', 'SHIPPING'),
       (7, 7, '2024-02-20', NULL, 'PENDING'),
       (8, 8, '2024-03-01', '2024-03-04', 'RECEIVED'),
       (9, 9, '2024-03-05', NULL, 'PENDING'),
       (10, 10, '2024-03-10', '2024-03-14', 'SHIPPING');

INSERT INTO ordering_item (id, ordering, good, amount, price)
VALUES (1, 1, 10, 1, 3490.00),
       (2, 1, 3, 2, 2490.00),
       (3, 2, 9, 1, 9900.00),
       (4, 3, 8, 1, 29900.00),
       (5, 3, 2, 1, 89900.00),
       (6, 4, 7, 1, 45900.00),
       (7, 4, 5, 1, 19900.00),
       (8, 4, 1, 1, 49900.00),
       (9, 5, 6, 2, 7900.00),
       (10, 6, 4, 1, 12900.00),
       (11, 6, 3, 1, 2490.00),
       (12, 7, 2, 1, 89900.00),
       (13, 7, 1, 2, 49900.00),
       (14, 7, 5, 1, 19900.00),
       (15, 8, 9, 1, 9900.00),
       (16, 9, 8, 1, 29900.00),
       (17, 9, 7, 1, 45900.00),
       (18, 10, 6, 1, 7900.00),
       (19, 10, 4, 1, 12900.00),
       (20, 10, 2, 1, 89900.00);

INSERT INTO review (id, good, buyer, rating, comment, reviewed_at)
VALUES (1, 1, 10, 5, 'Отличный смартфон, быстрый и надежный!', '2024-01-10'),
       (2, 2, 9, 4, 'Хороший ноутбук, но шумит при нагрузке.', '2024-01-15'),
       (3, 3, 8, 3, 'Среднего качества, нагревается вода долго.', '2024-01-20'),
       (4, 4, 7, 5, 'Лучшие умные часы в своем ценовом сегменте!', '2024-02-05'),
       (5, 5, 6, 2, 'Пылесос застревает на коврах, ожидала большего.', '2024-02-10'),
       (6, 6, 5, 4, 'Отличное качество звука, но короткий срок службы батареи.', '2024-02-15'),
       (7, 7, 4, 5, 'Кофе получается великолепный, каждое утро начинается с него!', '2024-02-20'),
       (8, 8, 3, 4, 'Мощный и удобный, но иногда глючит приложение.', '2024-02-25'),
       (9, 9, 2, 3, 'Ждала большего от функции гриля.', '2024-03-01'),
       (10, 10, 1, 4, 'Хороший фитнес-браслет за свои деньги.', '2024-03-05'),
       (11, 1, 5, 5, 'Супер. Камера просто бомба!', '2024-03-10'),
       (12, 2, 4, 4, 'Идеален для работы и игр.', '2024-03-15'),
       (13, 3, 3, 2, 'Быстро ломается кнопка включения.', '2024-03-20'),
       (14, 4, 2, 5, 'Функционал за эти деньги поражает.', '2024-03-25'),
       (15, 5, 1, 1, 'Не справляется с моей собакой.', '2024-03-30'),
       (16, 6, 9, 3, 'Батарея держит меньше заявленной.', '2024-01-25'),
       (17, 7, 8, 5, 'Лучшая покупка за последнее время!', '2024-02-28'),
       (18, 8, 7, 4, 'Хорош для городских поездок.', '2024-03-07'),
       (19, 9, 6, 2, 'Неудобно чистить.', '2024-01-30'),
       (20, 10, 5, 4, 'Замечательный помощник для поддержания формы.', '2024-02-12');
