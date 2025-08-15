import XMonad
import XMonad.Util.EZConfig

-- window layout
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Accordion
import qualified XMonad.Layout.Dwindle as D
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.LayoutCombinators (JumpToLayout(..))
import XMonad.Layout.Renamed (renamed, Rename(Replace))

-- window swallowing
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.IndependentScreens
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.CycleWS
import XMonad.Actions.DwmPromote

-- xmobar
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import System.IO
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import qualified XMonad.StackSet as W

import XMonad.Hooks.EwmhDesktops

-- scratchpads
import XMonad.Util.NamedScratchpad

-- projects
import XMonad.Actions.DynamicProjects
import XMonad.Util.Run (runProcessWithInput)
import Control.Monad (when)
import Data.List (find)

-- Custom theme
import Colors.Modus.Vivendi

main :: IO()
main = do
  nScreens <- countScreens
  xmprocs <- mapM (\s -> spawnPipe $ "xmobar -x " ++ show s) [0 .. (nScreens - 1)]
  xmonad
    . docks
    . ewmhFullscreen
    . ewmh
    . dynamicProjects myProjects
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
  , borderWidth = 5
  , focusedBorderColor = active_border  -- Focused window border color
  , normalBorderColor = inactive_border  -- Unfocused window border color
  }
  `additionalKeysP` myKeys

myWorkspaces = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十" ]

