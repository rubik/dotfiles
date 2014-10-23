#!/bin/sh
# Configure X
xsetroot -cursor_name left_ptr &
setxkbmap it
xloadimage -onroot Documents/Backgrounds/BetterMan.jpg
xrdb -merge ~/.Xdefaults &

# Start dmenu
dmenu &

# Start the terminal
urxvt &

# Start a browser
chromium &

exec dbus-launch xmonad
