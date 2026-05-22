#!/usr/bin/env zsh

# Source colors
source "$CONFIG_DIR/colors.sh"

if [[ "$SENDER" = "aerospace_workspace_change" ]]; then
    if [[ "$1" = "$FOCUSED_WORKSPACE" ]]; then
        sketchybar --set $NAME background.color=$SPACE_HIGHLIGHT background.drawing=on
    else
        sketchybar --set $NAME background.color=$SPACE_BACKGROUND background.drawing=on label.drawing=on
    fi
fi

# Initialize the state
CURRENT_WORKSPACE=$(aerospace -q workspace)
if [[ "$1" = "$CURRENT_WORKSPACE" ]]; then
    sketchybar --set $NAME background.color=$SPACE_HIGHLIGHT background.drawing=on
else
    sketchybar --set $NAME background.color=$SPACE_BACKGROUND background.drawing=on label.drawing=on
fi
