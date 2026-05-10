#!/usr/bin/env bash

THEME=$1
THEMES_DIR="$HOME/Documentos/dotfiles/themes"
ENGINE_DIR="$HOME/.config/theme-engine"

if [ -z "$THEME" ]; then
  echo "Uso: $0 <nome-do-tema>"
  exit 1
fi

source "$THEMES_DIR/$THEME/colors.env"

hex_to_rgb() {
  hex="${1#"#"}"
  r=$((16#${hex:0:2}))
  g=$((16#${hex:2:2}))
  b=$((16#${hex:4:2}))
}

rgb_to_hex() {
  printf "#%02x%02x%02x\n" "$1" "$2" "$3"
}

adjust_color() {
  hex_to_rgb "$1"

  r=$((r + $2))
  g=$((g + $2))
  b=$((b + $2))

  r=$(($r<0?0:($r>255?255:$r)))
  g=$(($g<0?0:($g>255?255:$g)))
  b=$(($b<0?0:($b>255?255:$b)))

  rgb_to_hex "$r" "$g" "$b"
}

BG_LIGHT=$(adjust_color "$BG" 20)
BG_LIGHTER=$(adjust_color "$BG" 40)
BG_DARK=$(adjust_color "$BG" -20)
BG_DARKER=$(adjust_color "$BG" -40)

FG_LIGHT=$(adjust_color "$FG" 40)
FG_LIGHTER=$(adjust_color "$FG" 70)
FG_DARK=$(adjust_color "$FG" -30)

HOVER_BG="$ACCENT"
HOVER_TEXT="$BG"

hex_to_rgb "$FG"
FG_R=$r
FG_G=$g
FG_B=$b

rm -rf "$ENGINE_DIR/gtk/generated"
cp -r "$ENGINE_DIR/gtk/base" "$ENGINE_DIR/gtk/generated"

GTK_FILES=(
  "$ENGINE_DIR/gtk/generated/gtk-3.0/gtk.css"
  "$ENGINE_DIR/gtk/generated/gtk-3.0/gtk-dark.css"
  "$ENGINE_DIR/gtk/generated/gtk-4.0/gtk.css"
  "$ENGINE_DIR/gtk/generated/gtk-4.0/gtk-dark.css"
)

apply_colors() {
  FILE=$1

  sed -i "s/#121212/$BG/gi" "$FILE"
  sed -i "s/#141414/$BG_DARK/gi" "$FILE"
  sed -i "s/#1F1F1F/$BG/gi" "$FILE"
  sed -i "s/#292929/$BG_LIGHT/gi" "$FILE"
  sed -i "s/#3c3c3c/$BG_LIGHTER/gi" "$FILE"

  sed -i "s/#E0E0E0/$FG/gi" "$FILE"
  sed -i "s/#c7c7c7/$FG/gi" "$FILE"
  sed -i "s/#FFFFFF/$FG/gi" "$FILE"
  sed -i "s/#ffffff/$FG/gi" "$FILE"
  sed -i "s/#dfdfdf/$FG/gi" "$FILE"
  sed -i "s/#efefef/$FG/gi" "$FILE"

  sed -i "s/#81C995/$ACCENT/gi" "$FILE"

  sed -i "s/#F28B82/$CRITICAL/gi" "$FILE"
  sed -i "s/#f0766b/$CRITICAL/gi" "$FILE"

  sed -i "s/rgba(255, *255, *255, *0\.1)/rgba($FG_R,$FG_G,$FG_B,0.1)/gi" "$FILE"
  sed -i "s/rgba(255, *255, *255, *0\.08)/rgba($FG_R,$FG_G,$FG_B,0.08)/gi" "$FILE"
  sed -i "s/rgba(255, *255, *255, *0\.05)/rgba($FG_R,$FG_G,$FG_B,0.05)/gi" "$FILE"

  sed -i "s/#fdd11a/$ACCENT/gi" "$FILE"
  sed -i "s/#FDD633/$ACCENT/gi" "$FILE"
}

append_hover_override() {
  FILE=$1

  cat <<EOF >> "$FILE"

/* ========================= */
/* GTK SIDEBAR / BUTTON FIX */
/* ========================= */

placessidebar.sidebar row:hover,
placessidebar.sidebar row button:hover,
placessidebar.sidebar row.activatable:hover,
row.activatable:hover {
  background-image: none;
  background-color: $BG_LIGHTER;
  color: $FG;
}

placessidebar.sidebar row:hover label,
placessidebar.sidebar row:hover image,
placessidebar.sidebar row button:hover label,
placessidebar.sidebar row button:hover image,
row.activatable:hover label,
row.activatable:hover image {
  color: $FG;
}

placessidebar.sidebar row:selected,
.navigation-sidebar row:selected,
.sidebar row:selected,
row:selected {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.18);
  color: $FG;
}

placessidebar.sidebar row:selected:hover,
.navigation-sidebar row:selected:hover,
.sidebar row:selected:hover,
row:selected:hover {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.26);
  color: $FG;
}

placessidebar.sidebar row:selected:hover label,
placessidebar.sidebar row:selected:hover image,
.navigation-sidebar row:selected:hover label,
.navigation-sidebar row:selected:hover image,
.sidebar row:selected:hover label,
.sidebar row:selected:hover image,
row:selected:hover label,
row:selected:hover image {
  color: $FG;
}

button:hover {
  background-image: none;
  background-color: $BG_LIGHTER;
  color: $FG;
}

button:hover label,
button:hover image {
  color: $FG;
}

button:checked,
button:selected {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.18);
  color: $FG;
}

button:checked label,
button:checked image,
button:selected label,
button:selected image {
  color: $FG;
}

button:checked:hover,
button:selected:hover {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.26);
  color: $FG;
}

button:checked:hover label,
button:checked:hover image,
button:selected:hover label,
button:selected:hover image {
  color: $FG;
}

/* popover / menu / dialog hover */
popover row:hover,
popover modelbutton:hover,
menuitem:hover,
modelbutton:hover {
  background-image: none;
  background-color: $HOVER_BG;
  color: $HOVER_TEXT;
}

popover row:hover label,
popover modelbutton:hover label,
menuitem:hover label,
modelbutton:hover label {
  color: $HOVER_TEXT;
}

/* popover / menu / dialog selected */
popover row:selected,
popover row:selected:hover,
modelbutton:selected,
modelbutton:selected:hover {
  background-image: none;
  background-color: $HOVER_BG;
  color: $HOVER_TEXT;
}

popover row:selected label,
popover row:selected:hover label,
modelbutton:selected label,
modelbutton:selected:hover label {
  color: $HOVER_TEXT;
}

EOF
}

append_libadwaita_override() {
  FILE=$1

  cat <<EOF >> "$FILE"

/* ===================================== */
/* LIBADWAITA / NAUTILUS FIX */
/* ===================================== */

@define-color accent_color $FG;
@define-color accent_bg_color rgba($FG_R, $FG_G, $FG_B, 0.18);
@define-color accent_fg_color $FG;

.navigation-sidebar row:hover,
.navigation-sidebar > row:hover,
.navigation-sidebar row.activatable:hover,
.navigation-sidebar > row.activatable:hover,
list.navigation-sidebar row:hover,
list.navigation-sidebar > row:hover,
.sidebar row:hover,
.sidebar row.activatable:hover,
row.sidebar-row:hover,
row.activatable:hover {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.18);
  color: $FG;
  border-radius: 6px;
}

.navigation-sidebar row:hover label,
.navigation-sidebar row:hover image,
list.navigation-sidebar row:hover label,
list.navigation-sidebar row:hover image,
.sidebar row:hover label,
.sidebar row:hover image,
row.activatable:hover label,
row.activatable:hover image {
  color: $FG;
}

.navigation-sidebar row:selected,
.navigation-sidebar > row:selected,
list.navigation-sidebar row:selected,
list.navigation-sidebar > row:selected,
.sidebar row:selected,
row.sidebar-row:selected,
row:selected {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.18);
  color: $FG;
  border-radius: 6px;
}

.navigation-sidebar row:selected label,
.navigation-sidebar row:selected image,
list.navigation-sidebar row:selected label,
list.navigation-sidebar row:selected image,
.sidebar row:selected label,
.sidebar row:selected image,
row:selected label,
row:selected image {
  color: $FG;
}

.navigation-sidebar row:selected:hover,
.navigation-sidebar > row:selected:hover,
list.navigation-sidebar row:selected:hover,
list.navigation-sidebar > row:selected:hover,
.sidebar row:selected:hover,
row.sidebar-row:selected:hover,
row:selected:hover {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.26);
  color: $FG;
  border-radius: 6px;
}

