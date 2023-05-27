# xautolock -detectsleep -time 3 -locker "slock" -notify 30 -notifier "echo ('LOCKING screen in 30 seconds'; sleep 10) | dzen2 -bg black -fg white -fn fixed" &

x-on-resize -c ~/.my-scripts/hdmi-script &
batnot &
telegram-desktop &
transmission-daemon &
unclutter --timeout 1 --jitter 10 --ignore-scrolling &
setxkbmap -layout us,ru -variant ,winkeys -option grp:alt_shift_toggle -option ctrl:nocaps &
redshift -l 52.71:11.97 -t 5700:3600 -g 0.8 &
xmobar &

exec xmonad
