#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Load .env variables into environment
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

docker compose up -d

if [ -n "$ANTHROPIC_AUTH_TOKEN" ]; then
  docker compose exec \
    -e ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN" \
    claude-agent \
    zsh -c "ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_AUTH_TOKEN claude --dangerously-skip-permissions; exec zsh"
else
  echo "Warning: ANTHROPIC_AUTH_TOKEN not set in .env — launching shell without starting Claude."
  docker compose exec claude-agent zsh
fi
