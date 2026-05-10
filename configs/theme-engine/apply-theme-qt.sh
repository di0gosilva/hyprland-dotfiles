THEME=$1
THEMES_DIR="$HOME/Documentos/dotfiles/themes"
ENGINE_DIR="$HOME/.config/theme-engine"

KV_BASE="$ENGINE_DIR/kvantum/base"
KV_GEN="$ENGINE_DIR/kvantum/generated"

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

# ===============================
# VARIAÇÕES AUTOMÁTICAS
# ===============================

BG_LIGHT=$(adjust_color "$BG" 20)
BG_LIGHTER=$(adjust_color "$BG" 40)
BG_DARK=$(adjust_color "$BG" -20)
BG_DARKER=$(adjust_color "$BG" -40)

FG_LIGHT=$(adjust_color "$FG" 40)
FG_LIGHTER=$(adjust_color "$FG" 70)
FG_DARK=$(adjust_color "$FG" -30)

ACCENT_LIGHT=$(adjust_color "$ACCENT" 30)
ACCENT_DARK=$(adjust_color "$ACCENT" -30)

CRITICAL_LIGHT=$(adjust_color "$CRITICAL" 30)
CRITICAL_DARK=$(adjust_color "$CRITICAL" -30)

HOVER_BG="$ACCENT"
HOVER_TEXT="$BG"

# ===============================
# CONVERTE CORES PARA RGB
# ===============================

hex_to_rgb "$FG"
FG_R=$r
FG_G=$g
FG_B=$b

hex_to_rgb "$ACCENT"
ACCENT_R=$r
ACCENT_G=$g
ACCENT_B=$b

hex_to_rgb "$CRITICAL"
CRITICAL_R=$r
CRITICAL_G=$g
CRITICAL_B=$b

# ===============================
# BUILD THEME
# ===============================

rm -rf "$KV_GEN"
mkdir -p "$KV_GEN"

cp "$KV_BASE/theme.kvconfig" "$KV_GEN/Generated.kvconfig"
cp "$KV_BASE/theme.svg" "$KV_GEN/Generated.svg"

KVCONFIG="$KV_GEN/Generated.kvconfig"
KVSVG="$KV_GEN/Generated.svg"

# ===============================
# APPLY COLORS
# ===============================

