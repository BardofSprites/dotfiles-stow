import XMonad
import XMonad.Util.EZConfig

-- window layout
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing

import XMonad.Layout.IndependentScreens
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.CycleWS

import qualified XMonad.StackSet as W

import XMonad.Hooks.EwmhDesktops

main :: IO()
main = xmonad
     . ewmhFullscreen
     . ewmh
     $ myConfig

term :: String
term = "st"

myConfig = def
  {
    modMask = mod4Mask
  , layoutHook = myLayout
  , workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  -- , manageHook = myManageHook
  }
  `additionalKeysP`
  [("M-q", kill)

  -- window management
  , ("M-S-<Space>", withFocused $ windows . W.sink)

  -- workspaces

  -- system programs
  , ("M-<Return>", spawn term)
  , ("M-d", spawn "dmenu_run")
  , ("M-S-x", spawn "sysact")

  -- media keys
  , ("<XF86AudioPlay>", spawn "playerctl playbindsym")
  , ("<XF86AudioPause>", spawn "playerctl pausebindsym")
  , ("<XF86AudioNext>", spawn "playerctl nextbindsym")
  , ("<XF86AudioPrev>", spawn "playerctl previou")
  , ("XF86AudioRaiseVolume", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10% ")
  , ("XF86AudioLowerVolume", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10% ")
  , ("XF86AudioMute", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle ")
  , ("XF86AudioMicMute", spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle ")

  , ("M-S-p", spawn "playerctl pause")

  -- main programs
  , ("M-w", spawn "librewolf-bin")
  , ("M-S-w", spawn "firefox-bin")
  -- , ("M")

  -- emacs
  , ("M-e", spawn "emacs")
  , ("M-m", spawn "emacsclient -c -e '(emms)'")
  , ("M-n", spawn "emacsclient -c")
  , ("M-S-d", spawn "dired_selector")
  , ("M-S-n", spawn "emacs-launcher")
  , ("M-b", spawn "scratch.sh")

  -- mouse bindings
  ]

myLayout = spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $
           (tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes
