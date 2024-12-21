CREATE TABLE good
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255)   NOT NULL,
    description VARCHAR(255)   NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    amount      INTEGER        NOT NULL
);
