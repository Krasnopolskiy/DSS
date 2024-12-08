CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_ordering_ordered_at ON ordering USING btree (ordered_at);

CREATE INDEX idx_good_seller ON good USING hash (seller);

CREATE INDEX idx_good_price ON good USING brin (price);

CREATE INDEX idx_user_address ON "user" USING gist (address gist_trgm_ops);
