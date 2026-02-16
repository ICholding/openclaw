# OpenClaw/Moltbot Docker Setup

Complete Docker setup for OpenClaw (formerly Moltbot/Clawdbot) - a multi-channel AI gateway with WhatsApp, Telegram, Discord, Slack, and more.

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/ICholding/openclaw.git
cd openclaw

# 2. Copy environment template
cp .env.example.docker .env

# 3. Generate a secure token
export OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)
echo "OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN" >> .env

# 4. Build the Docker image
./docker-build.sh

# 5. Run with docker-compose
docker-compose -f docker-compose.full.yml up -d
```

## Files Overview

| File | Description |
|------|-------------|
| `Dockerfile.full` | Multi-stage build with all dependencies |
| `docker-compose.full.yml` | Full stack with optional services |
| `docker-build.sh` | Build script with options |
| `.env.example.docker` | Environment template |
| `DOCKER.md` | This documentation |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenClaw Gateway                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │ WhatsApp │ │ Telegram │ │ Discord  │ │  Slack   │      │
│  │ (Baileys)│ │ (grammy) │ │(Bolt.js) │ │(Bolt.js)│      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │  Signal  │ │ iMessage │ │  Matrix  │ │Mattermost│      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │              AI Agent Core (Pi)                     │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐            │  │
│  │  │  OpenAI  │ │Anthropic │ │  Google  │            │  │
│  │  │   GPT    │ │  Claude  │ │  Gemini  │            │  │
│  │  └──────────┘ └──────────┘ └──────────┘            │  │
│  └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `OPENCLAW_GATEWAY_TOKEN` | Authentication token | (required) |
| `OPENCLAW_GATEWAY_BIND` | Bind address | lan |
| `OPENCLAW_GATEWAY_PORT` | Gateway port | 18789 |
| `OPENCLAW_BRIDGE_PORT` | Bridge port | 18790 |
| `OPENCLAW_CANVAS_PORT` | Canvas port | 18793 |

### Channel Configuration

```bash
# WhatsApp (enabled by default)
WHATSAPP_ENABLED=true

# Telegram
TELEGRAM_ENABLED=true
TELEGRAM_BOT_TOKEN=your_bot_token

# Discord
DISCORD_ENABLED=true
DISCORD_BOT_TOKEN=your_bot_token
DISCORD_CLIENT_ID=your_client_id

# Slack
SLACK_ENABLED=true
SLACK_BOT_TOKEN=xoxb-your-token
SLACK_SIGNING_SECRET=your-signing-secret
```

## Building

### Standard Build
```bash
./docker-build.sh
```

### Build with Options
```bash
# Build without cache
./docker-build.sh --no-cache

# Build with custom image name
./docker-build.sh --image myregistry/openclaw:latest

# Build with additional APT packages
./docker-build.sh --apt-packages "ffmpeg imagemagick"

# Build and push to registry
./docker-build.sh --push --image myregistry/openclaw:latest
```

## Running

### Using Docker Compose (Recommended)
```bash
# Start all services
docker-compose -f docker-compose.full.yml up -d

# View logs
docker-compose -f docker-compose.full.yml logs -f openclaw-gateway

# Stop all services
docker-compose -f docker-compose.full.yml down

# Stop and remove volumes
docker-compose -f docker-compose.full.yml down -v
```

### Using Docker Run
```bash
# Run gateway
docker run -d \
  --name openclaw-gateway \
  -p 18789:18789 \
  -p 18790:18790 \
  -p 18793:18793 \
  -e OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32) \
  -v openclaw-config:/home/openclaw/.openclaw \
  openclaw:full

# Run CLI
docker run -it --rm \
  --name openclaw-cli \
  --network container:openclaw-gateway \
  -e OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN \
  -v openclaw-config:/home/openclaw/.openclaw \
  openclaw:full \
  node dist/index.js channels login
```

## Channel Setup

### WhatsApp
```bash
# Login to WhatsApp (QR code)
docker-compose -f docker-compose.full.yml run --rm openclaw-cli channels login

# Or with specific channel
docker-compose -f docker-compose.full.yml run --rm openclaw-cli channels add --channel whatsapp
```

### Telegram
```bash
# Add Telegram bot
docker-compose -f docker-compose.full.yml run --rm openclaw-cli channels add --channel telegram --token YOUR_BOT_TOKEN
```

### Discord
```bash
# Add Discord bot
docker-compose -f docker-compose.full.yml run --rm openclaw-cli channels add --channel discord --token YOUR_BOT_TOKEN
```

## Health Checks

```bash
# Check gateway health
curl http://localhost:18789/health

# Or using CLI
docker-compose -f docker-compose.full.yml run --rm openclaw-cli health
```

## Troubleshooting

### Disk Space Issues
```bash
# Clean up Docker system
docker system prune -a -f

# Clean up build cache
docker buildx prune -f
```

### Permission Issues
```bash
# Fix volume permissions
docker run --rm -v openclaw-config:/data alpine chown -R 1000:1000 /data
```

### Network Issues
```bash
# Check gateway connectivity
docker-compose -f docker-compose.full.yml exec openclaw-gateway netstat -tlnp
```

## Security Notes

1. **Token Generation**: Always use a secure random token:
   ```bash
   openssl rand -hex 32
   ```

2. **Network Binding**: Use `lan` or `loopback` for internal networks, avoid `0.0.0.0` in production without proper firewall rules.

3. **Volume Permissions**: The container runs as non-root user (UID 1000). Ensure volumes have correct permissions.

4. **Secrets Management**: Never commit `.env` files with real credentials. Use Docker secrets or external vaults in production.

## License

MIT License - See LICENSE file in the repository.

## Links

- Repository: https://github.com/ICholding/openclaw
- Upstream: https://github.com/openclaw/openclaw
- Documentation: https://openclaw.ai/docs
- Website: https://openclaw.ai
