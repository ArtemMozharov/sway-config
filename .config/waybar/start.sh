#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
state_file="${XDG_STATE_HOME:-$HOME/.local/state}/waybar-theme"
theme="transparent"
if [[ -f "$state_file" ]] && [[ "$(cat "$state_file")" == "solid" ]]; then
    theme="solid"
fi

style="$config_dir/style.css"
if [[ "$theme" == "solid" ]]; then
    style="$config_dir/style-background.css"
fi

waybar --config "$config_dir/config" --style "$style" >/dev/null 2>&1 &
