<div align="center">

# ARCHNEMESIS · Sway

**A familiar desktop, built around Sway’s split-tree workflow.**

Rosé Pine colors · compact gaps · Kitty · Helium · Dolphin · Rofi · Waybar

<img src="screenshots/layout-split.png" alt="ARCHNEMESIS Sway desktop with its split layout and Waybar" width="100%">

</div>

---

## Install

Clone the repository and run the installer:

```sh
git clone git@github.com:nihitdev/sway-config.git ~/Projects/sway-config
cd ~/Projects/sway-config
./install.sh
```

The installer checks and offers to install missing Arch packages, then copies the Sway files into `~/.config/sway`. It asks before proceeding, does not make backups, and leaves an existing `current-wallpaper` choice intact. Use `./install.sh --check` to check requirements without changing anything. The optional `--yes` flag skips the install confirmation.

Helium is installed through `yay` or `paru` when available; without either helper, install it separately. The setup also expects the existing Rofi themes and launcher scripts, Waybar art/TUI helpers, Hyprland screenshot script, Hyprlock template, and battery-guardian helper. The installer reports missing shared files and does not replace them.

Then select Sway from your display manager. The installer does not change your login manager or other compositor/application configs.

---

## See Sway’s layouts

Press **Super+L** to cycle the focused container through horizontal split, vertical split, tabbed, and stacked. The Waybar label shows the current container layout.

<details>
<summary>Tabbed layout</summary>
<br>
<img src="screenshots/layout-tabbed.png" alt="Sway tabbed container with the active layout shown in Waybar" width="100%">
</details>

<details>
<summary>Stacked layout</summary>
<br>
<img src="screenshots/layout-stacking.png" alt="Sway stacked container with the active layout shown in Waybar" width="100%">
</details>

<details>
<summary>Neovim start screen</summary>
<br>
<img src="screenshots/neovim-start.png" alt="Kitty running Neovim without opening a file" width="100%">
</details>

---

## Daily controls

| Keys | Action |
| --- | --- |
| Super+Return / B / E / Space | Kitty / Helium / Dolphin / Rofi launcher |
| Super+G / N | Kdenlive / Kitty with Neovim |
| Super+W | Close focused window |
| Super+H/J/K and arrows | Directional focus |
| Super+L | Cycle Sway layouts |
| Super+1…0 | Switch workspaces 1–10 |
| Super+Shift+1…0 | Move focused container to a workspace |
| Super+S / Super+Shift+S | Show scratchpad / send container to scratchpad |
| Super+V | Rofi clipboard history |
| Alt+Z or Print / Shift+Print | Region / full screenshot |
| Super+Alt+Space / Super+Alt+L | Wallpaper picker / lock |
| Volume, brightness, media keys | `wpctl`, `brightnessctl`, `playerctl` |

---

## Layout

```text
config                 Sway entry point
modules/               bindings, input, appearance, apps, startup
scripts/               layout label, wallpaper, lock, power, startup
waybar.jsonc           Sway-specific modules
waybar.css             Rosé Pine styling
screenshots/            Desktop and workflow previews
wallpapers/default.png  Bundled first-run wallpaper
install.sh              Arch package check and Sway config installer
```

The Waybar workspace buttons show the five persistent workspaces. Sway itself uses a split tree: **Super+L** changes the focused container’s layout rather than switching between compositor-wide layout engines.

---

## Wallpaper credit

The bundled default is `satellite.png` from [CozyPixels](https://github.com/SleepyCatHey/CozyPixels), under its included [MIT license](wallpapers/COZYPIXELS-LICENSE). The wallpaper picker uses the existing CozyPixels folder when present and falls back to the bundled wallpaper directory.

<details>
<summary>Preview the bundled wallpaper</summary>
<br>
<img src="wallpapers/default.png" alt="Bundled dark Catppuccin satellite wallpaper" width="100%">
</details>

This config reuses Kitty, Helium, Dolphin, Rofi, Waybar, SwayNC, and cliphist. The screenshot and lock scripts use shared helpers from `~/.config/hypr/`; they are not copied here. The installer reports these shared requirements and leaves them unchanged.

Sway provides square window borders and no compositor blur or animated transitions. The bar and its controls use rounded styling; window gaps, borders, and colors use Sway’s native options.
