#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# 1. Extract Docker DNS info BEFORE any flushing
DOCKER_DNS_RULES=$(iptables-save -t nat | grep "127\.0\.0\.11" || true)

# Flush existing rules and delete existing ipsets
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
ipset destroy allowed-domains 2>/dev/null || true

# 2. Selectively restore ONLY internal Docker DNS resolution
if [ -n "$DOCKER_DNS_RULES" ]; then
  echo "Restoring Docker DNS rules..."
  iptables -t nat -N DOCKER_OUTPUT 2>/dev/null || true
  iptables -t nat -N DOCKER_POSTROUTING 2>/dev/null || true
  echo "$DOCKER_DNS_RULES" | xargs -L 1 iptables -t nat
else
  echo "No Docker DNS rules to restore"
fi

# Allow outbound DNS (UDP 53) and inbound DNS responses
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT  -p udp --sport 53 -j ACCEPT

# Allow outbound SSH and inbound SSH responses
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT  -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Allow localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Create ipset with CIDR support
ipset create allowed-domains hash:net

# GitHub IP ranges — fetched from API, cached between restarts, with hardcoded fallback.
# Priority: 1) live API  2) cache from last successful fetch  3) hardcoded stable CIDRs
GITHUB_CACHE="/home/node/.claude/github-ip-ranges.cache"

# GitHub's stable owned CIDR blocks (rarely change, used as last resort)
GITHUB_FALLBACK_CIDRS=(
  "192.30.252.0/22"
  "185.199.108.0/22"
  "140.82.112.0/20"
  "143.55.64.0/20"
)

apply_github_cache() {
  while IFS= read -r entry; do
    [ -z "$entry" ] && continue
    ipset add -exist allowed-domains "$entry"
  done < "$GITHUB_CACHE"
}

echo "Fetching GitHub IP ranges..."
gh_ranges=$(curl -s --connect-timeout 10 --max-time 30 \
  -H "User-Agent: personal-agent-framework/1.0" \
  https://api.github.com/meta 2>/dev/null || true)

if [ -n "$gh_ranges" ] && echo "$gh_ranges" | jq -e '.web and .api and .git' >/dev/null 2>&1; then
  echo "Processing GitHub IPs from API..."
  echo "$gh_ranges" | jq -r '(.web + .api + .git)[]' | aggregate -q > "$GITHUB_CACHE"
  apply_github_cache
elif [ -f "$GITHUB_CACHE" ] && [ -s "$GITHUB_CACHE" ]; then
  echo "WARNING: GitHub API unavailable — using cached ranges from previous run."
  apply_github_cache
else
  echo "WARNING: GitHub API unavailable and no cache found — using hardcoded fallback CIDRs."
  printf '%s\n' "${GITHUB_FALLBACK_CIDRS[@]}" > "$GITHUB_CACHE"
  for cidr in "${GITHUB_FALLBACK_CIDRS[@]}"; do
    echo "  Adding $cidr"
    ipset add -exist allowed-domains "$cidr"
  done
fi

# Resolve and add built-in allowed domains
for domain in \
  "registry.npmjs.org" \
  "api-v2.bonzai.iodigital.com" \
  "sentry.io" \
  "statsig.com" \
  "marketplace.visualstudio.com" \
  "vscode.blob.core.windows.net" \
  "update.code.visualstudio.com"; do

  echo "Resolving $domain..."
  ips=$(dig +noall +answer A "$domain" | awk '$4 == "A" {print $5}')
  if [ -z "$ips" ]; then
    echo "ERROR: Failed to resolve $domain"; exit 1
  fi
  while read -r ip; do
    if [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
      echo "ERROR: Invalid IP from DNS for $domain: $ip"; exit 1
    fi
    echo "Adding $ip for $domain"
    ipset add -exist allowed-domains "$ip"
  done < <(echo "$ips")
done

# Load local whitelist if it exists
WHITELIST_FILE="/usr/local/share/whitelist.local.csv"
if [ -f "$WHITELIST_FILE" ]; then
  echo "Loading local whitelist from $WHITELIST_FILE..."
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue

    # Take first column if CSV, trim whitespace
    entry="${line%%,*}"
    entry="${entry//[[:space:]]/}"

    if [[ -z "$entry" ]]; then
      continue
    fi

    if [[ "$entry" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
      # Direct IP address or CIDR range
      echo "Adding IP/CIDR from whitelist: $entry"
      ipset add -exist allowed-domains "$entry" 2>/dev/null || echo "  (already in set, skipping)"
    else
      # Domain name — resolve to IPs
      echo "Resolving domain from whitelist: $entry..."
      ips=$(dig +noall +answer A "$entry" | awk '$4 == "A" {print $5}')
      if [ -z "$ips" ]; then
        echo "WARNING: Failed to resolve $entry — skipping"
      else
        while read -r ip; do
          if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo "  Adding $ip for $entry"
            ipset add -exist allowed-domains "$ip" 2>/dev/null || true
          fi
        done < <(echo "$ips")
      fi
    fi
  done < "$WHITELIST_FILE"
else
  echo "No local whitelist found at $WHITELIST_FILE (skipping)"
fi

# Get host IP from default route
HOST_IP=$(ip route | grep default | cut -d" " -f3)
if [ -z "$HOST_IP" ]; then
  echo "ERROR: Failed to detect host IP"; exit 1
fi
HOST_NETWORK=$(echo "$HOST_IP" | sed "s/\.[0-9]*$/.0\/24/")
echo "Host network detected as: $HOST_NETWORK"

# Allow host network (covers Docker internal network — includes SearXNG container)
iptables -A INPUT  -s "$HOST_NETWORK" -j ACCEPT
iptables -A OUTPUT -d "$HOST_NETWORK" -j ACCEPT

# Set default policies to DROP
iptables -P INPUT   DROP
iptables -P FORWARD DROP
iptables -P OUTPUT  DROP

# Allow established/related connections
iptables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow outbound to whitelisted IPs only
iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT

# Explicitly REJECT everything else
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

echo "Firewall configuration complete"

# Verify: must NOT reach example.com
if curl --connect-timeout 5 https://example.com >/dev/null 2>&1; then
  echo "ERROR: Firewall verification failed - was able to reach https://example.com"; exit 1
else
  echo "Firewall verification passed - unable to reach https://example.com as expected"
fi

# Verify: MUST reach api.github.com
# Re-resolve right before the check — DNS round-robin may return a different IP than
# what was added during setup, so we add the current answer to the set first.
while IFS= read -r ip; do
  [ -n "$ip" ] && ipset add -exist allowed-domains "$ip"
done < <(dig +noall +answer A api.github.com | awk '$4=="A"{print $5}')

if ! curl --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
  echo "ERROR: Firewall verification failed - unable to reach https://api.github.com"; exit 1
else
  echo "Firewall verification passed - able to reach https://api.github.com as expected"
fi
