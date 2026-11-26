#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="$HOME/Pictures/Wallpapers"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/sway-config"
state_file="$state_dir/current-wallpaper"
gtklock_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gtklock"
gtklock_background="$gtklock_dir/background.jpg"

mapfile -d '' wallpapers < <(
  find "$wallpaper_dir" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) \
    -print0 2>/dev/null | sort -z
)

if ((${#wallpapers[@]} == 0)); then
  if [[ "${1:-}" == "--status" ]]; then
    printf 'No wallpapers'
    exit 0
  fi
  printf 'No wallpaper images found in %s\n' "$wallpaper_dir" >&2
  exit 1
fi

read_current() {
  current=""
  if [[ -r "$state_file" ]]; then
    IFS= read -r current < "$state_file" || true
    for wallpaper in "${wallpapers[@]}"; do
      [[ "$wallpaper" == "$current" ]] && return 0
    done
  fi

  current="$wallpaper_dir/current.png"
  for wallpaper in "${wallpapers[@]}"; do
    [[ "$wallpaper" == "$current" ]] && return 0
  done
  current=""
}

case "${1:---status}" in
  --status)
    read_current
    if [[ -n "$current" ]]; then
      basename -- "$current"
    else
      basename -- "${wallpapers[0]}"
    fi
    ;;
  --next|--previous|apply|--set)
    read_current
    current_index=-1
    for i in "${!wallpapers[@]}"; do
      if [[ "${wallpapers[$i]}" == "$current" ]]; then
        current_index=$i
        break
      fi
    done

    if [[ "${1:-}" == "--set" ]]; then
      selected="${2:-}"
      found=false
      for wallpaper in "${wallpapers[@]}"; do
        [[ "$wallpaper" == "$selected" ]] && found=true && break
      done
      if [[ "$found" != true ]]; then
        printf 'Wallpaper is not in %s: %s\n' "$wallpaper_dir" "$selected" >&2
        exit 2
      fi
    elif [[ "${1:-}" == "apply" ]]; then
      if ((current_index < 0)); then
        selected="${wallpapers[0]}"
      else
        selected="$current"
      fi
    elif [[ "${1:-}" == "--previous" ]]; then
      if ((current_index < 0)); then
        selected="${wallpapers[-1]}"
      else
        selected="${wallpapers[$(((current_index - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]}))]}"
      fi
    elif [[ "${1:-}" == "--next" ]]; then
      selected="${wallpapers[$(((current_index + 1) % ${#wallpapers[@]}))]}"
    fi

    mkdir -p "$state_dir" "$gtklock_dir"
    image_tmp=$(mktemp "$gtklock_dir/.background.XXXXXX.jpg")
    state_tmp=$(mktemp "$state_dir/.current-wallpaper.XXXXXX")
    trap 'rm -f "$image_tmp" "$state_tmp"' EXIT

    # Keep the same lockscreen treatment for every wallpaper: strong blur,
    # then a 70% Tokyo Night base overlay.
    magick "$selected" -blur 0x18 \
      \( +clone -fill '#1a1b26' -colorize 100 \) \
      -define compose:args=30,70 -compose blend -composite -quality 90 "$image_tmp"

    escaped=${selected//\\/\\\\}
    escaped=${escaped//\"/\\\"}
    swaymsg -q "output * bg \"$escaped\" fill"
    mv -f -- "$image_tmp" "$gtklock_background"
    printf '%s\n' "$selected" > "$state_tmp"
    mv -f -- "$state_tmp" "$state_file"
    ;;
  *)
    printf 'Usage: %s [--status|--next|--previous|apply|--set IMAGE]\n' "$0" >&2
    exit 2
    ;;
esac
