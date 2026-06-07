# Infrastructure

## Files

| File | Purpose |
|---|---|
| nginx/brewer.conf | Nginx reverse proxy config |
| systemd/brewer.service | systemd service for Node.js app |
| ansible/ | Ansible playbooks (Phase 4) |

## Deployment Notes

- Node.js path in brewer.service points to NVM installation
- Nginx proxies /api/* to Node.js on port 3000
- Static files served directly by Nginx from /opt/brewer/app/public
- .env file lives on web01 at /opt/brewer/app/.env — never in git