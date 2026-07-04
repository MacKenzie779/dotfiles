#!/usr/bin/env bash
# Waybar module: % of Claude Code's current 5h session usage limit used.
# Reads the OAuth token Claude Code already stores locally and hits the same
# account-usage metadata endpoint the CLI itself uses (GET, no token cost).

set -uo pipefail

CREDS="$HOME/.claude/.credentials.json"
CACHE="$HOME/.cache/waybar-claude-usage.json"
ICON=""

fallback() {
  if [[ -f "$CACHE" ]]; then
    cat "$CACHE"
  else
    jq -nc --arg icon "$ICON" '{text: ($icon + "  ?"), tooltip: "Claude usage: unavailable", class: "error"}'
  fi
  exit 0
}

token=$(jq -r '.claudeAiOauth.accessToken // empty' "$CREDS" 2>/dev/null)
[[ -n "$token" ]] || fallback

resp=$(curl -s -m 5 \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -H "anthropic-beta: oauth-2025-04-20" \
  "https://api.anthropic.com/api/oauth/usage")

jq -e '.five_hour.utilization' >/dev/null 2>&1 <<<"$resp" || fallback

session_pct=$(jq -r '.five_hour.utilization // 0 | floor' <<<"$resp")
session_reset=$(jq -r '.five_hour.resets_at // empty' <<<"$resp")
weekly_pct=$(jq -r '.seven_day.utilization // 0 | floor' <<<"$resp")
severity=$(jq -r '[.limits[]? | select(.kind=="session") | .severity][0] // "normal"' <<<"$resp")

case "$severity" in
  warning) class="warning" ;;
  critical|rejected|error) class="critical" ;;
  *) class="normal" ;;
esac

reset_local="$session_reset"
if [[ -n "$session_reset" ]]; then
  reset_local=$(date -d "$session_reset" "+%H:%M" 2>/dev/null || echo "$session_reset")
fi

text="${ICON}  ${session_pct}%"
tooltip="Session limit: ${session_pct}% used (resets ${reset_local})
Weekly limit: ${weekly_pct}% used"

out=$(jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
  '{text: $text, tooltip: $tooltip, class: $class}')

echo "$out" | tee "$CACHE"
