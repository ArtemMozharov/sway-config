#!/usr/bin/env python3
import json
import subprocess

result = subprocess.run(
    ["playerctl", "metadata", "--format", "{{playerName}}\t{{artist}}\t{{title}}"],
    check=False,
    capture_output=True,
    text=True,
)
fields = result.stdout.strip().split("\t", 2)
if result.returncode != 0 or len(fields) < 3:
    print(json.dumps({"text": "", "alt": "default", "tooltip": "No media player"}))
else:
    player, artist, title = fields
    track = " - ".join(part for part in (artist, title) if part) or "Playing"
    print(json.dumps({"text": track, "alt": player.casefold(), "tooltip": f"{player}: {track}"}))
