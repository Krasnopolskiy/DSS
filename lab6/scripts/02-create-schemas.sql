CREATE SCHEMA "user";
CREATE SCHEMA catalog;
CREATE SCHEMA sales;

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

SET search_path TO "user", catalog, sales, public;
