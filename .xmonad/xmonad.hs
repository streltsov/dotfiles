import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.GroupNavigation
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.Paste
import XMonad.Hooks.ScreenCorners
import XMonad.Actions.GridSelect


myManageHook = composeAll [
      className =? "TelegramDesktop" --> doShift "7"
  ]

main = do
  xmonad $ ewmh $ docks $ def {  
      modMask               = mod4Mask
    , logHook               = historyHook
    , terminal              = "alacritty"
    , focusedBorderColor    = "#928374"
    , normalBorderColor     = "#000000"
    , borderWidth           = 1
    , manageHook            = manageDocks <+> myManageHook <+> manageHook def
    , layoutHook            = smartSpacing 2 $ smartBorders $ noBorders Full ||| avoidStruts(Tall 1 (3/100) (1/2))
  } `additionalKeys` [
      ((0, xK_Print),                   spawn "maim -u | tee ~/DCIM/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png")
    , ((mod4Mask, xK_Print),            spawn "maim -s -u | tee ~/DCIM/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i")
    , ((mod4Mask, xK_n),                spawn "~/.firefox-nightly/firefox")
    , ((mod4Mask, xK_v),                spawn "pavucontrol")
    , ((mod4Mask, xK_x),                spawn "slock")

    , ((0, xF86XK_AudioMute),           spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioRaiseVolume),    spawn "pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' | tr -d '[:space:]%' | dzen2 -p 1 -fn 'Operator Mono:size=14' -x 0 -y 0 -w 1920 -h 20")
    , ((0, xF86XK_AudioLowerVolume),    spawn "pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' | tr -d '[:space:]%' | dzen2 -p 1 -fn 'Operator Mono:size=14' -x 0 -y 0 -w 1920 -h 20")
    , ((0, xF86XK_MonBrightnessUp),     spawn "brightnessctl set +50% && brightnessctl get | dzen2 -p 1 -fn 'Operator Mono:size=14' -x 0 -y 0 -w 1920 -h 20")
    , ((0, xF86XK_MonBrightnessDown),   spawn "brightnessctl set 50%- && brightnessctl get | dzen2 -p 1 -fn 'Operator Mono:size=14' -x 0 -y 0 -w 1920 -h 20")
    , ((0, xK_Insert), pasteSelection)

    -- Layout bindings
    , ((mod4Mask, xK_g), goToSelected def)
    -- , ((mod4Mask, xK_s), spawnSelected defaultGSConfig ["xterm","gmplayer","gvim"])
    , ((mod4Mask, xK_Tab), nextMatch History (return True))
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    ]
