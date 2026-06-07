-- Rollback: 001_initial_schema_down.sql
-- Description: Drops all tables created by 001_initial_schema.sql
-- WARNING: This deletes all data. Only use in emergencies.

DROP TABLE IF EXISTS kitchen_queue CASCADE;
DROP TABLE IF EXISTS bills CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS menu_items CASCADE;
DROP TABLE IF EXISTS users CASCADE;
