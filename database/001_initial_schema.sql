-- Migration: 001_initial_schema.sql
-- Description: Full initial schema for Brewer cafe ordering system
-- Includes: users, menu_items, orders, order_items, bills, kitchen_queue
-- Run this on db01 as cafeuser or postgres

-- users table
-- stores registered customers
-- password_hash: we never store plain text passwords
CREATE TABLE IF NOT EXISTS users (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- menu_items table
-- stores all cafe items with categories
-- available: set to false to hide item without deleting it
CREATE TABLE IF NOT EXISTS menu_items (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  description TEXT,
  price       NUMERIC(10, 2) NOT NULL,
  category    VARCHAR(50) NOT NULL,
  available   BOOLEAN DEFAULT true,
  created_at  TIMESTAMP DEFAULT NOW()
);

-- orders table
-- one order per customer visit
-- status: pending → confirmed → preparing → served
CREATE TABLE IF NOT EXISTS orders (
  id         SERIAL PRIMARY KEY,
  user_id    INTEGER NOT NULL REFERENCES users(id),
  status     VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- order_items table
-- individual items within an order
-- price_at_time: stores price when order was placed
-- this means price changes don't affect existing orders
CREATE TABLE IF NOT EXISTS order_items (
  id            SERIAL PRIMARY KEY,
  order_id      INTEGER NOT NULL REFERENCES orders(id),
  menu_item_id  INTEGER NOT NULL REFERENCES menu_items(id),
  quantity      INTEGER NOT NULL DEFAULT 1,
  price_at_time NUMERIC(10, 2) NOT NULL,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- bills table
-- generated when customer requests the bill
-- populated by billing service in Phase 3
CREATE TABLE IF NOT EXISTS bills (
  id         SERIAL PRIMARY KEY,
  order_id   INTEGER NOT NULL REFERENCES orders(id),
  subtotal   NUMERIC(10, 2) NOT NULL DEFAULT 0,
  tax        NUMERIC(10, 2) NOT NULL DEFAULT 0,
  total      NUMERIC(10, 2) NOT NULL DEFAULT 0,
  paid       BOOLEAN DEFAULT false,
  paid_at    TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

-- kitchen_queue table
-- receives items when order is placed
-- kitchen staff see this and update status
-- populated by ordering service, managed by kitchen service in Phase 4
CREATE TABLE IF NOT EXISTS kitchen_queue (
  id           SERIAL PRIMARY KEY,
  order_id     INTEGER NOT NULL REFERENCES orders(id),
  menu_item_id INTEGER NOT NULL REFERENCES menu_items(id),
  quantity     INTEGER NOT NULL DEFAULT 1,
  status       VARCHAR(20) DEFAULT 'received',
  updated_at   TIMESTAMP DEFAULT NOW(),
  created_at   TIMESTAMP DEFAULT NOW()
);

-- indexes for performance
-- these speed up common queries
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_kitchen_queue_order_id ON kitchen_queue(order_id);
CREATE INDEX IF NOT EXISTS idx_kitchen_queue_status ON kitchen_queue(status);
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category);
