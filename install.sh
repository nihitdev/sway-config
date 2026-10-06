#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
target_dir="$HOME/.config/sway"
auto_yes=false
check_only=false

usage() {
    cat <<'EOF'
Usage: ./install.sh [--check] [--yes]

  --check  Report package and shared-file requirements without changing anything.
  --yes    Skip the installer confirmation prompts (pacman still uses sudo).
  -h       Show this help.
EOF
}

while (($#)); do
    case "$1" in
        --check) check_only=true ;;
        --yes) auto_yes=true ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

if ! command -v pacman >/dev/null 2>&1; then
    printf 'This installer currently supports Arch Linux and pacman.\n' >&2
    exit 1
fi

# These packages provide the applications and runtime commands used directly
# by this Sway setup and its bundled Waybar controls.
repo_packages=(
    sway waybar kitty dolphin rofi kdenlive neovim
    wl-clipboard cliphist grim slurp swaybg swayidle swaync hyprlock
    network-manager-applet polkit-gnome brightnessctl playerctl
    pipewire pipewire-pulse wireplumber libnotify jq procps-ng
    networkmanager btop pulsemixer bluetui cava calcurse yazi python
)

missing_repo=()
unavailable_repo=()
for package in "${repo_packages[@]}"; do
    if pacman -Q "$package" >/dev/null 2>&1; then
        continue
    elif pacman -Si "$package" >/dev/null 2>&1; then
        missing_repo+=("$package")
    else
        unavailable_repo+=("$package")
    fi
done

missing_aur=()
if ! pacman -Q helium-browser-bin >/dev/null 2>&1; then
    if command -v yay >/dev/null 2>&1; then
        missing_aur+=(helium-browser-bin)
    elif command -v paru >/dev/null 2>&1; then
        missing_aur+=(helium-browser-bin)
    fi
fi

missing_shared=()
check_shared() {
    [[ -e "$1" ]] || missing_shared+=("$1")
}
check_shared "$HOME/.config/rofi/launchers/launcher.sh"
check_shared "$HOME/.config/rofi/clipboard/clipboard.sh"
check_shared "$HOME/.config/rofi/wallpaper/wallpaper.rasi"
check_shared "$HOME/.config/rofi/powermenu/type-2/style-5.rasi"
check_shared "$HOME/.config/hypr/scripts/screenshot.sh"
check_shared "$HOME/.config/hyprlock/hyprlock.template.conf"
check_shared "$HOME/.config/waybar/scripts/skull.sh"
check_shared "$HOME/.config/waybar/scripts/catloop.sh"
check_shared "$HOME/.config/waybar/scripts/art-animation.py"
check_shared "$HOME/.config/waybar/scripts/notifications.sh"
check_shared "$HOME/.config/waybar/scripts/tui.sh"
check_shared "$HOME/.local/bin/battery-guardian"

printf 'Sway setup package check:\n'
if ((${#missing_repo[@]})); then
    printf '  Missing from official repositories: %s\n' "${missing_repo[*]}"
else
    printf '  All listed official packages are installed.\n'
fi
if ((${#unavailable_repo[@]})); then
    printf '  Not found in configured repositories: %s\n' "${unavailable_repo[*]}"
fi
if ((${#missing_aur[@]})); then
    printf '  Missing AUR application: %s\n' "${missing_aur[*]}"
elif ! pacman -Q helium-browser-bin >/dev/null 2>&1; then
    printf '  Missing AUR application: helium-browser-bin (install with yay or paru).\n'
fi
if ((${#missing_shared[@]})); then
    printf '  External files not found (these are not copied or modified):\n'
    printf '    %s\n' "${missing_shared[@]}"
else
    printf '  Shared Rofi, Waybar, screenshot, lock, and helper files are present.\n'
fi

if [[ "$check_only" == true ]]; then
    ((${#unavailable_repo[@]} == 0)) || exit 1
    exit 0
fi

if ((${#unavailable_repo[@]})); then
    printf 'Cannot install: package lookup failed for %s\n' "${unavailable_repo[*]}" >&2
    exit 1
fi

if [[ -e "$target_dir" ]] && [[ ! -d "$target_dir" ]]; then
    printf 'Target exists and is not a directory: %s\n' "$target_dir" >&2
    exit 1
fi

if [[ "$auto_yes" != true ]]; then
    cat <<EOF

This will install missing packages and copy the Sway configuration into:
  $target_dir

Files with matching names in that directory will be replaced. No backup files
will be created. Other compositor and application configurations are untouched.
EOF
    read -r -p 'Continue? [y/N] ' answer
    [[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]] || { echo 'Cancelled.'; exit 0; }
fi

if ((${#missing_repo[@]})); then
    sudo pacman -S --needed -- "${missing_repo[@]}"
fi

if ((${#missing_aur[@]})); then
    if command -v yay >/dev/null 2>&1; then
        yay -S --needed -- "${missing_aur[@]}"
    else
        paru -S --needed -- "${missing_aur[@]}"
    fi
fi

install -d "$target_dir/modules" "$target_dir/scripts" "$target_dir/wallpapers"
install -m 644 "$repo_dir/config" "$target_dir/config"
install -m 644 "$repo_dir/modules/"*.conf "$target_dir/modules/"
install -m 755 "$repo_dir/scripts/"*.sh "$target_dir/scripts/"
install -m 644 "$repo_dir/waybar.jsonc" "$target_dir/waybar.jsonc"
install -m 644 "$repo_dir/waybar.css" "$target_dir/waybar.css"
install -m 644 "$repo_dir/wallpapers/default.png" "$target_dir/wallpapers/default.png"

# Keep a user's selected wallpaper. Set the bundled default only on first install.
if [[ ! -e "$target_dir/current-wallpaper" && ! -L "$target_dir/current-wallpaper" ]]; then
    ln -s wallpapers/default.png "$target_dir/current-wallpaper"
fi

printf '\nSway configuration installed in %s\n' "$target_dir"
printf 'The bundled wallpaper is available at %s/wallpapers/default.png\n' "$target_dir"
printf 'Review the external-file notices above; those shared dependencies were left untouched.\n'
