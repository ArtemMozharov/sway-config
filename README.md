# Sway desktop configuration

Personal Fedora/Sway dotfiles with Waybar, Rofi, Ghostty, GTK styling, and Neovim configuration.

## Requirements

### Fedora packages

Install the applications and command-line tools used by the configs:

```bash
sudo dnf install \
  sway swayidle waybar rofi kanshi \
  grim slurp swappy wl-clipboard cliphist wtype ImageMagick \
  ghostty nautilus firefox \
  nvim tmux vim \
  gtklock wdisplays \
  gnome-system-monitor gnome-disk-utility btop \
  wlogout playerctl brightnessctl \
  nm-connection-editor nm-connection-editor-desktop \
  tuned-ppd bluejay \
  sassc gtk-murrine-engine gnome-themes-extra \
  rsync flatpak git curl gsettings-desktop-schemas \
  fontawesome-6-free-fonts cascadia-code-nf-fonts \
  google-roboto-fonts jetbrains-mono-fonts
```

`tuned-ppd` provides the Power Profiles D-Bus API used by the Waybar power-profile control. Do not install it alongside `power-profiles-daemon`.

The Waybar and Rofi configs use JetBrains Mono for text. Font Awesome 6 supplies standard icons; Cascadia Code NF supplies Nerd Font symbols. Refresh the font cache after installing fonts:

```bash
fc-cache -f
```

### Install separately

These items are not installed by the DNF command above:

- **Obsidian** — install from [Flathub](https://flathub.org/apps/md.obsidian.Obsidian); Sway launches it with `flatpak run md.obsidian.Obsidian`.
- **`autotiling`** — the Sway config calls this tool on startup. Install from [nwg-piotr/autotiling on GitHub](https://github.com/nwg-piotr/autotiling):

  ```bash
  mkdir -p ~/.local/bin
  curl -fsSL https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py \
    -o ~/.local/bin/autotiling
  chmod +x ~/.local/bin/autotiling
  ```

  Make sure `~/.local/bin` is on your `PATH`.
- **`nm-sidebar`** — the Waybar network button uses [Relz/network-manager-sidebar](https://github.com/Relz/network-manager-sidebar). Install its Fedora RPM from the project's Releases page.
- **`bm-sidebar`** — the Waybar Bluetooth button uses this GTK Bluetooth sidebar. See its [upstream package page](https://atoll.seafoam-labs.org/package/bm-sidebar) for source and installation options.
- **pwvucontrol** — install from Flathub. Waybar launches it with `flatpak run com.saivert.pwvucontrol`.

## Install the dotfiles

Run these commands from the root of this repository. They copy the configs into your home directory and create the wallpaper and screenshot folders:

```bash
mkdir -p ~/Pictures/Screenshots ~/Pictures/Wallpapers
cp current.png ~/Pictures/Wallpapers/current.png

mkdir -p ~/.config
rsync -av .sway/ ~/.sway/
rsync -av .config/rofi/ ~/.config/rofi/
rsync -av .config/waybar/ ~/.config/waybar/
rsync -av .config/wlogout/ ~/.config/wlogout/
rsync -av .config/theme/ ~/.config/theme/
rsync -av .config/ghostty/ ~/.config/ghostty/
rsync -av .config/gtk-3.0/ ~/.config/gtk-3.0/
rsync -av .config/tmux/ ~/.config/tmux/
rsync -av .config/kanshi/ ~/.config/kanshi/
rsync -av .config/gtklock/ ~/.config/gtklock/
rsync -av .config/nvim/ ~/.config/nvim/
cp .vimrc ~/.vimrc
```

Waybar's wallpaper button cycles through image files in `~/Pictures/Wallpapers` (left-click next, right-click previous). Sway remembers the selected image across reloads, and each selection generates a blurred gtklock background with a 70% Tokyo Night base-color overlay. ImageMagick is used for that generated lockscreen image.

## Install the GTK theme

The configs select the Tokyo Night GTK theme. Install it once from [Fausto-Korpsvart/Tokyonight-GTK-Theme](https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme):

```bash
git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme.git /tmp/Tokyonight-GTK-Theme
cd /tmp/Tokyonight-GTK-Theme/themes
./install.sh --color dark --libadwaita
```

The upstream repository is archived. The `--libadwaita` option also installs GTK 4 theme files for Nautilus and other GTK 4 apps. Restart those apps after installation. Flatpak apps may need the filesystem override described in the theme's [Flatpak compatibility notes](https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme#flatpak-compatibility).

## Start Sway

Log into a Sway session. To apply later config changes, reload Sway with `Mod+Shift+r`.

Waybar and wlogout use the shared Tokyo Night palette from `.config/theme/tokyonight.css`; Rofi, Sway, Ghostty, and tmux use matching colors in their native config formats. Neovim installs its plugins on first launch. Waybar's clock toggles between transparent and solid bar backgrounds when double-clicked.

The Waybar network icon opens `nm-sidebar`; right-click opens `nm-connection-editor`. The Bluetooth icon opens `bm-sidebar`; right-click opens `bluejay`. Clicking the sound icon, volume, or microphone launches pwvucontrol through Flatpak; the sound icon reflects output level and mute state. The power button and Super+Escape open the Tokyo Night wlogout menu, with lock, logout, suspend, hibernate, reboot, and shutdown actions, using the layout and stylesheet in `~/.config/wlogout`. Other controls include media playback, brightness, power profiles, battery, keyboard layout, and an idle inhibitor. Clicking CPU, memory, or temperature opens GNOME System Monitor.

Sway locks after five idle minutes, turns off displays after ten minutes, and locks before sleep. The keyboard indicator follows the active layout (`DE`, `US`, `UKR`, or `RU`). 

If Waybar does not appear, launch it from a terminal inside Sway to inspect startup errors:

```bash
~/.config/waybar/start.sh
```
