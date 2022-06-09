# xautolock -detectsleep -time 3 -locker "slock" -notify 30 -notifier "echo ('LOCKING screen in 30 seconds'; sleep 10) | dzen2 -bg black -fg white -fn fixed" &
setxkbmap -layout us,ru -variant ,winkeys -option grp:alt_shift_toggle -option ctrl:nocaps &
# [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &
unclutter --timeout 1 --jitter 10 --ignore-scrolling &
redshift -l 52.724440:41.449399 &
transmission-daemon &
telegram-desktop &
batnot &
push-notes-git &
xmodmap -e 'keycode 37 = Shift_L' &
dropbox &
xmobar &

exec xmonad
