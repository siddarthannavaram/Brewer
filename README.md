# Brewer

Self-hosted cafe ordering system built hands-on to learn DevOps.

## Architecture

Browser → Nginx (web01) → Node.js API (web01) → PostgreSQL (db01)
                                                        ↑
                                          Prometheus + Grafana (monitor01)

## Stack
- Frontend: HTML + CSS
- Backend: Node.js + Express
- Database: PostgreSQL
- Monitoring: Prometheus + Grafana + Loki
- Automation: Ansible
- CI/CD: GitHub Actions
- Hypervisor: KVM
## Current Status

### Phase 1 — Complete
- User registration and login with JWT authentication
- Menu browsing with 23 items across 3 categories
- Order placement with kitchen queue
- HTML + CSS frontend served by Nginx
- Node.js + Express backend running as systemd service
- PostgreSQL on dedicated db01 VM
- Auto-restart on crash via systemd

## How to Run

### Prerequisites
- web01, db01, monitor01 VMs running
- PostgreSQL on db01 with cafedb database
- Node.js installed on web01
- Nginx installed on web01

### Deploy
```bash
# on db01 — run migrations
psql -h localhost -U cafeuser -d cafedb -f database/migrations/001_initial_schema.sql
psql -h localhost -U cafeuser -d cafedb -f database/migrations/002_seed_menu.sql

# on web01 — clone and deploy
git clone git@github.com:siddarthannavaram/Brewer.git /opt/brewer
cd /opt/brewer/app && npm install --omit=dev
sudo cp infra/systemd/brewer.service /etc/systemd/system/
sudo systemctl enable --now brewer
sudo cp infra/nginx/brewer.conf /etc/nginx/sites-available/brewer
sudo ln -s /etc/nginx/sites-available/brewer /etc/nginx/sites-enabled/brewer
sudo systemctl reload nginx
```