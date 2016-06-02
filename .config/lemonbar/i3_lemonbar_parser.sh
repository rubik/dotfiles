#!/bin/bash
#
# Input parser for i3 bar
# 14 ago 2015 - Electro7

# config
. $(dirname $0)/i3_lemonbar_config

# min init
title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2}%{T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # i3status 0 = {0 = wday, 1 = mday, 2 = month, 3 = time}, 1 = cpu_usage,
      # 2 = cpu_load, 3 = cpu_temp1, 4 = cpu_temp2, 5 = battery, 6 = wlan,
      # 7 = eth
      sys_arr=${line#???}
      IFS='|' sys_arr=($sys_arr)
      IFS=' ' datetime=(${sys_arr[0]})
      # date
      if [ ${res_w} -gt 1024 ]; then
        date="${datetime[0]} ${datetime[1]} ${datetime[2]}"
      else
        date="${datetime[1]} ${datetime[2]}"
      fi
      date="%{F${color_head}}${sep_left}%{F${color_icon} B${color_head}}%{T2}  ${icon_cal}%{F- T1} ${date}"
      # time
      time="%{F${color_head}}${sep_left}%{F${color_back} B${color_head}}${datetime[3]}${stab}%{F- B-}"
      # cpu
      cpu_num=$((10#${sys_arr[1]:0:2}))
      if [[ cpu_num -gt ${cpu_alert} ]]; then
        cpu_cback=${color_cpu}; cpu_cicon=${color_back}; cpu_cfore=${color_back};
      else
        cpu_cback=${color_sec_b2}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
      fi
      cpu="%{F${cpu_cback}}${sep_left}%{F${cpu_cicon} B${cpu_cback}} %{T2}${icon_cpu}%{F${cpu_cfore} T1} ${cpu_num}%"
      # load
      # cpu_temp
      # battery
      bat_status=(${sys_arr[5]});
      case "${bat_status[0]}" in
          BAT)
              capacity=${bat_status[1]: : -1};
              battery_bgcolor="${color_mail}";
              if [[ $capacity -le 5 ]]; then
                  battery_icon="${icon_bat0}";
              elif [[ $capacity -le 30 ]]; then
                  battery_icon="${icon_bat1}";
              elif [[ $capacity -le 55 ]]; then
                  battery_icon="${icon_bat2}";
              elif [[ $capacity -le 85 ]]; then
                  battery_icon="${icon_bat3}";
              else
                  battery_icon="${icon_bat4}";
              fi
              ;;
          AC)
              battery_icon="${icon_bolt}";
              battery_bgcolor="${color_mail}";
              ;;
        esac
        bat="%{F${battery_bgcolor}}${sep_left}%{F${color_back} B${battery_bgcolor} T3} ${battery_icon} %{T1}${sys_arr[5]#???}";
      # wlan
      if [ "${sys_arr[6]}" == ".down." ]; then
        wlan="×";
        wlan_cback=${color_sec_b2}; wlan_cicon=${color_disable}; wlan_cfore=${color_disable};
      else
        wlan=${sys_arr[6]};
        wlan_cback=${color_sec_b2}; wlan_cicon=${color_icon}; wlan_cfore=${color_fore};
      fi
      wlan="%{F${wlan_cback}}${sep_left}%{F${wlan_cicon} B${wlan_cback}} %{T2}${icon_wifi}%{F${wlan_cfore} T1} ${wlan}"
      # eth
      if [ "${sys_arr[7]}" == ".down." ]; then
        eth_name="×";
        eth_cback=${color_sec_b1}; eth_cicon=${color_disable}; eth_cfore=${color_disable};
      else
        eth_name=${sys_arr[7]};
        eth_cback=${color_sec_b1}; eth_cicon=${color_icon}; eth_cfore=${color_fore};
      fi
      eth="%{F${eth_cback}}${sep_left}%{F${eth_cicon} B${eth_cback}} %{T2}${icon_eth}%{F${eth_cfore} T1} ${eth_name}"
      ;;
    WSP*)
      # I3 Workspaces
      wsp="%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1}"
      set -- "${line#???}"
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_back} B${color_wsp} T1} ${1#???} %{F${color_wsp} B${color_head}}${sep_right}"
           ;;
         INA*|URG*|ACT*)
           wsp="${wsp}%{F${color_disable} T1} ${1#???} "
           ;;
        esac
        shift
      done
      ;;
    WIN*)
      # window title
      title=$(xprop -id "${line#???}" | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2} T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1} ${title}"
      ;;
  esac

  # And finally, output
  printf "%s\n" "%{l}${wsp}${title} %{r}${cpu}${stab}${bat}${stab}${wlan}${stab}${eth}${stab}${date}${stab}${time}"
  #printf "%s\n" "%{l}${wsp}${title}"
done
