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
