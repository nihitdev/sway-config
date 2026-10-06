#!/usr/bin/env bash
set -euo pipefail

uid="$(id -u)"

start_if_missing() {
    local name="$1"
    shift
    pgrep -u "$uid" -x "$name" >/dev/null || { "$@" >/dev/null 2>&1 & }
}

swayidle_running=false
while IFS= read -r pid; do
    [[ -r "/proc/$pid/environ" ]] || continue
    if tr '\0' '\n' < "/proc/$pid/environ" 2>/dev/null | grep -Fxq "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"; then
        swayidle_running=true
    fi
done < <(pgrep -u "$uid" -x swayidle || true)

if [[ "$swayidle_running" == false ]]; then
    swayidle -w \
        timeout 300 "$HOME/.config/sway/scripts/lock.sh" \
        timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
        timeout 1800 'systemctl suspend' \
        before-sleep "$HOME/.config/sway/scripts/lock.sh" >/dev/null 2>&1 &
fi

"$HOME/.config/sway/scripts/start-wallpaper.sh"

for type in text image; do
    if ! systemctl --user is-active --quiet cliphist.service &&
        ! pgrep -u "$uid" -f "[w]l-paste --type $type --watch cliphist store" >/dev/null; then
        wl-paste --type "$type" --watch cliphist store >/dev/null 2>&1 &
    fi
done

start_if_missing nm-applet nm-applet
pgrep -u "$uid" -f "$HOME/.local/bin/[b]attery-guardian" >/dev/null || { "$HOME/.local/bin/battery-guardian" >/dev/null 2>&1 & }

if ! systemctl --user is-active --quiet swaync.service && ! pgrep -u "$uid" -x swaync >/dev/null; then
    swaync >/dev/null 2>&1 &
fi

waybar_config="$HOME/.config/sway/waybar.jsonc"
waybar_style="$HOME/.config/sway/waybar.css"
found=false
while IFS= read -r pid; do
    [[ -r "/proc/$pid/cmdline" && -r "/proc/$pid/environ" ]] || continue
    if tr '\0' '\n' < "/proc/$pid/environ" 2>/dev/null | grep -Fxq "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"; then
        if tr '\0' ' ' < "/proc/$pid/cmdline" | grep -Fq -- "$waybar_config"; then
            found=true
        else
            kill "$pid" 2>/dev/null || true
        fi
    fi
done < <(pgrep -u "$uid" -x waybar || true)

if [[ "$found" == false ]]; then
    waybar -c "$waybar_config" -s "$waybar_style" >/dev/null 2>&1 &
fi
