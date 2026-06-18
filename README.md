# Personal Agent Framework

Run [Claude Code](https://github.com/anthropics/claude-code) as your personal AI agent — with a live-synced Obsidian second brain, private web search, and a restricted firewall.

---

## What you need

| | |
|---|---|
| [Docker Desktop](https://docs.docker.com/get-docker/) | The only technical dependency |
| [Obsidian](https://obsidian.md) | Free note-taking app for your second brain |
| A Bonzai API key | Get one via the usual Bonzai process |

---

## Setup (3 steps)

### 1. Get the project

```bash
git clone <repo-url> ~/personal-agent-framework
cd ~/personal-agent-framework
```

Or download and unzip it — no git required.

### 2. Add your Bonzai API key

```bash
cp .env.example .env
```

Open `.env` and set your key:

```
ANTHROPIC_AUTH_TOKEN=your-bonzai-api-key-here
```

### 3. Start the agent

**macOS / Linux:**
```bash
./start-personal-agent.sh
```

**Windows (PowerShell):**
```powershell
.\start-personal-agent.ps1
```

On first start, Docker will build the Claude Code agent image and generate a unique secret key for your SearXNG instance. After that, Claude Code launches automatically inside the container.

---

## Opening your second brain in Obsidian

Your notes live in the `brain/` folder inside this project. To open it:

1. Open Obsidian
2. Click **Open folder as vault**
3. Navigate to `~/personal-agent-framework/brain/`

Any notes Claude creates or edits inside the container are instantly visible in Obsidian, and vice versa.

---

## Project structure

```
personal-agent-framework/
├── brain/                      # Your Obsidian vault — open this in Obsidian
├── start-personal-agent.sh     # Start script for macOS / Linux
├── start-personal-agent.ps1    # Start script for Windows (PowerShell)
├── docker-compose.yml          # Orchestrates the agent + search containers
├── whitelist.local.csv         # Extra domains/IPs to allow through the firewall
├── .env.example                # Copy to .env and add your Bonzai API key
├── devcontainer/
│   ├── Dockerfile              # Based on the official Anthropic Claude Code devcontainer
│   ├── init-firewall.sh        # Firewall (reads whitelist.local.csv)
│   ├── startup.sh              # Container entrypoint
│   ├── searxng-mcp.js          # Gives Claude a web_search tool via SearXNG
│   └── claude-default-settings.json
└── searxng/
    ├── settings.yml            # Generated on first start (git-ignored)
    └── settings.yml.example    # Template
```

---

## Firewall & whitelist

The agent container can only reach a curated list of domains (GitHub, npm, Bonzai, etc.) plus the SearXNG container for web search. Everything else is blocked.

To allow additional domains or IPs, edit `whitelist.local.csv`:

```
# Examples
pypi.org
files.pythonhosted.org
1.2.3.4
10.0.0.0/8
```

Apply changes by restarting the agent:

```bash
docker compose restart claude-agent
```

---

## Web search

Claude has a built-in `web_search` tool that routes through the SearXNG container — a private, self-hosted meta search engine. It searches Google, DuckDuckGo, Brave, Wikipedia, GitHub, Stack Overflow, and arXiv. No queries are sent to third-party search APIs.

---

## Changing the timezone

Add `TZ` to your `.env` file (which you already created in setup):

```bash
echo "TZ=America/New_York" >> .env
```

Then restart:

```bash
docker compose up -d
```

---

## Useful commands

```bash
# Start agent (macOS / Linux)
./start-personal-agent.sh

# Start agent (Windows PowerShell)
.\start-personal-agent.ps1

# Stop everything
docker compose down

# Rebuild after updating the Dockerfile or firewall script
docker compose up -d --build

# View logs
docker compose logs -f claude-agent

# Open a shell in the agent without launching Claude
docker exec -it personal-agent /bin/zsh

# Check which IPs are whitelisted
docker exec -it personal-agent sudo ipset list allowed-domains
```

---

## Troubleshooting

**`web_search` not available in Claude** — The MCP settings are written to a Docker volume on first start. If you started the container before this was ready, reset the volume:
```bash
docker compose down -v
docker compose up -d
```

**Firewall blocks something you need** — Add the domain or IP to `whitelist.local.csv` and run `docker compose restart claude-agent`.

**Permission errors on brain/** — The container runs as UID 1000. If your host user has a different UID, add `user: "YOUR_UID:YOUR_GID"` under `claude-agent` in `docker-compose.yml`.
