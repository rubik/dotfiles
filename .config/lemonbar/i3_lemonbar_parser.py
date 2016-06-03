#!/bin/python3.5

import sys
import string
import subprocess


res_w = int(sys.argv[1])
cpu_alert1 = 50
cpu_alert2 = 65
temp_alert1 = 50
temp_alert2 = 55

colors = {
    'color_back':    '#FF363847',        # Default background
    'color_fore':    '#FF282a36',        # Default foreground
    'color_fore_2':  '#FFE8E8E8',        # Light foreground
    'color_head':    '#FFFF7AC6',        # Background for first element
    'color_sec_b1':  '#FF8BE9FD',        # Background for section 1
    'color_sec_b2':  '#FFFF7AC6',        # Background for section 2
    'color_sec_b3':  '#FFF1FA8C',        # Background for section 3
    'color_sec_b4':  '#FF404254',        # Background for section 4
    'color_icon':    '#FF282a36',        # For icons
    'color_alert1':  '#FFFF5F00',        # Background color for mild alert
    'color_alert2':  '#FFBE0A0A',        # Background color for danger alert
    'color_disable': '#FF1D1F21',        # Foreground for disable elements
    'color_wsp':     '#FFD465A4',        # Background for selected workspace
}

glyphs = {
    # Pure convenience
    'stab': ' ' if res_w < 1024 else '  ',
    # Char glyphs for powerline fonts
    'sep_left':    '',                  # Powerline separator left
    'sep_right':   '',                  # Powerline separator right
    'sep_l_left':  '',                  # Powerline light separator left
    'sep_l_right': '',                  # Powerline light sepatator right

    # Icon glyphs from Fontello and Font awesome
    'icon_cpu':      '',                # CPU icon
    'icon_cpu_load': '',                # CPU load
    'icon_cpu_temp': '',                # CPU temperature
    'icon_wifi':     '',                # Wifi icon
    'icon_eth':      '',                # Ethernet icon
    'icon_bat0':     '',                # Battery icon (empty)
    'icon_bat1':     '',                # Battery icon (one quarter)
    'icon_bat2':     '',                # Battery icon (half)
    'icon_bat3':     '',                # Battery icon (three quarters)
    'icon_bat4':     '',                # Battery icon (full)
    'icon_bolt':     '',                # Bolt icon
    'icon_prog':     '',                # Window icon
    'icon_cal':      '',                # Calendar icon
    'icon_wsp':      '',                # Workspace icon
}


def format(msg, **kwargs):
    t = string.Template(msg)
    return t.safe_substitute(**{**colors, **glyphs, **kwargs})


def short(timedelta):
    nums = timedelta.split(':')
    return int(nums[0]) + int(nums[1]) / 60


