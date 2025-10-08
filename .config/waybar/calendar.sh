#!/bin/bash

if pgrep gsimplecal > /dev/null; then
    pkill gsimplecal
else
    hyprctl dispatch exec gsimplecal &
fi