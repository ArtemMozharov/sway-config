#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
state_file="$state_dir/waybar-theme"
mkdir -p "$state_dir"

if [[ -f "$state_file" ]] && [[ "$(cat "$state_file")" == "solid" ]]; then
    printf 'transparent\n' > "$state_file"
else
    printf 'solid\n' > "$state_file"
fi

pkill -x waybar 2>/dev/null || true
style="$config_dir/style.css"
if [[ "$(cat "$state_file")" == "solid" ]]; then
    style="$config_dir/style-background.css"
fi
waybar --config "$config_dir/config" --style "$style" >/dev/null 2>&1 &
