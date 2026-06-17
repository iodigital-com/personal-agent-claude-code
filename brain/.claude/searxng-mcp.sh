#!/bin/sh
# Wrapper: picks container vs host paths and URL automatically
if [ -f "/usr/local/bin/searxng-mcp.js" ]; then
  exec node /usr/local/bin/searxng-mcp.js
else
  SEARXNG_URL="http://localhost:9080" exec node /Users/carsten.delafonteijne/webserver/personal-agent-framework/devcontainer/searxng-mcp.js
fi
