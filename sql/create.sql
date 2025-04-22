GRANT TEMP ON DATABASE commerce TO yummy;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO yummy;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO yummy;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO yummy;

\c commerce;

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price DECIMAL(12,2) NOT NULL CHECK (price > 0)
);


CREATE INDEX product_name_idx ON products(name);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE product_category (
  product_id INT REFERENCES products(id) ON DELETE CASCADE,
  category_id INT REFERENCES categories(id) ON DELETE CASCADE, 
  PRIMARY KEY (product_id, category_id)
);

CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  surname TEXT NOT NULL,
  email TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role_id INT REFERENCES roles(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE purchases (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE purchase_product (
  purchase_id INT REFERENCES purchases(id),
  product_id INT REFERENCES products(id),
  count INT NOT NULL CHECK(count > 0),
  price_per_item DECIMAL(12, 2) NOT NULL CHECK(price_per_item > 0),
  PRIMARY KEY (purchase_id, product_id)
);
