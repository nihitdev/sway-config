#!/usr/bin/env bash
set -euo pipefail

for pid in $(pgrep -u "$(id -u)" -x swaybg || true); do
    if tr '\0' '\n' < "/proc/$pid/environ" 2>/dev/null | grep -Fxq "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"; then
        exit 0
    fi
done

wall="$HOME/.config/sway/current-wallpaper"
[[ -f "$wall" ]] || wall="$HOME/.config/hypr/current-wallpaper"
[[ -f "$wall" ]] || wall="$HOME/.config/mango/wallpapers/default.png"
[[ -f "$wall" ]] || exit 0

swaybg -i "$wall" -m fill -c 191724 >/dev/null 2>&1 &
