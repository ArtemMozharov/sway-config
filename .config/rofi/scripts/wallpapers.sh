#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="$HOME/Pictures/Wallpapers"
wallpaper_script="$HOME/.config/waybar/scripts/wallpaper.sh"

if [[ -n "${ROFI_INFO:-}" ]]; then
  exec "$wallpaper_script" --set "$ROFI_INFO"
fi

mapfile -d '' wallpapers < <(
  find "$wallpaper_dir" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) \
    -print0 2>/dev/null | sort -z
)

if ((${#wallpapers[@]} == 0)); then
  printf 'No wallpaper images found in %s\n' "$wallpaper_dir"
  exit 0
fi

for wallpaper in "${wallpapers[@]}"; do
  printf '%s\0info\x1f%s\n' "$(basename -- "$wallpaper")" "$wallpaper"
done
