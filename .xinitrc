# xautolock -detectsleep -time 3 -locker "slock" -notify 30 -notifier "echo ('LOCKING screen in 30 seconds'; sleep 10) | dzen2 -bg black -fg white -fn fixed" &

setxkbmap -layout us,ru -variant ,winkeys -option grp:alt_shift_toggle -option ctrl:nocaps &
unclutter --timeout 1 --jitter 10 --ignore-scrolling &
redshift -l 52.7:41.4 -t 5700:3600 -g 0.8 &
# clight &
transmission-daemon &
batnot &
/home/streltsov/.the-knowledge-garden/scripts/push-to-repo.sh
xmobar &

exec xmonad
