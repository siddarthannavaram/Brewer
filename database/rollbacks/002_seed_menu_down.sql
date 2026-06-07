-- Rollback: 002_seed_menu_down.sql
-- Description: Removes all seeded menu items

DELETE FROM menu_items WHERE name IN (
  'Espresso', 'Americano', 'Cappuccino', 'Latte', 'Flat White',
  'Mocha', 'Masala Chai', 'Filter Coffee', 'Cold Brew', 'Iced Latte',
  'Iced Americano', 'Frappuccino', 'Mango Smoothie', 'Lemonade',
  'Iced Matcha', 'Croissant', 'Blueberry Muffin', 'Banana Bread',
  'Cinnamon Roll', 'Chocolate Brownie', 'Almond Croissant',
  'Cheese Sandwich', 'Carrot Cake'
);
