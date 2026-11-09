## Prerequisites

Run the following and also Obsidian and disktree should be installed
```bash
mkdir -p ~/Pictures/Screenshots
cp secluded-grove-pixel.png $HOME/Pictures/Wallpapers/secluded-grove-pixel.png
sudo dnf install grim slurp swappy wl-clipboard cliphist waybar kanshi nvim tmux vim wdisplays ghostty nautilus firefox gtklock swayidle cargo gnome-system-monitor gnome-disk-utility btop fontawesome-6-free-fonts cascadia-code-nf-fonts google-roboto-fonts pavucontrol nm-connection-editor nm-connection-editor-desktop tuned-ppd playerctl brightnessctl
sudo dnf install sassc gtk-murrine-engine gnome-themes-extra

#add autotiling that is applied to workspaces 1, 3 and 5
mkdir -p ~/.local/bin ~/.config/sway
curl -fsSL https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py \
  -o ~/.local/bin/autotiling
chmod +x ~/.local/bin/autotiling
```



## Apply the configs from this repository to your home directory:

```bash
rsync -av .sway/ ~/.sway/
rsync -av .config/rofi/ ~/.config/rofi/
rsync -av .config/waybar/ ~/.config/waybar/
rsync -av .config/theme/ ~/.config/theme/
rsync -av .config/ghostty/ ~/.config/ghostty/
rsync -av .config/gtk-3.0/ ~/.config/gtk-3.0/
rsync -av .config/tmux/ ~/.config/tmux/
rsync -av .config/kanshi/ ~/.config/kanshi/
rsync -av .config/gtklock/ ~/.config/gtklock/
rsync -av .config/nautilus/ ~/.config/nautilus/
rsync -av .config/nvim/ ~/.config/nvim/
rsync -av .vimrc ~/.vimrc
```

After updating the configs, reload Sway with `Mod+Shift+c`. Waybar is already included in the package command above; the font packages provide its icons and Roboto text, while `pavucontrol` is opened by clicking the volume module. Double-click the clock in Waybar to switch between transparent and solid bar backgrounds. Waybar exposes this action on modules, so the clock is the bar's double-click target.

Install the upstream GTK theme once to apply it to GTK apps, including Nautilus. The repository was archived, and its documented installer accepts these options:

```bash
git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme.git /tmp/Tokyonight-GTK-Theme
cd /tmp/Tokyonight-GTK-Theme/themes
./install.sh --color dark --libadwaita
```

The Sway config sets the installed GTK theme and dark preference on startup. The upstream `--libadwaita` option installs GTK 4 theme files for Nautilus and other GTK 4 apps. Restart those apps after installation. Flatpak apps may need the user filesystem override documented in the [upstream theme README](https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme#flatpak-compatibility).

`.config/theme/tokyonight.css` is the shared desktop palette. Waybar imports it directly; Rofi, Sway, Ghostty and tmux use the same Tokyo Night values in their native config formats. Neovim uses `folke/tokyonight.nvim` in its `night` style.

`nm-connection-editor` is the NetworkManager GUI. Its `nm-connection-editor-desktop` package provides the launcher entry, so it appears in Rofi's `drun` app list. Waybar shows only a connection icon; left-click the network module to reveal the Wi-Fi name, and right-click or double-click it to open the connection editor.

Waybar also includes media controls (`playerctl`), a combined CPU/RAM/temperature widget that opens GNOME System Monitor when clicked, backlight, lock-key state, an idle inhibitor (empty cup when inactive, full cup while idle is inhibited), a scratchpad indicator, and a power menu. Sway locks with `gtklock` after five idle minutes, turns displays off after ten minutes, and locks before sleep. The wallpaper is selected by the hardcoded `output * bg ...` line in `.sway/config`. The keyboard indicator shows `DE`, `US`, `UKR`, or `RU` based on the active Sway layout. The second battery indicator assumes a battery named `BAT2`; remove `battery#bat2` from the Waybar module list if your device has no `BAT2`.

The power-profile button cycles Balanced → Eco (`power-saver`) → Full power (`performance`) through the Power Profiles D-Bus API. Fedora's `tuned-ppd` provides this API and conflicts with the separate `power-profiles-daemon` package, so don't install both. The button skips profiles that the provider rejects. The power menu provides suspend, hibernate, shut down, and reboot.

The Waybar font dependencies are Font Awesome 6 for the standard icons, Cascadia Code NF for Nerd Font/Material Design symbols, and Roboto for the bar text. Install them separately with:

```bash
sudo dnf install fontawesome-6-free-fonts cascadia-code-nf-fonts google-roboto-fonts
fc-cache -f
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

If the bar still does not appear, start it from a terminal inside Sway to see startup errors:

```bash
~/.config/waybar/start.sh
```

## Update this repository from the configs in your home directory:

```bash
rsync -av ~/.sway/ .sway/
rsync -av ~/.config/rofi/ .config/rofi/
rsync -av ~/.config/waybar/ .config/waybar/
rsync -av ~/.config/theme/ .config/theme/
rsync -av ~/.config/ghostty/ .config/ghostty/
rsync -av ~/.config/gtk-3.0/ .config/gtk-3.0/
rsync -av ~/.config/tmux/ .config/tmux/
rsync -av ~/.config/kanshi/ .config/kanshi/
rsync -av ~/.config/gtklock/ .config/gtklock/
rsync -av ~/.config/nautilus/ .config/nautilus/
rsync -av ~/.config/nvim/ .config/nvim/
rsync -av ~/.vimrc .vimrc
```
