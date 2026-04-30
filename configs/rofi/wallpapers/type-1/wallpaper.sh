#!/usr/bin/env bash

dir="$HOME/Documentos/dotfiles/configs/rofi/wallpapers/type-1"
theme="style-1"

WALLDIR="$HOME/Documentos/dotfiles/wallpapers"
CACHE="/tmp/rofi-wallpaper-preview.png"

# ===============================
# LISTA DE WALLPAPERS
# ===============================
get_wallpapers() {
  for img in "$WALLDIR"/*; do
    name="$(basename "$img")"
    echo -e "$name\0icon\x1f$img"
  done
}

# ===============================
# ROFI
# ===============================
rofi_cmd() {
  rofi -dmenu \
    -p "Wallpapers" \
    -show-icons \
    -theme "${dir}/${theme}.rasi" 
}

# ===============================
# MENU
# ===============================
choice=$(get_wallpapers | rofi_cmd)
[ -z "$choice" ] && exit 0

# nome do tema sem extensão da imagem
THEME="${choice%.*}"

# diretório do tema
THEME_DIR="$HOME/Documentos/dotfiles/themes/$THEME"

if [ ! -d "$THEME_DIR" ]; then
  notify-send "Tema não encontrado." "Tema '$THEME' não existe!"
  exit 1
fi

# carrega cores do tema atual
# source "$THEME_DIR/colors.env"

# ===============================
# APPLY ROFI
# ===============================
ln -sfn \
  "$THEME_DIR/rofi.rasi" \
  "$HOME/.config/rofi/colors/custom.rasi"
rm -rf ~/.cache/rofi-*

# ===============================
# WALLPAPER
# ===============================
awww img "$WALLDIR/$choice" \
  --transition-type grow \
  --transition-duration 2.5

# ===============================
# TEMA ATUAL (SYMLINK GLOBAL)
# ===============================
ln -sfn "$THEME_DIR" \
  "$HOME/Documentos/dotfiles/themes/current"

# ===============================
# WAYBAR
# ===============================
pkill waybar 2>/dev/null
sleep 1.5
waybar &

# ===============================
# DUNST
# ===============================
ln -sfn \
  "$THEME_DIR/dunst/dunstrc" \
  "$HOME/.config/dunst/dunstrc"
pkill dunst 2>/dev/null
sleep 0.2
dunst &

# ===============================
# HYPRLOCK + HYPRLAND
# ===============================
ln -sfn \
  "$THEME_DIR/hypr/hyprlock.conf" \
  "$HOME/.config/hypr/hyprlock.conf"

ln -sfn \
  "$THEME_DIR/hypr/colors.conf" \
  "$HOME/.config/hypr/colors.conf"
hyprctl reload

# ===============================
# KITTY
# ===============================
ln -sfn \
  "$THEME_DIR/kitty/colors.conf" \
  "$HOME/.config/kitty/themes/colors.conf"

# ===============================
# ZSH
# ===============================
ln -sfn \
  "$THEME_DIR/zsh/colors.zsh" \
  "$HOME/.config/zsh/colors.zsh"

# ===============================
# PREVIEW NOTIFICAÇÃO DO DUNST
# ===============================
magick "$WALLDIR/$choice" \
  -gravity center \
  -resize 96x96^ \
  -extent 96x96 \
  -bordercolor "$ACCENT" \
  -border 1 \
  "$CACHE"
sleep 0.1

# ===============================
# NOTIFICAÇÃO FINAL
# ===============================
notify-send \
  -u normal \
  -i "$CACHE" \
  "Tema '$THEME' aplicado com sucesso!"
