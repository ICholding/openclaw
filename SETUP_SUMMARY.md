# OpenClaw/Moltbot Setup Summary

## What Was Done

### 1. Repository Forked
- **Source**: https://github.com/openclaw/openclaw (197k stars)
- **Forked to**: https://github.com/ICholding/openclaw
- **Version**: 2026.2.15

### 2. Source Code Cloned
- Location: `/home/user/openclaw`
- Size: ~190MB
- Includes: Full source, 33 extensions, 50+ skills

### 3. Docker Infrastructure Created

#### Files Added:
| File | Size | Purpose |
|------|------|---------|
| `Dockerfile.full` | 2.8KB | Multi-stage production build |
| `docker-compose.full.yml` | 3.5KB | Full stack orchestration |
| `docker-build.sh` | 2.6KB | Build automation script |
| `.env.example.docker` | 3.4KB | Environment configuration |
| `DOCKER.md` | 8.1KB | Complete documentation |

#### Features:
- **Multi-stage build** (builder + production stages)
- **All 33 extensions** included (WhatsApp, Telegram, Discord, Slack, Matrix, etc.)
- **All 50+ skills** included (coding-agent, canvas, discord, gemini, etc.)
- **Node.js 22** (required version)
- **pnpm** for fast, disk-efficient installs
- **Bun** for build scripts
- **Non-root user** (security hardening)
- **Health checks** configured
- **Optional services**: Vector DB (pgvector), Redis

## Project Structure

```
openclaw/
├── src/              # Core TypeScript source
│   ├── channels/     # Messaging channel implementations
│   ├── agents/       # AI agent core
│   ├── gateway/      # Gateway server
│   └── cli/          # Command-line interface
├── extensions/       # 33 platform extensions
│   ├── whatsapp/     # Baileys-based WhatsApp
│   ├── telegram/     # grammy.js Telegram
│   ├── discord/      # Discord.js integration
│   ├── slack/        # Slack Bolt
│   ├── matrix/       # Matrix protocol
│   └── ...
├── skills/           # 50+ AI skills
│   ├── coding-agent/ # Code generation
│   ├── canvas/       # UI generation
│   ├── discord/      # Discord management
│   └── ...
├── Dockerfile.full   # Production Dockerfile
└── docker-compose.full.yml  # Orchestration
```

## Key Dependencies

### Core AI:
- `@mariozechner/pi-*` - Pi AI agent framework
- `@anthropic-ai/sdk` - Claude integration
- `@google/genai` - Gemini integration
- `@aws-sdk/client-bedrock` - AWS Bedrock

### Messaging:
- `@whiskeysockets/baileys` - WhatsApp Web
- `grammy` - Telegram Bot API
- `@slack/bolt` - Slack integration
- `@buape/carbon` - Discord framework

### Infrastructure:
- `playwright-core` - Browser automation
- `sharp` - Image processing
- `sqlite-vec` - Vector database
- `node-pty` - Terminal emulation

## How to Use

### Build the Image
```bash
cd /home/user/openclaw
./docker-build.sh
```

### Run with Docker Compose
```bash
# Setup environment
cp .env.example.docker .env
export OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)
echo "OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN" >> .env

# Start services
docker-compose -f docker-compose.full.yml up -d
```

### Setup WhatsApp
```bash
docker-compose -f docker-compose.full.yml run --rm openclaw-cli channels login
```

### Setup Telegram
```bash
docker-compose -f docker-compose.full.yml run --rm openclaw-cli channels add \
  --channel telegram --token YOUR_BOT_TOKEN
```

## Ports

| Port | Service | Description |
|------|---------|-------------|
| 18789 | Gateway | Main WebSocket/API |
| 18790 | Bridge | Bridge service |
| 18793 | Canvas | UI hosting |

## Current System Status

- **Node.js**: v22.22.0 ✓ (upgraded from v20)
- **Disk Space**: 30GB full (installation blocked)
- **Repository**: Forked and cloned ✓
- **Docker Files**: Created and committed ✓

## Next Steps to Complete Installation

1. **Free up disk space** (need ~2GB):
   - Remove cached npm packages
   - Clean Docker build cache
   - Clear system temp files

2. **Build Docker image**:
   ```bash
   ./docker-build.sh
   ```

3. **Configure channels**:
   - WhatsApp (QR scan)
   - Telegram (bot token)
   - Discord (bot token)

4. **Start using**:
   ```bash
   docker-compose -f docker-compose.full.yml up -d
   ```

## References

- **Fork**: https://github.com/ICholding/openclaw
- **Upstream**: https://github.com/openclaw/openclaw
- **Docs**: https://openclaw.ai/docs
- **Website**: https://openclaw.ai

---

*Setup completed: 2026-02-16*
*All Docker files committed to repository*
