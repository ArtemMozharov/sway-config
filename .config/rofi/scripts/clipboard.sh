#!/usr/bin/env bash

set -o pipefail

case "${ROFI_RETV:-0}" in
    0)
        printf '\0prompt\x1fClipboard\n'
        printf '\0no-custom\x1ftrue\n'
        cliphist list
        ;;
    1)
        printf '%s\n' "$1" | cliphist decode | wl-copy
        ;;
esac
