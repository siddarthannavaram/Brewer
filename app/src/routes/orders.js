const express = require('express');
const router = express.Router();
const pool = require('../config/database');
const authMiddleware = require('../middleware/auth');

// POST /api/orders - place a new order
router.post('/', authMiddleware, async (req, res) => {
  const { items } = req.body;
  const user_id = req.user.id;

  if (!items || !Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: 'Order must contain at least one item.' });
  }

  const client = await pool.connect();

  try {
    await client.query('BEGIN');

    // create the order
    const orderResult = await client.query(
      'INSERT INTO orders (user_id, status) VALUES ($1, $2) RETURNING *',
      [user_id, 'pending']
    );
    const order = orderResult.rows[0];

    // add each item to order_items
    // we store price_at_time so price changes don't affect existing orders
    for (const item of items) {
      const menuItem = await client.query(
        'SELECT * FROM menu_items WHERE id = $1 AND available = true',
        [item.menu_item_id]
      );

      if (menuItem.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ error: `Menu item ${item.menu_item_id} not found or unavailable.` });
      }

      const price = menuItem.rows[0].price;

      await client.query(
        'INSERT INTO order_items (order_id, menu_item_id, quantity, price_at_time) VALUES ($1, $2, $3, $4)',
        [order.id, item.menu_item_id, item.quantity, price]
      );

      // add to kitchen queue - kitchen sees this immediately
      await client.query(
        'INSERT INTO kitchen_queue (order_id, menu_item_id, quantity, status) VALUES ($1, $2, $3, $4)',
        [order.id, item.menu_item_id, item.quantity, 'received']
      );
    }

    await client.query('COMMIT');

    res.status(201).json({
      message: 'Order placed successfully.',
      order_id: order.id,
      status: order.status
    });

  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Order error:', err.message);
    res.status(500).json({ error: 'Could not place order.' });
  } finally {
    client.release();
  }
});

// GET /api/orders - get all orders for logged in user
router.get('/', authMiddleware, async (req, res) => {
  const user_id = req.user.id;

  try {
    const orders = await pool.query(
      'SELECT * FROM orders WHERE user_id = $1 ORDER BY created_at DESC',
      [user_id]
    );

    // get items for each order
    const ordersWithItems = await Promise.all(
      orders.rows.map(async (order) => {
        const items = await pool.query(
          `SELECT oi.*, mi.name, mi.category 
           FROM order_items oi 
           JOIN menu_items mi ON oi.menu_item_id = mi.id 
           WHERE oi.order_id = $1`,
          [order.id]
        );
        return { ...order, items: items.rows };
      })
    );

    res.json({ orders: ordersWithItems });

  } catch (err) {
    console.error('Orders fetch error:', err.message);
    res.status(500).json({ error: 'Could not fetch orders.' });
  }
});

// GET /api/orders/:id - get a specific order
router.get('/:id', authMiddleware, async (req, res) => {
  const { id } = req.params;
  const user_id = req.user.id;

  try {
    const order = await pool.query(
      'SELECT * FROM orders WHERE id = $1 AND user_id = $2',
      [id, user_id]
    );

    if (order.rows.length === 0) {
      return res.status(404).json({ error: 'Order not found.' });
    }

    const items = await pool.query(
      `SELECT oi.*, mi.name, mi.category 
       FROM order_items oi 
       JOIN menu_items mi ON oi.menu_item_id = mi.id 
       WHERE oi.order_id = $1`,
      [id]
    );

    res.json({ order: { ...order.rows[0], items: items.rows } });

  } catch (err) {
    console.error('Order fetch error:', err.message);
    res.status(500).json({ error: 'Could not fetch order.' });
  }
});

module.exports = router;