apply_kvantum_colors() {
  FILE=$1

  # ===============================
  # BACKGROUND / SURFACES
  # ===============================

  sed -i "s/#000000/$BG_DARKER/gi" "$FILE"
  sed -i "s/#1a1a1a/$BG_DARKER/gi" "$FILE"
  sed -i "s/#1e1e1e/$BG_DARK/gi" "$FILE"
  sed -i "s/#1f1f1f/$BG_DARK/gi" "$FILE"
  sed -i "s/#212121/$BG/gi" "$FILE"
  sed -i "s/#26272a/$BG/gi" "$FILE"

  sed -i "s/#282828/$BG/gi" "$FILE"
  sed -i "s/#2c2c2c/$BG/gi" "$FILE"
  sed -i "s/#2e2e2e/$BG_LIGHT/gi" "$FILE"
  sed -i "s/#323232/$BG_LIGHT/gi" "$FILE"
  sed -i "s/#333333/$BG_LIGHT/gi" "$FILE"
  sed -i "s/#343031/$BG_LIGHT/gi" "$FILE"
  sed -i "s/#3c3c3c/$BG_LIGHTER/gi" "$FILE"

  # ===============================
  # TEXT
  # ===============================

  sed -i "s/#dfdfdf/$FG/gi" "$FILE"
  sed -i "s/#e0e0e0/$FG/gi" "$FILE"
  sed -i "s/#efefef/$FG/gi" "$FILE"
  sed -i "s/#ffffff/$FG/gi" "$FILE"
  sed -i "s/#f2f2f2/$FG/gi" "$FILE"
  sed -i "s/#acb1bc/$FG_DARK/gi" "$FILE"
  sed -i "s/#b6b6b6/$FG_DARK/gi" "$FILE"
  sed -i "s/#cccccc/$FG/gi" "$FILE"

  # ===============================
  # ACCENT / DETAILS
  # ===============================

  sed -i "s/#0057AE/$ACCENT/gi" "$FILE"
  sed -i "s/#4285f4/$ACCENT/gi" "$FILE"
  sed -i "s/#b74aff/$ACCENT/gi" "$FILE"
  sed -i "s/#E040FB/$ACCENT/gi" "$FILE"
  sed -i "s/#5a616e/$ACCENT_DARK/gi" "$FILE"

  # ===============================
  # CRITICAL
  # ===============================

  sed -i "s/#f04a50/$CRITICAL/gi" "$FILE"

  # ===============================
  # BORDERS / DETAILS
  # ===============================

  sed -i "s/#474747/$ACCENT_DARK/gi" "$FILE"
  sed -i "s/#4d4d4d/$ACCENT_DARK/gi" "$FILE"
  sed -i "s/#525252/$BG_LIGHTER/gi" "$FILE"
  sed -i "s/#535353/$BG_LIGHTER/gi" "$FILE"
  sed -i "s/#5a5a5a/$BG_LIGHTER/gi" "$FILE"
  sed -i "s/#646464/$BG_LIGHTER/gi" "$FILE"
  sed -i "s/#666666/$BG_LIGHTER/gi" "$FILE"
  sed -i "s/#696969/$BG_LIGHTER/gi" "$FILE"
  sed -i "s/#787878/$BG_LIGHTER/gi" "$FILE"

  # ===============================
  # RGBA / HOVER
  # ===============================

  sed -i "s/rgba(255, *255, *255, *0\.1)/rgba($FG_R,$FG_G,$FG_B,0.1)/gi" "$FILE"
  sed -i "s/rgba(255, *255, *255, *0\.08)/rgba($FG_R,$FG_G,$FG_B,0.08)/gi" "$FILE"
  sed -i "s/rgba(255, *255, *255, *0\.05)/rgba($FG_R,$FG_G,$FG_B,0.05)/gi" "$FILE"

  sed -i "s/rgba(66, *133, *244, *0\.2)/rgba($ACCENT_R,$ACCENT_G,$ACCENT_B,0.2)/gi" "$FILE"
  sed -i "s/rgba(240, *74, *80, *0\.2)/rgba($CRITICAL_R,$CRITICAL_G,$CRITICAL_B,0.2)/gi" "$FILE"
}

apply_kvantum_colors "$KVCONFIG"
apply_kvantum_colors "$KVSVG"

# ===============================
# APPLY THEME
# ===============================

mkdir -p ~/.config/Kvantum

rm -rf ~/.config/Kvantum/Generated
ln -sf "$KV_GEN" ~/.config/Kvantum/Generated

kvantummanager --set Generated >/dev/null 2>&1

# ===============================
# QT ENV FILE
# ===============================

mkdir -p "$ENGINE_DIR/qt"

cat > "$ENGINE_DIR/qt/colors.conf" <<EOF
[ColorScheme]
active_colors=$FG,$BG,$BG_LIGHT,$BG_DARK,$BG_LIGHTER,$FG,$FG,$FG,$FG,$BG,$BG,$BG,$ACCENT,$FG,$ACCENT,$CRITICAL,$BG,$FG,$BG,$FG,$BG,$FG
disabled_colors=$FG_DARK,$BG,$BG_LIGHT,$BG_DARK,$BG_LIGHTER,$FG_DARK,$FG_DARK,$FG_DARK,$FG_DARK,$BG,$BG,$BG,$ACCENT_DARK,$FG_DARK,$ACCENT_DARK,$CRITICAL_DARK,$BG,$FG_DARK,$BG,$FG_DARK,$BG,$FG_DARK
inactive_colors=$FG,$BG,$BG_LIGHT,$BG_DARK,$BG_LIGHTER,$FG,$FG,$FG,$FG,$BG,$BG,$BG,$ACCENT,$FG,$ACCENT,$CRITICAL,$BG,$FG,$BG,$FG,$BG,$FG
EOF
