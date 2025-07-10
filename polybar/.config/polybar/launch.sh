#!/usr/bin/env bash
pkill polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done
polybar top -r &