def sys_(line, state):
    # i3status = {0 = wday, 1 = mday, 2 = month, 3 = time}, 1 = cpu_usage,
    # 2 = cpu_load, 3 = cpu_temp, 4 = battery, 5 = wlan, 6 = eth
    sys_arr = line.split('|')
    datetime = sys_arr[0].split()
    # date
    if res_w < 1024:
        actual_date = '{} {}'.format(*datetime)
    else:
        actual_date = '{} {} {}'.format(*datetime)
    date = ('%%{F${color_head}}${sep_left}%%{F${color_icon} B${color_head}}'
            '%%{T2} ${icon_cal}%%{F- T1} %s') % actual_date
    # time
    time = ('%%{F${color_head}}${sep_left}%%{F${color_back} B${color_head}}'
            '%s${stab}%%{F- B-}') % datetime[3]
    # cpu
    cpu_usage = int(sys_arr[1][:-1])
    if cpu_usage >= cpu_alert2:
        cpu_cback = '$color_alert2'
    elif cpu_usage >= cpu_alert1:
        cpu_cback = '$color_alert1'
    else:
        cpu_cback = '$color_sec_b2'
    cpu = ('%%{F%(cpu_cback)s}${sep_left}%%{F${color_icon} B%(cpu_cback)s} '
           '%%{T2}${icon_cpu}%%{F${color_back} T1} %(cpu_usage)s%%') % \
        dict(cpu_usage=cpu_usage, cpu_cback=cpu_cback)
    # load
    load = ('%%{F${color_sec_b3}}${sep_left}%%{F${color_icon} '
            'B${color_sec_b3}} %%{T2}${icon_cpu_load}%%{F${color_fore} '
            'T1} %s') % sys_arr[2]
    # cpu_temp
    t = int(sys_arr[3])
    if t >= temp_alert2:
        temp_cback = '$color_alert2'
    elif t >= temp_alert1:
        temp_cback = '$color_alert1'
    else:
        temp_cback = '$color_sec_b1'
    cpu_temp = ('%%{F%(temp_cback)s}${sep_left}%%{F${color_icon} '
                'B%(temp_cback)s} %%{T2}${icon_cpu_temp}%%{F${color_fore} T1} '
                '%(t)d') % dict(t=t, temp_cback=temp_cback)
    # battery
    battery_bgcolor = colors['color_sec_b3']
    if sys_arr[4] == 'No battery':
        battery_icon = glyphs['icon_bolt']
        status_text = 'no battery'
    else:
        bat_status = sys_arr[5].split()
        capacity = int(bat_status[1][:-1])
        if bat_status[0] == 'BAT':
            if capacity <= 5:
                battery_icon = glyphs['icon_bat0']
                battery_bgcolor = colors['color_alert2']
            elif capacity <= 30:
                battery_icon = glyphs['icon_bat1']
                battery_bgcolor = colors['color_alert1']
            elif capacity <= 55:
                battery_icon = glyphs['icon_bat2']
            elif capacity <= 85:
                battery_icon = glyphs['icon_bat3']
            else:
                battery_icon = glyphs['icon_bat4']
        else:
            battery_icon = glyphs['icon_bolt']
        status_text = '%s%% %.1gh' % (capacity, short(bat_status[2]))
    bat = ('%%{F${battery_bgcolor}}${sep_left}%%{F${color_icon} '
           'B${battery_bgcolor} T3} ${battery_icon} '
           '%%{T1}%s') % status_text
    # wlan
    if sys_arr[5] == '.down.':
        wlan_ssid = '×'
        wlan_cback = colors['color_sec_b2']
        wlan_cicon = colors['color_disable']
        wlan_cfore = colors['color_disable']
    else:
        wlan_ssid = sys_arr[5]
        wlan_cback = colors['color_sec_b2']
        wlan_cicon = colors['color_icon']
        wlan_cfore = colors['color_fore']
    wlan = ('%%{F${wlan_cback}}${sep_left}%%{F${wlan_cicon} B${wlan_cback}} '
            '%%{T2}${icon_wifi}%%{F${wlan_cfore} T1} %s') % wlan_ssid
    # eth
    if sys_arr[6] == '.down.':
        eth_name = '×'
        eth_cback = colors['color_sec_b1']
        eth_cicon = colors['color_disable']
        eth_cfore = colors['color_disable']
    else:
        eth_name = sys_arr[7]
        eth_cback = colors['color_sec_b1']
        eth_cicon = colors['color_icon']
        eth_cfore = colors['color_fore']
    eth = ('%%{F${eth_cback}}${sep_left}%%{F${eth_cicon} B${eth_cback}} '
           '%%{T2}${icon_eth}%%{F${eth_cfore} T1} %s') % eth_name
    state['sys'] = format(
        format('${cpu}${stab}${load}${stab}${cpu_temp}${stab}${bat}${stab}${wlan}${stab}'
               '${eth}${stab}${date}${stab}${time}', **locals()),
        **locals()
    )


# I3 Workspaces
def wsp(line, state):
    wsps = ['%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1}']
    for ws in line.split():
        # focused workspace
        if ws[0] == '*' and len(ws) > 1:
            wsps.append(
                ('%%{F${color_head} B${color_wsp}}${sep_right}'
                 '%%{F${color_back} B${color_wsp} T1} %s %%{F${color_wsp} '
                 'B${color_head}}${sep_right}') % ws[1:]
            )
        else:
            wsps.append('%%{F${color_disable} T1} %s ' % ws)
    state['wsp'] = format(''.join(wsps))


def win(line, state):
    # window title
    if line == '0x0':
        win_title = ''
    else:
        win_title = subprocess.getoutput(
            'xprop -id "%s" | grep "_NET_WM_NAME" | cut -d\'"\' -f2' % line
        )
    new = ('%{F${color_head} B${color_sec_b2}}${sep_right}'
           '%{F${color_sec_b2} B-}${sep_right}%{F${color_fore_2} B- T1} '
           '${win_title}')
    state['title'] = format(new, win_title=win_title)


OPS = {
    'SYS': sys_,
    'WSP': wsp,
    'WIN': win,
}

state = {
    'sys': '',
    'wsp': '',
    'title': format('%{F${color_head} B${color_sec_b2}}${sep_right}'
                    '%{F${color_head} B${color_sec_b2} T2} ${icon_prog} '
                    '%{F${color_sec_b2} B-}${sep_right}%{F- B- T1}'),
}


while True:
    line = sys.stdin.readline().rstrip()
    OPS[line[:3]](line[3:], state)
    sys.stdout.write('%%{l}%(wsp)s%(title)s %%{r}%(sys)s\n' % state)
    sys.stdout.flush()
