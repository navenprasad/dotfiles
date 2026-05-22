#!/bin/sh

# Source colors
source "$CONFIG_DIR/colors.sh"

sid=${NAME#space.}

# Mapping of app names to icons (Nerd Font)
get_icon() {
  case "$1" in
    "Ghostty") echo "󰊠" ;;
    "Google Chrome") echo "" ;;
    "Code"|"Visual Studio Code") echo "󰨞" ;;
    "Netflix") echo "󰝆" ;;
    "GitHub") echo "󰊤" ;;
    "Terminal"|"iTerm2") echo "" ;;
    "Finder") echo "󰀶" ;;
    *) echo "󰅡" ;; # Default icon for unknown apps
  esac
}

# Query windows in this space using yabai and jq
icons=""
# For Chrome, we try to detect PWAs by looking at the title
apps=$(yabai -m query --windows --space "$sid" | jq -r '.[] | if .app == "Google Chrome" then 
    if .title | test("GitHub") then "GitHub"
    elif .title | test("Netflix") then "Netflix"
    else "Google Chrome" end
  else .app end' | sort | uniq)

if [ -n "$apps" ]; then
  while read -r app; do
    icon=$(get_icon "$app")
    icons="$icons$icon "
  done <<EOF
$apps
EOF
fi

# Update the space item with the icons as label
# Use animation for a smoother transition
sketchybar --animate sin 10 --set "$NAME" \
  background.drawing="$SELECTED" \
  background.color=$( [ "$SELECTED" = "true" ] && echo "$SPACE_HIGHLIGHT" || echo "$SPACE_BACKGROUND" ) \
  label="$icons" \
  label.drawing=on \
  label.padding_left=$( [ -z "$icons" ] && echo "0" || echo "4" ) \
  label.padding_right=$( [ -z "$icons" ] && echo "0" || echo "10" )
