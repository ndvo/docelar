# Deployment Plan - Doce Lar

## Overview

Deploy Doce Lar to a Brazilian VPS using Kamal 2 (Rails 8's recommended deployment tool).

## Why Kamal?

| Feature | Kamal | Docker Compose | Capistrano |
|---------|-------|----------------|------------|
| Zero-downtime deploys | ✅ | ❌ | ✅ |
| Built for Rails 8 | ✅ | ❌ | ❌ |
| No SSH needed | ✅ | ❌ | ✅ |
| SSL auto-cert | ✅ | ❌ | Manual |
| Single server | ✅ | ✅ | ✅ |
| Multi-server | ✅ | ❌ | ✅ |

## Recommended Stack

### Infrastructure
- **VPS**: Brazilian provider (see options below)
- **OS**: Ubuntu 22.04 LTS
- **Runtime**: Ruby via system packages or rbenv
- **Database**: SQLite with Solid Queue & Solid Cache (Rails 8 defaults)
- **Web Server**: Puma (built into Rails 8)
- **Reverse Proxy**: Kamal's Traefik (built-in)

### Why No PostgreSQL/Redis?

| Feature | Rails 8 Default | Alternative |
|---------|-----------------|-------------|
| Database | SQLite | PostgreSQL |
| Queue | Solid Queue | Sidekiq + Redis |
| Cache | Solid Cache | Redis |

**For a family home management app:**
- SQLite is perfect - simple, portable, no setup
- Solid Queue - async jobs without Redis
- Solid Cache - file-based caching, no Redis needed

**Only add complexity when needed:**
- PostgreSQL: when you need multi-server scaling
- Redis: when you need real-time (ActionCable) at scale

### Brazilian VPS Options

| Provider | Location | Starting Price | Notes |
|----------|----------|----------------|-------|
| **HostGator** | Brazil | R$10/mo | Large Brazilian provider |
| **LocaWeb** | Brazil | R$15/mo | Good support |
| **DigitalOcean** | São Paulo | $6/mo | Global, SPO region |
| **Hetzner** | Finland | €4/mo | Cheap, EU latency |
| **Contabo** | Germany | €7/mo | Good specs |

**Recommendation**: Start with **DigitalOcean São Paulo** or **HostGator** for lowest latency in Brazil.

## Prerequisites

### On Server
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install Docker Compose (if needed)
sudo apt install docker-compose
```

### On Local Machine
```bash
# Install Kamal
gem install kamal

# Verify Kamal
kamal version
```

## Deployment Steps

### 1. Configure deploy.yml

```yaml
# config/deploy.yml
service: docelar
image: username/docelar

servers:
  web:
    - 187.x.x.x  # Your VPS IP

proxy:
  ssl: true
  host: docelar.com.br

registry:
  username: dockerhub-username
  password:
    - KAMAL_REGISTRY_PASSWORD

builder:
  multiarch: true  # For Apple Silicon compatibility
```

### 2. Set Up Secrets

```bash
# .kamal/secrets
KAMAL_REGISTRY_PASSWORD=your-dockerhub-password
RAILS_MASTER_KEY=your-rails-master-key
```

### 3. First Deployment

```bash
# Run setup (installs Traefik, etc.)
kamal setup

# Deploy
kamal deploy

# Check status
kamal details
```

## Database Strategy

### SQLite (Default - Recommended)

```yaml
# config/deploy.yml
volumes:
  - "app_storage:/app/storage"
```

Benefits:
- Zero setup, zero maintenance
- Portable - backup is just a file copy
- Perfect for single-server
- WAL mode for concurrent reads

Enable WAL mode for better concurrency:
```ruby
# config/initializers/database.rb
Rails.application.config.after_initialize do
  ActiveRecord::Base.connection.execute("PRAGMA journal_mode=WAL")
end
```

### When to Switch to PostgreSQL

Consider PostgreSQL when:
- Multi-server deployment needed
- Team needs concurrent access to data
- Advanced SQL features required
- Cloud database service preferred

## Environment Variables

```bash
# .env (local only, never commit)
RAILS_SERVE_STATIC_FILES=true
RAILS_ENV=production
DATABASE_URL=postgresql://user:pass@localhost/docelar_production
```

## CI/CD Pipeline

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      
      - name: Install Kamal
        run: gem install kamal
      
      - name: Deploy
        env:
          KAMAL_REGISTRY_PASSWORD: ${{ secrets.KAMAL_REGISTRY_PASSWORD }}
          RAILS_MASTER_KEY: ${{ secrets.RAILS_MASTER_KEY }}
        run: kamal deploy
```

## SSL/TLS

Kamal auto-configures Let's Encrypt via Traefik:

```yaml
# config/deploy.yml
proxy:
  ssl: true
  host: docelar.com.br
```

Requirements:
- Domain pointed to server IP (A record)
- Port 80 and 443 open

## Health Checks

Add to `config/deploy.yml`:
```yaml
healthcheck:
  path: /up
  interval: 10s
  timeout: 2s
  retries: 3
```

Add to `config/routes.rb`:
```ruby
get "/up", to: proc { [200, {}, ["OK"]] }
```

## Monitoring

### Basic Health Check
```bash
# Check app status
kamal app status

# View logs
kamal app logs

# View recent deployments
kamal app versions
```

### Log Management
```bash
# Access app logs
kamal app logs --since 1h

# Export to local file
kamal app logs > app.log
```

## Rollback

```bash
# List versions
kamal app versions

# Rollback to previous version
kamal app boot
```

## Performance Tuning

### Puma Workers
```yaml
# config/deploy.yml
env:
  clear:
    WEB_CONCURRENCY: 2
    MAX_THREADS: 5
```

### Asset Pipeline
```yaml
# config/deploy.yml
builder:
  args:
    NODE_OPTIONS: "--max-old-space-size=512"
```

## Security Checklist

- [ ] Change default SSH port
- [ ] Set up UFW firewall (allow 22, 80, 443)
- [ ] Use SSH keys, disable password auth
- [ ] Store secrets in `.kamal/secrets`
- [ ] Enable automatic security updates
- [ ] Set up fail2ban
- [ ] Use SQLite WAL mode for better concurrency

## Troubleshooting

### Common Issues

**Deploy fails with "connection refused"**
```bash
# Check Docker is running
sudo systemctl status docker

# Check ports
sudo ufw status
```

**App won't start**
```bash
# Check logs
kamal app logs

# Check container health
docker ps
docker logs docelar-web-1
```

**SSL certificate issues**
```bash
# Wait 5 minutes for Let's Encrypt
# Or manually verify DNS
nslookup docelar.com.br
```

## Future Enhancements

1. **Multi-server**: Add Redis for ActionCable
2. **Backups**: Automated SQLite/PG backups
3. **CDN**: Cloudflare for static assets
4. **Monitoring**: Prometheus + Grafana
5. **Database**: Managed PostgreSQL (ScaleGrid, Supabase)
