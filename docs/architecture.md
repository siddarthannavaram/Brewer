# Brewer Architecture

## Infrastructure

| VM | Role | IP |
|--- |---|---|
| web01 | Nginx + Node.js API | 192.168.122.X |
| db01 | PostgreSQL database | 192.168.122.X |
| monitor01 | Prometheus + Grafana | 192.168.122.X |

## Request Flow
Browser
└── HTTP port 80
└── Nginx (web01)
├── Static files → /opt/brewer/app/public/
└── /api/* → Node.js port 3000
└── PostgreSQL port 5432 (db01)


## Database Schema

| Table | Purpose |
|---|---|
| users | registered customers |
| menu_items | cafe items with categories and prices |
| orders | order header linked to user |
| order_items | individual items in an order |
| bills | generated when customer requests bill (Phase 3) |
| kitchen_queue | receives items when order placed (Phase 4) |

## Services

| Service | Managed by | Port |
|---|---|---|
| brewer API | systemd | 3000 |
| nginx | systemd | 80 |
| postgresql | systemd | 5432 |

## Phases

| Phase | Status | What was built |
|---|---|---|
| 0 | Complete | VMs, networking, GitHub repo |
| 1 | Complete | Core app — auth, menu, ordering |
| 2 | In Progress | Monitoring — Prometheus, Grafana, Loki |
| 3 | Planned | Billing service |
| 4 | Planned | Kitchen service |
| 5 | Planned | CI/CD pipeline |
| 6 | Planned | Containers — Docker, Docker Compose |