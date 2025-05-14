#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <playlist_url> [output.mp4]"
  exit 1
fi

URL="$1"

# 1. extract the token
JWT=$(printf '%s' "$URL" | sed -n 's/.*[?&]jwt=\([^&]*\).*/\1/p')
if [ -z "$JWT" ]; then
  echo "Error: no jwt token found in URL." >&2
  exit 1
fi

# 2. rebuild playlist URL (strip any extra params)
BASE_PATH=$(printf '%s' "$URL" | sed 's/[?&]jwt=.*//')
PLAYLIST_URL="${BASE_PATH}?jwt=${JWT}"

# 3. extract a title from the URL path
#    e.g. /…/grnvs_2021_04_19_10_00COMB.mp4/playlist.m3u8 → grnvs_2021_04_19_10_00COMB
PATH_NO_QUERY="${BASE_PATH#*://*/}"     # drop protocol+host
DIR_PATH=$(dirname "$PATH_NO_QUERY")    # .../grnvs_...mp4
TITLE_WITH_EXT=$(basename "$DIR_PATH")  # grnvs_...mp4
TITLE="${TITLE_WITH_EXT%.mp4}"          # strip .mp4
DEFAULT_OUTPUT="${TITLE}.mp4"

# 4. allow overriding the output filename
OUTPUT="${2:-$DEFAULT_OUTPUT}"

echo "Downloading \"$TITLE\" → \"$OUTPUT\" …"

# 5. run ffmpeg
ffmpeg \
  -threads 8 \
  -allowed_extensions ALL \
  -protocol_whitelist file,http,https,tcp,tls,crypto \
  -headers "Authorization: Bearer $JWT\r\nUser-Agent: Mozilla/5.0\r\n" \
  -i "$PLAYLIST_URL" \
  -c copy \
  "$OUTPUT"