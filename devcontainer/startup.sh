#!/bin/zsh
set -e

# Run firewall as root (node user has passwordless sudo for this script)
echo "Initializing firewall..."
sudo /usr/local/bin/init-firewall.sh

# Initialize Claude Code settings on fresh volume
SETTINGS_FILE="${CLAUDE_CONFIG_DIR:-/home/node/.claude}/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  cp /usr/local/share/claude-default-settings.json "$SETTINGS_FILE"
  echo "Initialized Claude Code settings"
fi

echo "Personal Agent ready. Use: docker exec -it personal-agent /bin/zsh"

# Keep container alive
exec sleep infinity
