#!/usr/bin/env bash
set -euo pipefail

inputs="$(swaymsg -t get_inputs -r 2>/dev/null || printf '[]')"
python3 -c '
import json
import sys

try:
    inputs = json.load(sys.stdin)
except (json.JSONDecodeError, TypeError):
    inputs = []

layout = next(
    (item.get("xkb_active_layout_name", "") for item in inputs
     if item.get("type") == "keyboard" and item.get("xkb_active_layout_name")),
    "",
)
name = layout.casefold()
if "german" in name or "deutsch" in name:
    short = "DE"
elif "english" in name and ("us" in name or "american" in name or "united states" in name):
    short = "US"
elif "ukrain" in name or "україн" in name:
    short = "UKR"
elif "russian" in name or "русск" in name:
    short = "RU"
else:
    short = layout[:4].upper() if layout else "??"

print(json.dumps({"text": short, "tooltip": layout or "Sway keyboard layout unavailable"}))
' <<< "$inputs"