myKeys =
  [("M-q", kill)
  -- window management
  , ("M-<Space>", dwmpromote)
  , ("M-C-<Space>", withFocused $ windows . W.sink)

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

  -- greedy view
  , ("M-o", swapNextScreen)

  -- shifting
  , ("M-`", toggleWS' ["NSP"])

  -- monitors
  , ("M-S-l", nextScreen)
  , ("M-S-h", prevScreen)
  , ("M-C-h", shiftPrevScreen)
  , ("M-C-l", shiftNextScreen)

  -- system programs
  , ("M-<Return>", spawn term)
  , ("M-S-<Return>", namedScratchpadAction myScratchpads "spterm")
  , ("M-'", namedScratchpadAction myScratchpads "spcalc")
  , ("M-p", namedScratchpadAction myScratchpads "spaudio")
  , ("M-d", spawn "dmenu_run")
  , ("M-S-x", spawn "sysact")
  , ("M-S-z", spawn "boomer")
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
  , ("M-m", namedScratchpadAction myScratchpads "emms")
  , ("M-c", namedScratchpadAction myScratchpads "calendar")
  , ("M-a", namedScratchpadAction myScratchpads "agenda")
  , ("M-e", namedScratchpadAction myScratchpads "mail")
  , ("M-n", spawn "emacsclient -c")
  , ("M-S-d", spawn "dired_selector")
  , ("M-S-n", spawn "emacs-launcher")
  , ("M-b", spawn "scratch.sh")

  -- layouts
  , ("M-f", sendMessage $ ToggleLayout)
  , ("M-t", sendMessage $ JumpToLayout "[]=")
  , ("M-S-t", sendMessage $ JumpToLayout "TTT")
  , ("M-S-u", sendMessage $ JumpToLayout "[T]")
  , ("M-i", sendMessage $ JumpToLayout "|M|")
  , ("M-y", sendMessage $ JumpToLayout "[\\]")
  , ("M-S-y", sendMessage $ JumpToLayout "[@]")

  -- sublayouts
  , ("M-s h", sendMessage $ pullGroup L) -- move group focus left
  , ("M-s l", sendMessage $ pullGroup R) -- right
  , ("M-s k", sendMessage $ pullGroup U) -- up
  , ("M-s j", sendMessage $ pullGroup D) -- down

  , ("M-s u", withFocused (sendMessage . UnMerge))  -- unmerge focused window
  , ("M-s m", withFocused (sendMessage . MergeAll)) -- merge all windows in workspace into one group
  , ("M-s <Tab>", onGroup W.focusDown') -- focus prev window in group
  , ("M-s S-<Tab>", onGroup W.focusUp') -- focus next window in group

  -- -- Projects
  -- prompts for a project to switch to
  , ("M-S-o", dmenuSwitchProject)
  , ("M-C-o", moveWindowToProject)
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

mySpacing = spacingRaw False
            (Border 10 10 10 10)  -- outer border: top, bottom, right, left
            True                  -- enable outer gaps
            (Border 10 10 10 10)  -- inner spacing: top, bottom, right, left
            True                  -- enable inner gaps

myLayout = avoidStruts $ toggleLayouts full (tiled ||| bstack ||| tabbedBottom ||| column ||| dwindle ||| spiral ||| full)
  where
    tiled        = renamed [Replace "[]="]
                 $ windowNavigation
                 $ addTabs shrinkText myTabConfig
                 $ subLayout [] (Simplest)
                 $ mySpacing (Tall nmaster delta ratio)
    bstack        = renamed [Replace "TTT"] $ Mirror tiled
    nmaster      = 1
    ratio        = 1/2
    delta        = 3/100
    tabbedBottom = renamed [Replace "[T]"] $ tabbed shrinkText myTabConfig
    column       = renamed [Replace "|M|"] $ mySpacing $ magnifier (ThreeColMid 1 (3/100) (1/2))
    dwindle      = renamed [Replace "[\\]"] $ mySpacing (D.Dwindle D.R D.CW 1.0 1.0)
    spiral       = renamed [Replace "[@]"] $ mySpacing (D.Spiral D.R D.CW 1.0 1.0)
    full         = renamed [Replace "[M]"] $ Full

stripScreenPrefix :: String -> String
stripScreenPrefix ws = case dropWhile (/= '_') ws of
  ('_':rest) -> rest
  _ -> ws

ppForScreen :: Int -> Handle -> X ()
ppForScreen sid xmproc = dynamicLogWithPP xmobarPP
    { ppOutput = hPutStrLn xmproc
    , ppTitle = xmobarColor green "" . shorten 50
    , ppLayout = xmobarColor yellow ""
    , ppSep = " | "
    , ppCurrent = xmobarColor active_fg "" . wrap "[" "]" . stripScreenPrefix
    , ppVisible = wrap "[" "]" . stripScreenPrefix
    , ppHidden = \ws ->
        if ws == "NSP" || null ws
          then ""
          else wrap "[" "]" (stripScreenPrefix ws)

    , ppHiddenNoWindows = const ""  -- hides empty workspaces

    , ppUrgent = xmobarColor "red" "" . wrap "!" "!"
    }

myLogHook xmprocs = sequence_ $ zipWith ppForScreen [0..] xmprocs

myManageHook = composeAll
  [ className =? "conky" --> doIgnore  -- Ignore Conky so it doesn't get tiled
  , className =? "floatterm" --> doCenterFloat
  , manageDocks  -- Ensure docks (like xmobar) are managed correctly
  ]
  <+> namedScratchpadManageHook myScratchpads
  <+> manageHook def

makeEmacsScratch :: String -> String -> String -> (Int, Int) -> NamedScratchpad
makeEmacsScratch name windowTitle expr (w, h) =
  NS name spawn (title =? windowTitle) doCenterFloat
  where
    spawn = unwords
      [ "emacsclient -c"
      , "--frame-parameters='((" ++ unwords
          [ "title . \"" ++ windowTitle ++ "\")"
          , "(width . " ++ show w ++ ")"
          , "(height . " ++ show h ++ ")"
          ] ++ ")'"
      , "--eval '" ++ expr ++ "'"
      ]

makeTermScratch :: String -> String -> String -> String -> (Int, Int) -> NamedScratchpad
makeTermScratch name windowClass command options (w, h) =
  NS name spawn (className =? windowClass) doCenterFloat
  where
    base = term ++
           " -c " ++ windowClass ++
           " -g " ++ show w ++ "x" ++ show h

    spawn
      | null command = base
      | null options = base ++ " -e " ++ command
      | otherwise    = base ++ " -e " ++ command ++ " " ++ options

myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ makeTermScratch "spterm" "spterm" "" "" (120, 34)
  , makeTermScratch "spcalc" "spcalc" "bc" "-lq" (50, 20)
  , makeTermScratch "spaudio" "spaudio" "alsamixer" "" (100, 30)
  , makeEmacsScratch "emms" "emms-scratch" "(emms)" (150, 30)
  , makeEmacsScratch "calendar" "calendar-scratch" "(bard/open-calendar)" (90, 15)
  , makeEmacsScratch "agenda" "agenda-scratch" "(bard/default-agenda)" (120, 40)
  , makeEmacsScratch "mail" "mail-scratch" "(notmuch)" (175, 40)
  ]

dmenuSwitchProject :: X ()
dmenuSwitchProject = do
  let names = unlines $ map projectName myProjects
  choice <- io $ runProcessWithInput "dmenu" ["-i", "-p", "Project:"] names
  let trimmed = takeWhile (/= '\n') choice
  when (trimmed /= "") $
    case find ((== trimmed) . projectName) myProjects of
      Just proj -> switchProject proj
      Nothing   -> return ()

moveWindowToProject :: X ()
moveWindowToProject = do
  ws <- gets windowset
  let maybeWin = W.peek ws
  case maybeWin of
    Nothing -> return ()  -- no focused window
    Just w -> do
      let names = unlines $ map projectName myProjects
      choice <- io $ runProcessWithInput "dmenu" ["-i", "-p", "Move window to project:"] names
      let trimmed = takeWhile (/= '\n') choice
      case find ((== trimmed) . projectName) myProjects of
        Just proj -> windows $ W.shift (projectName proj)
        Nothing   -> return ()

myProjects :: [Project]
myProjects =
  [ Project { projectName = "нотация"
            , projectDirectory = "~/Notes/denote"
            , projectStartHook = Just $ do
                spawn "librewolf-bin"
                spawn "emacsclient -c --frame-parameters '((title . \"denote\"))' -e '(dired \"~/Notes/denote\")'"
  },
  Project { projectName = "прог нота"
          , projectDirectory = "~/Notes/denote"
          , projectStartHook = Just $ do
              spawn "librewolf-bin"
              spawn "emacsclient -c --frame-parameters '((title . \"denote\"))' -e '(dired \"~/Notes/denote\")'"
  },
  Project { projectName = "рсс"
          , projectDirectory = "~/"
          , projectStartHook = Just $ do
              spawn "librewolf-bin"
              spawn "emacsclient -c --frame-parameters '((title . \"elfeed\"))' -e '(elfeed)'"
  },

  Project { projectName = "музыка"
          , projectDirectory = "~/"
          , projectStartHook = Just $ do
              spawn "st -e alsamixer"
              spawn "emacsclient -c --frame-parameters '((title . \"music\"))' -e '(emms)'"
  }
  ]