.navigation-sidebar row:selected:hover label,
.navigation-sidebar row:selected:hover image,
list.navigation-sidebar row:selected:hover label,
list.navigation-sidebar row:selected:hover image,
.sidebar row:selected:hover label,
.sidebar row:selected:hover image,
row:selected:hover label,
row:selected:hover image {
  color: $FG;
}

headerbar {
  background: $BG;
  color: $FG;
  border-bottom: 1px solid $ACCENT;
}

headerbar label,
headerbar button,
headerbar button label,
.path-bar button,
.path-bar button label {
  color: $FG;
}

entry,
.location-entry,
.path-bar button {
  background-color: $BG_LIGHT;
  color: $FG;
  border: 1px solid rgba($FG_R, $FG_G, $FG_B, 0.18);
}

popover,
menu {
  background: $BG;
}

popover row:hover,
popover modelbutton:hover,
menuitem:hover,
modelbutton:hover {
  background-image: none;
  background-color: $HOVER_BG;
  color: $HOVER_TEXT;
}

popover row:hover label,
popover modelbutton:hover label,
menuitem:hover label,
modelbutton:hover label {
  color: $HOVER_TEXT;
}

tooltip {
  background-color: $BG_LIGHT;
  color: $FG;
}

label,
button label,
entry,
textview,
.view,
gridview,
listview,
columnview,
flowbox,
flowboxchild {
  color: $FG;
}

