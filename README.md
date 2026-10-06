# ARCHNEMESIS on Sway

A modular Sway setup built around the same applications and daily controls as the ARCHNEMESIS Hyprland and MangoWC sessions, while keeping Sway's split-tree window model.

---

## What’s here

- `config` — Sway entry point
- `modules/` — appearance, input, applications, startup, and keybindings
- `scripts/` — session helpers for startup, layout status, locking, power, and wallpaper
- `waybar.jsonc` and `waybar.css` — Sway-specific bar and Rosé Pine styling

Sway supports horizontal and vertical splits, tabbed containers, and stacked containers. **Super+L** cycles the focused container through those layouts. The Waybar layout label reads the focused container’s active layout.

---

## Main controls

| Keys | Action |
| --- | --- |
| Super+Return / B / E / Space | Kitty / Helium / Dolphin / Rofi launcher |
| Super+G / N | Kdenlive / Kitty with Neovim |
| Super+W | Close focused window |
| Super+H/J/K and arrows | Move focus |
| Super+L | Cycle Sway layouts |
| Super+1…0 | Switch workspaces 1–10 |
| Super+Shift+1…0 | Move the focused container to a workspace |
| Super+S / Super+Shift+S | Show scratchpad / send container to scratchpad |
| Super+V | Rofi clipboard history |
| Alt+Z or Print / Shift+Print | Region / full screenshot |
| Super+Alt+Space / Super+Alt+L | Wallpaper picker / lock |
| Volume, brightness, media keys | `wpctl`, `brightnessctl`, and `playerctl` |

---

## Install

Copy this directory’s contents into `~/.config/sway/`, then validate the config with:

```sh
sway --validate --config ~/.config/sway/config
```

Select Sway from your display manager to start the session. This repository does not configure the display manager.

---

## Existing dependencies

The config expects the user's existing Kitty, Helium, Dolphin, Rofi, Waybar, SwayNC, cliphist, wallpaper collection, and helper programs. Screenshot and lock helpers reuse files from `~/.config/hypr/`; they are intentionally not copied or modified here. Check the scripts before use if those shared files are not installed.

Sway itself does not provide rounded window corners, blur, or compositor animations. Waybar has rounded styling; window borders and gaps use Sway's native options.
