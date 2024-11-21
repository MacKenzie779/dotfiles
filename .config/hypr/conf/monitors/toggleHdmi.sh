#!/bin/bash

FILE="/home/user/dotfiles/.config/hypr/conf/monitors/default.conf"
TARGET="7"

# Check if the file exists
if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' does not exist."
    exit 1
fi

# Toggle the comment on line 7

# Check if line 7 is commented
if grep -q "^# " <(sed -n '7p' "$FILE"); then
    # If line 7 is commented, uncomment it
    sed -i '7s/^# //' "$FILE"
else
    # If line 7 is not commented, comment it
    sed -i '7s/^/# /' "$FILE"
fi

echo "Toggled comment on line 7 in '$FILE'."
