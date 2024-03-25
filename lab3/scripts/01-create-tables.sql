CREATE TABLE user
(
    id      INTEGER PRIMARY KEY,
    name    VARCHAR(255)        NOT NULL,
    email   VARCHAR(255) UNIQUE NOT NULL,
    address TEXT
);

CREATE TABLE category
(
    id     INTEGER PRIMARY KEY,
    name   VARCHAR(255) NOT NULL,
    parent INTEGER,
    FOREIGN KEY (parent) REFERENCES category (id) ON DELETE SET NULL
);

CREATE TABLE good
(
    id          INTEGER PRIMARY KEY,
    name        VARCHAR(255)   NOT NULL,
    description TEXT           NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    amount      INTEGER        NOT NULL,
    seller      INTEGER        NOT NULL,
    FOREIGN KEY (seller) REFERENCES user (id) ON DELETE RESTRICT
);

CREATE TABLE good_category
(
    good     INTEGER NOT NULL,
    category INTEGER NOT NULL,
    PRIMARY KEY (good, category),
    FOREIGN KEY (good) REFERENCES good (id) ON DELETE CASCADE,
    FOREIGN KEY (category) REFERENCES category (id) ON DELETE CASCADE
);

CREATE TABLE cart_item
(
    buyer INTEGER NOT NULL,
    good  INTEGER NOT NULL,
    PRIMARY KEY (buyer, good),
    FOREIGN KEY (buyer) REFERENCES user (id) ON DELETE CASCADE,
    FOREIGN KEY (good) REFERENCES good (id) ON DELETE CASCADE
);

CREATE TABLE ordering
(
    id          INTEGER PRIMARY KEY,
    buyer       INTEGER NOT NULL,
    ordered_at  DATE    NOT NULL,
    received_at DATE,
    status      VARCHAR(8),
    FOREIGN KEY (buyer) REFERENCES user (id) ON DELETE RESTRICT,
    CHECK ( status IN ('PENDING', 'SHIPPING', 'RECEIVED') )
);

CREATE TABLE ordering_item
(
    id       INTEGER PRIMARY KEY,
    ordering INTEGER        NOT NULL,
    good     INTEGER        NOT NULL,
    amount   INTEGER        NOT NULL,
    price    DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ordering) REFERENCES ordering (id) ON DELETE RESTRICT,
    FOREIGN KEY (good) REFERENCES good (id) ON DELETE RESTRICT
);

CREATE TABLE review
(
    id          INTEGER PRIMARY KEY,
    good        INTEGER NOT NULL,
    buyer       INTEGER NOT NULL,
    rating      INTEGER NOT NULL,
    comment     TEXT,
    reviewed_at DATE    NOT NULL,
    FOREIGN KEY (good) REFERENCES good (id) ON DELETE CASCADE,
    FOREIGN KEY (buyer) REFERENCES user (id) ON DELETE CASCADE,
    CHECK ( rating >= 1 AND rating <= 5 )
);
