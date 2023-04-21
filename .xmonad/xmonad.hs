import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops

myManageHook = composeAll
  [ className =? "TelegramDesktop" --> doShift "7" ]

main = do
  xmonad $ ewmh $ docks $ def {
      modMask               = mod4Mask
    , terminal              = "alacritty"
    , focusedBorderColor    = "#665c54"
    , normalBorderColor     = "#000000"
    , borderWidth           = 1
    , manageHook            = manageDocks <+> myManageHook <+> manageHook def
    , layoutHook            = smartSpacing 2 $ smartBorders $ noBorders Full ||| avoidStruts(Tall 1 (3/100) (1/2))
  } `additionalKeys` [
      ((shiftMask .|. mod4Mask, xK_3),  spawn "maim -u | tee ~/DCIM/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png")
    , ((shiftMask .|. mod4Mask, xK_4),  spawn "maim -s -u | tee ~/DCIM/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i")
    , ((mod4Mask, xK_n),                spawn "~/.firefox-nightly/firefox")
    , ((mod4Mask, xK_v),                spawn "pavucontrol")
    , ((mod4Mask, xK_x),                spawn "slock")

    -- Layout bindings
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    ]

