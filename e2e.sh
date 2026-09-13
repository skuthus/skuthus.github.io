#!/usr/bin/env bash
# Shortlink for the Omarchy Mac E2E capture script.
#   curl -fsSL https://skuthus.github.io/e2e | bash -s -- auto --tester YOU --test-id ISSUE
# Source: https://github.com/skuthus/omarchy-mac-e2e-test-capture
set -u

urls=(
  "https://cdn.jsdelivr.net/gh/skuthus/omarchy-mac-e2e-test-capture@v1.1.1/omarchy-mac-e2e-capture"
  "https://raw.githubusercontent.com/skuthus/omarchy-mac-e2e-test-capture/v1.1.1/omarchy-mac-e2e-capture"
)

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

fetch() {
  local url="$1"
  curl -fsSL --doh-url https://1.1.1.1/dns-query --connect-timeout 15 --max-time 45 "$url" -o "$tmp" \
    && [[ -s "$tmp" ]] && head -1 "$tmp" | grep -q '^#!/'
}

ok=0
for url in "${urls[@]}"; do
  if fetch "$url"; then
    ok=1
    break
  fi
  if curl -fsSL --connect-timeout 15 --max-time 45 "$url" -o "$tmp" \
    && [[ -s "$tmp" ]] && head -1 "$tmp" | grep -q '^#!/'; then
    ok=1
    break
  fi
done

if [[ "$ok" -ne 1 ]]; then
  echo "e2e: could not download omarchy-mac-e2e-capture (DNS or network failed)" >&2
  echo "try: curl -fsSL --doh-url https://1.1.1.1/dns-query https://skuthus.github.io/e2e | bash -s -- $*" >&2
  exit 1
fi

exec bash "$tmp" "$@"
