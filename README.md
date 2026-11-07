Prerequisites:

```bash
mkdir -p ~/Pictures/Screenshots
sudo dnf install grim slurp swappy wl-clipboard cliphist waybar kanshi nvim tmux vim wdisplays
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
