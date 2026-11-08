#!/usr/bin/env bash
set -euo pipefail

# Fedora's tuned-ppd exports the Power Profiles D-Bus API but does not ship
# powerprofilesctl. Try the legacy and current API names so either provider works.
bus_names=(
    "net.hadess.PowerProfiles|/net/hadess/PowerProfiles|net.hadess.PowerProfiles"
    "org.freedesktop.UPower.PowerProfiles|/org/freedesktop/UPower/PowerProfiles|org.freedesktop.UPower.PowerProfiles"
)
bus=""
object=""
interface=""
current=""
for entry in "${bus_names[@]}"; do
    IFS='|' read -r candidate_bus candidate_object candidate_interface <<< "$entry"
    value="$(busctl --system get-property "$candidate_bus" "$candidate_object" "$candidate_interface" ActiveProfile 2>/dev/null || true)"
    current="$(sed -n 's/^s "\(.*\)"$/\1/p' <<< "$value")"
    if [[ -n "$current" ]]; then
        bus="$candidate_bus"
        object="$candidate_object"
        interface="$candidate_interface"
        break
    fi
done

if [[ -z "$current" ]]; then
    printf '{"text":"Profile unavailable","tooltip":"Power Profiles / tuned-ppd service unavailable","class":"unavailable"}\n'
    exit 0
fi

if [[ "${1:-}" == "--cycle" ]]; then
    profiles=(balanced power-saver performance)
    current_index=0
    for i in "${!profiles[@]}"; do
        [[ "${profiles[$i]}" == "$current" ]] && current_index="$i" && break
    done

    # Try the requested order and skip a profile if the provider does not expose it.
    for offset in 1 2 3; do
        next_index=$(( (current_index + offset) % ${#profiles[@]} ))
        candidate="${profiles[$next_index]}"
        if busctl --system set-property "$bus" "$object" "$interface" ActiveProfile s "$candidate" >/dev/null 2>&1; then
            current="$candidate"
            break
        fi
    done
fi

case "$current" in
    balanced|power-saver|performance)
        value="$(busctl --system get-property "$bus" "$object" "$interface" ActiveProfile 2>/dev/null || true)"
        current="$(sed -n 's/^s "\(.*\)"$/\1/p' <<< "$value")"
        ;;
esac

case "$current" in
    balanced) label=" Balanced"; class="balanced" ;;
    power-saver) label=" Eco"; class="power-saver" ;;
    performance) label=" Full power"; class="performance" ;;
    *) label="Profile unavailable"; class="unavailable" ;;
esac
printf '{"text":"%s","tooltip":"Click to cycle Balanced → Eco → Full power","class":"%s"}\n' "$label" "$class"
