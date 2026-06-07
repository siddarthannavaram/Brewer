# Phase 1 Deployment Runbook

## What This Covers
Step by step instructions to deploy the Brewer app on web01 for the first time.

## Prerequisites
- web01, db01, monitor01 VMs running
- PostgreSQL running on db01 with cafedb and cafeuser
- Node.js and Nginx installed on web01
- GitHub repo cloned on your host machine

---

## Step 1 — Run Database Migrations on db01

SSH into db01:
```bash
ssh db01
```

Run the schema migration:
```bash
psql -h localhost -U cafeuser -d cafedb -f /tmp/001_initial_schema.sql
```

Run the seed data:
```bash
psql -h localhost -U cafeuser -d cafedb -f /tmp/002_seed_menu.sql
```

Verify tables were created:
```bash
psql -h localhost -U cafeuser -d cafedb -c "\dt"
```

You should see: users, menu_items, orders, order_items, bills, kitchen_queue

Verify menu items were seeded:
```bash
psql -h localhost -U cafeuser -d cafedb -c "SELECT COUNT(*) FROM menu_items;"
```

Should return 23.

---

## Step 2 — Clone Repo on web01

SSH into web01:
```bash
ssh web01
```

Create the app directory:
```bash
sudo mkdir -p /opt/brewer
sudo chown devops:devops /opt/brewer
```

Clone the repo:
```bash
git clone git@github.com:siddarthannavaram/Brewer.git /opt/brewer
```

---

## Step 3 — Create .env File on web01

```bash
nano /opt/brewer/app/.env
```

Add the following — replace DB_HOST with db01's actual IP:
```
PORT=3000
NODE_ENV=production
DB_HOST=192.168.122.93
DB_PORT=5432
DB_NAME=cafedb
DB_USER=cafeuser
DB_PASSWORD=cafepass123
JWT_SECRET=brewer_super_secret_jwt_key_change_in_production
```

---

## Step 4 — Install Node Dependencies

```bash
cd /opt/brewer/app
npm install --omit=dev
```

---

## Step 5 — Start App Manually and Verify

Test it runs before setting up systemd:
```bash
cd /opt/brewer/app
node src/index.js
```

In a second terminal verify health check:
```bash
curl http://localhost:3000/health
```

Should return JSON with status: healthy. Stop the app with Ctrl+C.

---

## Step 6 — Set Up systemd Service

Copy service file:
```bash
sudo cp /opt/brewer/infra/systemd/brewer.service /etc/systemd/system/
```

Reload systemd and start the service:
```bash
sudo systemctl daemon-reload
sudo systemctl start brewer
sudo systemctl enable brewer
```

Verify it's running:
```bash
sudo systemctl status brewer
```

Check logs:
```bash
sudo journalctl -u brewer -f
```

---

## Step 7 — Configure Nginx

Copy nginx config:
```bash
sudo cp /opt/brewer/infra/nginx/brewer.conf /etc/nginx/sites-available/brewer
sudo ln -s /etc/nginx/sites-available/brewer /etc/nginx/sites-enabled/brewer
sudo rm /etc/nginx/sites-enabled/default
```

Test nginx config:
```bash
sudo nginx -t
```

Reload nginx:
```bash
sudo systemctl reload nginx
```

---

## Step 8 — Verify Full Stack

From your host machine browser open:
```
http://web01-ip
```

You should see the Brewer login page.

Test registration:
- Go to /register.html
- Create an account
- Login
- Browse menu — should show all items
- Place an order
- Go to /orders.html — should show your order

---

## Step 9 — Verify Each Layer

App is running:
```bash
sudo systemctl status brewer
```

App health:
```bash
curl http://localhost:3000/health
```

Nginx is running:
```bash
sudo systemctl status nginx
```

Database connection from web01:
```bash
psql -h 192.168.122.93 -U cafeuser -d cafedb -c "SELECT COUNT(*) FROM users;"
```

---

## What to Check if Something Breaks

| Problem | Where to look |
|---|---|
| App won't start | `sudo journalctl -u brewer -n 50` |
| Nginx 502 Bad Gateway | app not running on port 3000 |
| Database connection refused | check firewall on db01, check .env DB_HOST |
| Login not working | check JWT_SECRET in .env |
| Menu not loading | check database migration ran correctly |
