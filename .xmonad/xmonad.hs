import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.GroupNavigation
import Graphics.X11.ExtraTypes.XF86


myManageHook = composeAll [
      className =? "TelegramDesktop" --> doShift "7"
    , className =? "obsidian"        --> doShift "9"
  ]

main = do
  xmonad $ ewmh $ docks $ def {  
      modMask               = mod4Mask
    , logHook               = historyHook
    , terminal              = "alacritty"
    , focusedBorderColor    = "#665c54"
    , normalBorderColor     = "#000000"
    , borderWidth           = 1
    , manageHook            = manageDocks <+> myManageHook <+> manageHook def
    , layoutHook            = smartSpacing 2 $ smartBorders $ noBorders Full ||| avoidStruts(Tall 1 (3/100) (1/2))
  } `additionalKeys` [
      ((0, xK_Print),                   spawn "maim -u | tee ~/DCIM/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png")
    , ((controlMask, xK_Print),         spawn "maim -s -u | tee ~/DCIM/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i")
    , ((mod4Mask, xK_n),                spawn "~/.firefox-nightly/firefox")
    , ((mod4Mask, xK_v),                spawn "pavucontrol")
    , ((mod4Mask, xK_x),                spawn "slock")

    , ((0, xF86XK_AudioMute),           spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioRaiseVolume),    spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, xF86XK_AudioLowerVolume),    spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

    , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +5%")
    , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 5%-")

    -- Layout bindings
    , ((mod4Mask, xK_Tab), nextMatch History (return True))
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    ]
