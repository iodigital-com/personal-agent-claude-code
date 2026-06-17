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

### 2. Start the containers

```bash
docker compose up -d --build
```

That's it. On first start, Docker will:
- Build the Claude Code agent image
- Generate a unique secret key for your SearXNG instance
- Start both services

### 3. Add the `pa` alias to your shell

See [Alias setup](#alias-setup) below. Once added, just type `pa` to launch your agent.

---

## Opening your second brain in Obsidian

Your notes live in the `brain/` folder inside this project. To open it:

1. Open Obsidian
2. Click **Open folder as vault**
3. Navigate to `~/personal-agent-framework/brain/`

Any notes Claude creates or edits inside the container are instantly visible in Obsidian, and vice versa.

---

## Alias setup

The alias starts the containers if they're not running, then drops you into Claude Code with your Bonzai key.

Store your Bonzai key in a file so it stays out of your shell config:

```bash
echo "YOUR-BONZAI-KEY-HERE" > ~/.anthropic_api_key
chmod 600 ~/.anthropic_api_key
```

Then add the alias for your shell:

### Fish

Add to `~/.config/fish/config.fish`:

```fish
function pa
    set -l PROJECT_DIR ~/personal-agent-framework
    set -l API_KEY (cat ~/.anthropic_api_key 2>/dev/null)

    if test -z "$API_KEY"
        echo "Error: add your Bonzai key to ~/.anthropic_api_key"
        return 1
    end

    if not docker ps --format "{{.Names}}" | grep -q "^personal-agent\$"
        echo "Starting Personal Agent..."
        docker compose -f $PROJECT_DIR/docker-compose.yml up -d
        sleep 8
    end

    docker exec -it personal-agent /bin/zsh -c "ANTHROPIC_AUTH_TOKEN=$API_KEY claude"
end

alias personal-agent=pa
```

Reload: `source ~/.config/fish/config.fish`

### Zsh / Bash

Add to `~/.zshrc` or `~/.bashrc`:

```bash
pa() {
    local PROJECT_DIR=~/personal-agent-framework
    local API_KEY
    API_KEY=$(cat ~/.anthropic_api_key 2>/dev/null)

    if [ -z "$API_KEY" ]; then
        echo "Error: add your Bonzai key to ~/.anthropic_api_key"
        return 1
    fi

    if ! docker ps --format '{{.Names}}' | grep -q '^personal-agent$'; then
        echo "Starting Personal Agent..."
        docker compose -f "$PROJECT_DIR/docker-compose.yml" up -d
        sleep 8
    fi

    docker exec -it personal-agent /bin/zsh -c "ANTHROPIC_AUTH_TOKEN=$API_KEY claude"
}

alias personal-agent=pa
```

Reload: `source ~/.zshrc`

---

## Project structure

```
personal-agent-framework/
├── brain/                      # Your Obsidian vault — open this in Obsidian
├── docker-compose.yml          # Orchestrates the agent + search containers
├── whitelist.local.csv         # Extra domains/IPs to allow through the firewall
├── .env.example                # Optional: copy to .env to change timezone
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

Create a `.env` file in the project root:

```bash
echo "TZ=America/New_York" > .env
```

Then restart:

```bash
docker compose up -d
```

---

## Useful commands

```bash
# Start containers (also done automatically by the alias)
docker compose up -d

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
