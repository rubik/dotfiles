#!/bin/sh
eval $(ssh-agent)
exec ~/Scripts/bspwm-session
