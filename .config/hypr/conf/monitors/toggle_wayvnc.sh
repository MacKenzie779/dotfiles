#!/usr/bin/env bash
set -euo pipefail

FILE="/home/user/.mydotfiles/com.ml4w.dotfiles.stable/.config/hypr/conf/monitors/default.conf"
LINE='monitor = tablet, 1920x1080@120, 1920x0, 1'

if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

# Backup
cp -a "$FILE" "$FILE.bak"

if grep -Fxq "$LINE" "$FILE"; then
  # Remove exact matching line
  tmp="$(mktemp)"
  grep -Fvx -- "$LINE" "$FILE" > "$tmp"
  cat "$tmp" > "$FILE"
  rm -f "$tmp"
  echo "Removed: $LINE"
  hyprctl output remove tablet
  killall wayvnc
  hyprctl reload
else
  # Append (ensure file ends with newline first)
  tail -c1 "$FILE" | read -r _ || echo >> "$FILE"
  printf '%s\n' "$LINE" >> "$FILE"
  echo "Added:   $LINE"
  hyprctl output create headless tablet
  wayvnc -o tablet -f 120 0.0.0.0 5900 & disown
fi