.navigation-sidebar label,
.navigation-sidebar row label,
.sidebar label,
.sidebar row label {
  color: $FG;
}

image,
button image,
.navigation-sidebar image,
.sidebar image {
  color: $ACCENT;
}

button:checked,
button:checked label,
button:selected,
button:selected label,
.navigation-sidebar row:selected label,
.sidebar row:selected label {
  color: $FG;
}

button:hover {
  background-image: none;
  background-color: $BG_LIGHTER;
  color: $FG;
}

button:hover label,
button:hover image {
  color: $FG;
}

button:checked:hover,
button:selected:hover {
  background-image: none;
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.26);
  color: $FG;
}

button:checked:hover label,
button:checked:hover image,
button:selected:hover label,
button:selected:hover image {
  color: $FG;
}

separator,
.sidebar separator,
.navigation-sidebar separator {
  background-color: $ACCENT;
  opacity: 0.35;
}

/* ===================================== */
/* TOAST / FLOATING NOTIFICATION FIX */
/* ===================================== */

toast,
toastoverlay toast,
.toast,
.floating-bar,
.floating-bar * {
  background-color: $BG_LIGHTER;
  color: $FG;
  border-radius: 6px;
}

toast label,
toastoverlay toast label,
.toast label,
.floating-bar label {
  color: $FG;
}

toast button,
toastoverlay toast button,
.toast button,
.floating-bar button {
  background-color: rgba($FG_R, $FG_G, $FG_B, 0.12);
  color: $FG;
}

toast button:hover,
toastoverlay toast button:hover,
.toast button:hover,
.floating-bar button:hover {
  background-color: $ACCENT;
  color: $BG;
}

toast button:hover label,
toastoverlay toast button:hover label,
.toast button:hover label,
.floating-bar button:hover label {
  color: $BG;
}

/* ===================================== */
/* OPEN WITH DIALOG BUTTON TEXT FIX */
/* ===================================== */

dialog button,
window.dialog button,
messagedialog button {
  color: $BG;
}

dialog button label,
window.dialog button label,
messagedialog button label {
  color: $BG;
}

EOF
}

apply_papirus_folder_color() {
  if ! command -v papirus-folders >/dev/null 2>&1; then
    echo "papirus-folders não instalado, ignorando..."
    return
  fi

  case "$THEME" in
    mr-robot)
      papirus-folders -C bluegrey
      ;;
    girl-in-pink)
      papirus-folders -C black
      ;;
    black-hole)
      papirus-folders -C black
      ;;
    houses)
      papirus-folders -C black
      ;;
    *)
      papirus-folders -C black
      ;;
  esac
}

for FILE in "${GTK_FILES[@]}"; do
  [ -f "$FILE" ] || continue

  apply_colors "$FILE"
  append_hover_override "$FILE"
  append_libadwaita_override "$FILE"
done

apply_papirus_folder_color

rm -rf ~/.config/gtk-3.0
rm -rf ~/.config/gtk-4.0

ln -sf "$ENGINE_DIR/gtk/generated/gtk-3.0" ~/.config/gtk-3.0
ln -sf "$ENGINE_DIR/gtk/generated/gtk-4.0" ~/.config/gtk-4.0

# ===============================
# APPLY DARK MODE (CHROME)
# ===============================
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# ===============================
# REMOVE CACHE COLORS GTK APPS
# ===============================
nautilus -q 2>/dev/null