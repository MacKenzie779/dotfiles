#!/usr/bin/env bash
set -euo pipefail

# Usage: ./download_mp3_playlist.sh PLAYLIST_ID
if [ $# -ne 1 ]; then
  echo "Usage: $0 PLAYLIST_ID"
  exit 1
fi

PLAYLIST_ID="$1"
echo "$PLAYLIST_ID"
BASE_URL="https://www.youtube.com/playlist?list=${PLAYLIST_ID}"
echo "$BASE_URL"

yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -o "%(playlist_index)03d - %(title)s.%(ext)s" $BASE_URL
