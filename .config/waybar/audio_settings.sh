#!/bin/bash

if pgrep pavucontrol > /dev/null; then
    pkill pavucontrol
else
    hyprctl dispatch exec pavucontrol &
fi
