const express = require('express');
const router = express.Router();
const pool = require('../config/database');
const authMiddleware = require('../middleware/auth');

// GET /api/menu - get all available menu items
router.get('/', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM menu_items WHERE available = true ORDER BY category, name'
    );
    res.json({ items: result.rows });
  } catch (err) {
    console.error('Menu fetch error:', err.message);
    res.status(500).json({ error: 'Could not fetch menu.' });
  }
});

// GET /api/menu/categories - get all categories
router.get('/categories', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT DISTINCT category FROM menu_items WHERE available = true ORDER BY category'
    );
    res.json({ categories: result.rows.map(r => r.category) });
  } catch (err) {
    console.error('Categories fetch error:', err.message);
    res.status(500).json({ error: 'Could not fetch categories.' });
  }
});

// GET /api/menu/:category - get items by category
router.get('/:category', authMiddleware, async (req, res) => {
  const { category } = req.params;
  try {
    const result = await pool.query(
      'SELECT * FROM menu_items WHERE category = $1 AND available = true ORDER BY name',
      [category]
    );
    res.json({ items: result.rows });
  } catch (err) {
    console.error('Category fetch error:', err.message);
    res.status(500).json({ error: 'Could not fetch items for this category.' });
  }
});

module.exports = router;
