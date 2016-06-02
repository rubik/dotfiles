#! /bin/bash
#
# I3 bar with https://github.com/krypt-n/bar

panel_fifo="/tmp/i3_lemonbar_${USER}"
font="Terminess Powerline:size=20:dpi=116:antialias=true"
iconfont="fontellolemonbar:size=18:dpi=116:antialias=true"
iconfont2="FontAwesome:size=18:dpi=116:antialias=true"
color_back="#FF363847"
color_fore="#FF282a36"
res_w=$(xrandr | grep "current" | awk '{print $8a}')

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

### EVENTS

# Window title, "WIN"
xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}" &

# i3 Workspaces, "WSP"
# TODO : Restarting I3 breaks the IPC socket con. :(
$(dirname $0)/i3_workspaces.pl > "${panel_fifo}" &

# i3status, "SYS"
i3status | sed -un 's/^/SYS/p' > "${panel_fifo}" &

#### LOOP FIFO
cat "${panel_fifo}" | $(dirname $0)/i3_lemonbar_parser.py "${res_w}" \
  | lemonbar -p -f "${font}" -f "${iconfont}" -f "${iconfont2}" -B "${color_back}" -F "${color_fore}" &

wait
