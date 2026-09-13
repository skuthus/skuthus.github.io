#!/usr/bin/env bash
#   curl -fsSL https://skuthus.github.io/e2e | bash
# After Omarchy first login, copy ~/omarchy-mac-e2e
# Source: https://github.com/skuthus/omarchy-mac-e2e-test-capture
set -u

urls=(
  "https://raw.githubusercontent.com/skuthus/omarchy-mac-e2e-test-capture/main/omarchy-mac-e2e-capture"
  "https://cdn.jsdelivr.net/gh/skuthus/omarchy-mac-e2e-test-capture@main/omarchy-mac-e2e-capture"
  "https://cdn.jsdelivr.net/gh/skuthus/omarchy-mac-e2e-test-capture@v1.2.0/omarchy-mac-e2e-capture"
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
  echo "e2e: could not download the capture script" >&2
  echo "try: curl -fsSL --doh-url https://1.1.1.1/dns-query https://skuthus.github.io/e2e | bash" >&2
  exit 1
fi

exec bash "$tmp" "$@"
