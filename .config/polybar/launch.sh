#!/usr/bin/env sh

# Terminate already running instances of the bar
killall -q polybar

# Wait for the processes to shut down
while pgrep -x polybar >/dev/null; do sleep 1; done


if type "xrandr"; then
    for m in $(xrandr --query | grep "connected" | cut -d' ' -f1); do
        MONITOR=$m polybar main &
    done
else
    polybar main &
fi

echo "Launched the bars..."
