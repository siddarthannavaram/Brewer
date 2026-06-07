-- Migration: 002_seed_menu.sql
-- Description: Seed menu items for Brewer cafe
-- Categories: Hot Beverages, Cold Beverages, Bakery
-- Run this after 001_initial_schema.sql

INSERT INTO menu_items (name, description, price, category, available) VALUES

-- Hot Beverages
('Espresso',        'Strong single shot of pure espresso',                    2.50,  'Hot Beverages',  true),
('Americano',       'Espresso with hot water, smooth and bold',               3.00,  'Hot Beverages',  true),
('Cappuccino',      'Espresso with steamed milk and thick foam',              3.50,  'Hot Beverages',  true),
('Latte',           'Espresso with steamed milk, smooth and creamy',          3.75,  'Hot Beverages',  true),
('Flat White',      'Double espresso with microfoam milk',                    3.75,  'Hot Beverages',  true),
('Mocha',           'Espresso with chocolate and steamed milk',               4.00,  'Hot Beverages',  true),
('Masala Chai',     'Spiced Indian tea with milk',                            2.75,  'Hot Beverages',  true),
('Filter Coffee',   'South Indian style drip coffee with milk',               2.50,  'Hot Beverages',  true),

-- Cold Beverages
('Cold Brew',       '12-hour cold steeped coffee, smooth and strong',         4.50,  'Cold Beverages', true),
('Iced Latte',      'Espresso over ice with cold milk',                       4.00,  'Cold Beverages', true),
('Iced Americano',  'Espresso over ice with cold water',                      3.50,  'Cold Beverages', true),
('Frappuccino',     'Blended coffee with ice cream and whipped cream',        5.00,  'Cold Beverages', true),
('Mango Smoothie',  'Fresh mango blended with yogurt and honey',              4.50,  'Cold Beverages', true),
('Lemonade',        'Fresh squeezed lemon with mint and sugar',               3.00,  'Cold Beverages', true),
('Iced Matcha',     'Japanese green tea matcha over ice with oat milk',       4.75,  'Cold Beverages', true),

-- Bakery
('Croissant',       'Buttery French croissant, freshly baked',                2.50,  'Bakery',         true),
('Blueberry Muffin','Moist muffin loaded with fresh blueberries',             2.75,  'Bakery',         true),
('Banana Bread',    'Homemade banana bread slice, moist and sweet',           3.00,  'Bakery',         true),
('Cinnamon Roll',   'Soft roll with cinnamon sugar and cream cheese glaze',   3.50,  'Bakery',         true),
('Chocolate Brownie','Rich dark chocolate brownie with walnuts',              3.25,  'Bakery',         true),
('Almond Croissant','Croissant filled with almond cream, topped with flakes', 3.50,  'Bakery',         true),
('Cheese Sandwich', 'Toasted sandwich with cheddar and herbs',                4.00,  'Bakery',         true),
('Carrot Cake',     'Spiced carrot cake with cream cheese frosting',          3.75,  'Bakery',         true);
