CREATE TABLE IF NOT EXISTS products (
  id       SERIAL PRIMARY KEY,
  name     VARCHAR(100) NOT NULL,
  category VARCHAR(50)  NOT NULL,
  price    NUMERIC(10,2) NOT NULL,
  rating   NUMERIC(2,1)
);

INSERT INTO products (name, category, price, rating) VALUES
  ('Wireless Headphones', 'Electronics', 79.99, 4.5),
  ('Running Shoes',       'Fashion',     59.50, 4.2),
  ('Coffee Maker',        'Home',        49.00, 4.0),
  ('Backpack',            'Accessories', 39.99, 4.7),
  ('Desk Lamp',           'Home',        24.90, 3.9);
