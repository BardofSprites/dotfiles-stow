import XMonad
import XMonad.Util.EZConfig

-- window layout
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.SubLayouts
import XMonad.Layout.BoringWindows
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest

-- window swallowind
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.IndependentScreens
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.CycleWS

-- xmobar
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import System.IO
import XMonad.Hooks.ManageDocks

import qualified XMonad.StackSet as W

import XMonad.Hooks.EwmhDesktops

main :: IO()
main = do
  nScreens <- countScreens
  xmprocs <- mapM (\s -> spawnPipe $ "xmobar -x " ++ show s) [0 .. (nScreens - 1)]
  xmprocs' <- mapM (\s -> spawnPipe $ "xmobar -x " ++ show s) [0 .. (nScreens - 1)] -- Second set of bars
  xmonad
     . ewmhFullscreen
     . ewmh
     $ myConfig (xmprocs ++ xmprocs')

term :: String
term = "st"

-- Gruber Darker Colors
fg        = "#e4e4ef"
bg        = "#181818"
bg_alt    = "#282828"
red       = "#f43841"
green     = "#73c936"
yellow    = "#ffdd33"
orange    = "#cc8c3c"
wisteria  = "#9e95c7"

myConfig xmprocs = def
  {
    modMask = mod4Mask
  , layoutHook = avoidStruts $ myLayout
  , workspaces = myWorkspaces
  , handleEventHook = swallowEventHook (className =? "St") (return True) -- Swallow terminal windows
  , logHook = mapM_ (\xmproc -> dynamicLogWithPP xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor green "" . shorten 50
      , ppLayout = xmobarColor wisteria ""
      , ppSep = " | "
      , ppCurrent = xmobarColor orange "" . wrap "[" "]"
      , ppVisible = wrap "[" "]"
      , ppHidden = \ws -> if ws == "NSP" then "" else wrap "[" "]" ws
      , ppHiddenNoWindows = \ws -> ""
      , ppUrgent = xmobarColor "red" "" . wrap "!" "!"
      }) xmprocs
  , borderWidth = 3
  , focusedBorderColor = orange  -- Focused window border color
  , normalBorderColor = bg_alt  -- Unfocused window border color
  }
  `additionalKeysP` myKeys

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

myKeys =
  [("M-q", kill)
  -- window management
  , ("M-z", windows W.swapMaster)
  , ("M-S-<Space>", withFocused $ windows . W.sink)

  -- workspaces
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

  -- system programs
  , ("M-<Return>", spawn term)
  , ("M-d", spawn "dmenu_run")
  , ("M-S-x", spawn "sysact")

  -- media keys
  , ("<XF86AudioPlay>", spawn "playerctl play")
  , ("M-S-p", spawn "playerctl pause")
  , ("<XF86AudioPause>", spawn "playerctl pause")
  , ("<XF86AudioNext>", spawn "playerctl next")
  , ("<XF86AudioPrev>", spawn "playerctl previous")
  , ("<XF86AudioRaiseVolume>", spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
  , ("<XF86AudioLowerVolume>", spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
  , ("<XF86AudioMute>", spawn "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")

  -- main programs
  -- , ("M-w", spawn "librewolf-bin")
  , ("M-S-w", spawn "firefox")

  -- emacs
  , ("M-e", spawn "emacs")
  , ("M-m", spawn "emacsclient -c -e '(emms)'")
  , ("M-n", spawn "emacsclient -c")
  , ("M-S-d", spawn "dired_selector")
  , ("M-S-n", spawn "emacs-launcher")
  , ("M-b", spawn "scratch.sh")

  -- mouse bindings
  ]

myLayout = tiled ||| Mirror tiled ||| Full ||| tabbedBottom
  where
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes
    tabbedBottom = tabbed shrinkText def
