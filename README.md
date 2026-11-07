Prerequisites:

```bash
mkdir -p ~/Pictures/Screenshots
sudo dnf install grim slurp swappy wl-clipboard cliphist waybar kanshi nvim tmux vim wdisplays foot nautilus

#add autotilingthat is applied to workspaces 1, 3 and 5
mkdir -p ~/.local/bin ~/.config/sway
curl -fsSL https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py \
  -o ~/.local/bin/autotiling
chmod +x ~/.local/bin/autotiling
```

Apply the configs from this repository to your home directory:

```bash
rsync -av .sway/ ~/.sway/
rsync -av .config/rofi/ ~/.config/rofi/
rsync -av .config/tmux/ ~/.config/tmux/
rsync -av .config/kanshi/ ~/.config/kanshi/
rsync -av .config/nautilus/ ~/.config/nautilus/
rsync -av .config/nvim/ ~/.config/nvim/
rsync -av .vimrc ~/.vimrc
```

Update this repository from the configs in your home directory:

```bash
rsync -av ~/.sway/ .sway/
rsync -av ~/.config/rofi/ .config/rofi/
rsync -av ~/.config/tmux/ .config/tmux/
rsync -av ~/.config/kanshi/ .config/kanshi/
rsync -av ~/.config/nautilus/ .config/nautilus/
rsync -av ~/.config/nvim/ .config/nvim/
rsync -av ~/.vimrc .vimrc
```
