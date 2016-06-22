#!/usr/bin/env bash

icon="$HOME/.xlock/icon.png"
tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

time scrot "$tmpbg"
time convert "$tmpbg" -scale 5% -scale 2000% "$tmpbg"
time convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
i3lock -i "$tmpbg"
