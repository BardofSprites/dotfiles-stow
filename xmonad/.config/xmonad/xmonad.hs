import XMonad
import XMonad.Util.EZConfig

-- window layout
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.LayoutCombinators (JumpToLayout(..))
import XMonad.Layout.Renamed (renamed, Rename(Replace))

-- window swallowing
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.IndependentScreens
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.CycleWS

-- xmobar
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import System.IO
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import qualified XMonad.StackSet as W

import XMonad.Hooks.EwmhDesktops

-- Custom theme
import Colors.Ef.EleaDark

main :: IO()
main = do
  nScreens <- countScreens
  xmprocs <- mapM (\s -> spawnPipe $ "xmobar -x " ++ show s) [0 .. (nScreens - 1)]
  xmonad
    . docks
    . ewmhFullscreen
    . ewmh
    $ myConfig xmprocs

term :: String
term = "st"

myConfig xmprocs = def
  {
    modMask = mod4Mask
  , layoutHook = myLayout
  , workspaces = myWorkspaces
  , handleEventHook = swallowEventHook (className =? "St" <||> className =? "st") (return True)
  , logHook = myLogHook xmprocs
  -- , startupHook = spawn "conky -c ~/.config/conky/conky.conf"
  , manageHook = myManageHook
  , borderWidth = 3
  , focusedBorderColor = active_border  -- Focused window border color
  , normalBorderColor = inactive_border  -- Unfocused window border color
  }
  `additionalKeysP` myKeys

myWorkspaces = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十" ]

myKeys =
  [("M-q", kill)
  -- window management
  , ("M-z", windows W.swapMaster)

  -- workspaces
  -- viewing
  , ("M-1", windows $ W.view (myWorkspaces !! 0))
  , ("M-2", windows $ W.view (myWorkspaces !! 1))
  , ("M-3", windows $ W.view (myWorkspaces !! 2))
  , ("M-4", windows $ W.view (myWorkspaces !! 3))
  , ("M-5", windows $ W.view (myWorkspaces !! 4))
  , ("M-6", windows $ W.view (myWorkspaces !! 5))
  , ("M-7", windows $ W.view (myWorkspaces !! 6))
  , ("M-8", windows $ W.view (myWorkspaces !! 7))
  , ("M-9", windows $ W.view (myWorkspaces !! 8))
  , ("M-0", windows $ W.view (myWorkspaces !! 9))

  -- greedy view
  , ("M-o", swapNextScreen)

  -- moving
  , ("M-S-1", windows $ W.shift (myWorkspaces !! 0))
  , ("M-S-2", windows $ W.shift (myWorkspaces !! 1))
  , ("M-S-3", windows $ W.shift (myWorkspaces !! 2))
  , ("M-S-4", windows $ W.shift (myWorkspaces !! 3))
  , ("M-S-5", windows $ W.shift (myWorkspaces !! 4))
  , ("M-S-6", windows $ W.shift (myWorkspaces !! 5))
  , ("M-S-7", windows $ W.shift (myWorkspaces !! 6))
  , ("M-S-8", windows $ W.shift (myWorkspaces !! 7))
  , ("M-S-9", windows $ W.shift (myWorkspaces !! 8))
  , ("M-S-0", windows $ W.shift (myWorkspaces !! 9))

  -- shifting
  , ("M-`", toggleWS)

  -- monitors
  , ("M-S-l", nextScreen)
  , ("M-i", nextScreen)
  , ("M-S-h", prevScreen)
  , ("M-C-h", shiftPrevScreen)
  , ("M-C-l", shiftNextScreen)

  -- system programs
  , ("M-<Return>", spawn term)
  , ("M-d", spawn "dmenu_run")
  , ("M-S-x", spawn "sysact")
  , ("M-S-z", spawn "boomer")
  , ("M-p", spawn "st -e alsamixer")
  , ("M-S-m", spawn "wallpaper.sh")
  , ("<Print>", spawn "maimpick")

  -- media keys
  , ("<XF86AudioPlay>", spawn "playerctl play")
  , ("M-S-p", spawn "playerctl pause")
  , ("<XF86AudioPause>", spawn "playerctl pause")
  , ("<XF86AudioNext>", spawn "playerctl next")
  , ("<XF86AudioPrev>", spawn "playerctl previous")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

  -- brightness
  , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
  , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")

  -- main programs
  , ("M-w", spawn "librewolf-bin")
  , ("M-S-w", spawn "firefox-bin")

  -- emacs
  , ("M-e", spawn "emacs")
  , ("M-m", spawn "emacsclient -c -e '(emms)'")
  , ("M-n", spawn "emacsclient -c")
  , ("M-S-d", spawn "dired_selector")
  , ("M-S-n", spawn "emacs-launcher")
  , ("M-b", spawn "scratch.sh")

  , ("M-f", sendMessage $ ToggleLayout)
  , ("M-t", sendMessage $ JumpToLayout "[T]")
  , ("M-S-t", sendMessage $ JumpToLayout "|||")
  , ("M-i", sendMessage $ JumpToLayout "|M|")

  ]


myTabConfig = def { activeColor = bg_active
                  , inactiveColor = bg
                  , urgentColor = red
                  , activeBorderColor = active_border
                  , inactiveBorderColor = inactive_border
                  , urgentBorderColor = red
                  , activeTextColor = tab_fg
                  , inactiveTextColor = inactive_fg
                  , urgentTextColor = fg
                  , decoHeight = 25
                  , fontName = "xft:Iosevka Comfy:size=13"
                  }



mySpacing = spacingRaw False            -- False=Apply even when single window
                       (Border 5 5 5 5) -- Screen border size top bot rght lft
                       True             -- Enable screen border
                       (Border 5 5 5 5) -- Window border size
                       True             -- Enable window borders

myLayout = avoidStruts $ toggleLayouts full (tiled ||| bstack ||| tabbedBottom ||| column ||| full)
  where
    tiled        = renamed [Replace "[]"] $ mySpacing (Tall nmaster delta ratio)
    bstack        = renamed [Replace "TTT"] $ Mirror tiled
    nmaster      = 1
    ratio        = 1/2
    delta        = 3/100
    tabbedBottom = renamed [Replace "[T]"] $ tabbed shrinkText myTabConfig
    column       = renamed [Replace "|M|"] $ mySpacing (ThreeColMid 1 (3/100) (1/2))
    full         = renamed [Replace "[M]"] $ Full

myLogHook xmprocs = mapM_ (\xmproc -> dynamicLogWithPP xmobarPP
    { ppOutput = hPutStrLn xmproc
    , ppTitle = xmobarColor green "" . shorten 50
    , ppLayout = xmobarColor yellow ""
    , ppSep = " | "
    , ppCurrent = xmobarColor active_fg "" . wrap "[" "]"
    , ppVisible = wrap "[" "]"
    , ppHidden = \ws -> if ws == "NSP" then "" else wrap "[" "]" ws
    , ppHiddenNoWindows = \ws -> ""
    , ppUrgent = xmobarColor "red" "" . wrap "!" "!"
    }) xmprocs

myManageHook = composeAll
  [ className =? "conky" --> doIgnore  -- Ignore Conky so it doesn't get tiled
  , className =? "floatterm" --> doRectFloat (W.RationalRect 0.125 0.125 0.75 0.75)
  , manageDocks  -- Ensure docks (like xmobar) are managed correctly
  ] <+> manageHook def
