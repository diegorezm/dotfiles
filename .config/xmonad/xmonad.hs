-- Most of this config is from: https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/xmonad/xmonad.hs?ref_type=heads
-- i don't really know haskell and i don't understand half of the stuff that is here

import Colors.Dracula
import Util.Xresources
import Data.Char (toUpper)
import Data.Map qualified as M
import Data.Maybe (fromJust)
import XMonad
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS
import XMonad.Actions.MouseResize (mouseResize)
import XMonad.Actions.Promote (promote)
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Decoration (Theme (..), shrinkText)
import XMonad.Layout.LayoutModifier qualified
import XMonad.Layout.LimitWindows
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, (??))
import XMonad.Layout.MultiToggle qualified as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.ResizableTile (ResizableTall (..))
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest (Simplest (..))
import XMonad.Layout.SimplestFloat (simplestFloat)
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts (subLayout)
import XMonad.Layout.Tabbed (addTabs)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts (toggleLayouts)
import XMonad.Layout.ToggleLayouts qualified as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.WindowArranger (windowArrange)
import XMonad.Layout.WindowNavigation
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions (NamedAction (NamedAction), addDescrKeys, addName, xMessage, (^++^))
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (hPutStrLn, spawnPipe)

-- General settings
myBorderWidth :: Dimension
myBorderWidth = 2

myNormColor, myFocusColor :: String
myNormColor = xProp "xmonad.normalBorderColor"
myFocusColor = xProp "xmonad.focusedBorderColor"

myFont :: String
myFont = "xft:Roboto Mono Medium:regular:size=9:antialias=true:hinting=true"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Named key actions
subtitle' :: String -> ((KeyMask, KeySym), NamedAction)
subtitle' x =
  ( (0, 0),
    NamedAction $ "\n-- " ++ map toUpper x ++ " --\n" ++ replicate (6 + length x) '-'
  )

-- Key bindings
myKeys c =
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks
   in subKeys
        "Core"
        [ ("M-q", addName "Kill the focused window" kill1),
          ("M-S-r", addName "Recompile and restart xmonad" $ spawn "xmonad --recompile && xmonad --restart")
        ]
        ^++^ subKeys
          "Programs"
          [ ("M-<Return>", addName "Spawn terminal" $ spawn "$TERMINAL"),
            ("M-w", addName "Spawn browser" $ spawn "$BROWSER"),
            ("M-d", addName "Run dmenu" $ spawn "dmenu_run"),
            ("M-<F2>", addName "Launch wallpapercl" $ spawn "$TERMINAL -e wallpapercl")
          ]
        ^++^ subKeys
          "Scratch Pads"
          [ ("M-s", addName "Open terminal" $ namedScratchpadAction myScratchPads "terminal"),
            ("M-a", addName "Open volume control" $ namedScratchpadAction myScratchPads "pavucontrol"),
            ("M-e", addName "Open file manager" $ namedScratchpadAction myScratchPads "filemanager")
          ]
        ^++^ subKeys
          "Scripts"
          [ ("M-c", addName "Configs dmenu script" $ spawn "$HOME/.local/bin/scripts/config_quick_search"),
            ("M-z", addName "Directories dmenu script" $ spawn "$HOME/.local/bin/scripts/dir_quick_search"),
            ("M-<F1>", addName "Power dmenu script" $ spawn "$HOME/.local/bin/scripts/power_ctl")
          ]
        ^++^ subKeys
          "Window Navigation"
          [ ("M-j", addName "Focus next window" $ windows W.focusDown),
            ("M-k", addName "Focus prev window" $ windows W.focusUp),
            ("M-m", addName "Focus master window" $ windows W.focusMaster),
            ("M-S-j", addName "Swap with next window" $ windows W.swapDown),
            ("M-S-k", addName "Swap with prev window" $ windows W.swapUp),
            ("M-S-m", addName "Swap with master" $ windows W.swapMaster),
            ("M-S-<Return>", addName "Move to master" promote),
            ("M-S-,", addName "Rotate slaves" rotSlavesDown),
            ("M-S-.", addName "Rotate all" rotAllDown)
          ]
        ^++^ subKeys
          "Layouts"
          [ ("M-<Tab>", addName "Next layout" $ sendMessage NextLayout),
            ("M-<Space>", addName "Toggle full/noborders" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
          ]
        ^++^ subKeys
          "Floating windows"
          [ ("M-f", addName "Toggle float layout" $ sendMessage (T.Toggle "floats")),
            ("M-t", addName "Sink a floating window" $ withFocused $ windows . W.sink),
            ("M-S-t", addName "Sink all floated windows" sinkAll)
          ]
        ^++^ subKeys
          "Monitors"
          [ ("M-.", addName "Focus next monitor" nextScreen),
            ("M-,", addName "Focus prev monitor" prevScreen)
          ]
        -- Multimedia Keys
        ^++^ subKeys
          "Multimedia keys"
          [ ("<XF86AudioPlay>", addName "mocp play" $ spawn "mocp --play"),
            ("<XF86AudioPrev>", addName "mocp next" $ spawn "mocp --previous"),
            ("<XF86AudioNext>", addName "mocp prev" $ spawn "mocp --next"),
            ("<XF86AudioMute>", addName "Toggle audio mute" $ spawn "amixer set Master toggle"),
            ("<XF86AudioLowerVolume>", addName "Lower vol" $ spawn "pamixer -d 10"),
            ("<XF86AudioRaiseVolume>", addName "Raise vol" $ spawn "pamixer -i 10"),
            ("<Print>", addName "Take screenshot" $ spawn "$HOME/.local/bin/scripts/screenshot")
          ]

-- Manage hooks for windows
myManageHook :: ManageHook
myManageHook =
  composeAll
    [ className =? "confirm" --> doFloat,
      className =? "file_progress" --> doFloat,
      className =? "dialog" --> doFloat,
      className =? "download" --> doFloat,
      className =? "error" --> doFloat,
      className =? "Sxiv" --> doFloat,
      className =? "discord" --> doShift (myWorkspaces !! 8),
      className =? "Spotify" --> doShift (myWorkspaces !! 7),
      className =? "steam" --> doShift (myWorkspaces !! 6),
      isDialog --> doFloat,
      isFullscreen --> doFullFloat
    ]
    <+> namedScratchpadManageHook myScratchPads

-- Layouts
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- workspace
myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]

myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

myLayoutHook =
  avoidStruts
    $ mouseResize
    $ windowArrange
    $ toggleLayouts floats
    $ mkToggle
      (NBFULL ?? NOBORDERS ?? EOT)
    $ tiled
      ||| Mirror tiled
      ||| floats
      ||| monocle
  where
    tiled =
      renamed [Replace "tall"] $
        limitWindows 5 $
          smartBorders $
            windowNavigation $
              addTabs shrinkText myTabTheme $
                subLayout [] (smartBorders Simplest) $
                  mySpacing 2 $
                    ResizableTall 1 (3 / 100) (1 / 2) []

    floats = renamed [Replace "float"] simplestFloat

    monocle =
      renamed [Replace "monocle"] $
        smartBorders $
          windowNavigation $
            addTabs shrinkText myTabTheme $
              subLayout [] (smartBorders Simplest) Full

-- Tab layout theme
myTabTheme =
  def
    { fontName = myFont,
      activeColor = color15,
      inactiveColor = color08,
      activeBorderColor = color15,
      inactiveBorderColor = colorBack,
      activeTextColor = colorBack,
      inactiveTextColor = color16
    }

-- Show workspace name
myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:Ubuntu:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1c1f24",
      swn_color = "#ffffff"
    }

-- Autostart programs
myStartupHook :: X ()
myStartupHook = do
  spawn "firefox"
  spawn "spotify-launcher"
  spawn "steam"
  spawn "wallpapercl restore"

-- Scratchpads
myDefaultScratchPadSize = customFloating $ W.RationalRect l t w h
  where
    h = 0.9
    w = 0.9
    t = 0.95 - h
    l = 0.95 - w

myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "terminal" "$TERMINAL -T 'scratchpad'" (title =? "scratchpad") myDefaultScratchPadSize,
    NS "pavucontrol" "pavucontrol" (className =? "pavucontrol") myDefaultScratchPadSize,
    NS "filemanager" "thunar" (className =? "Thunar") myDefaultScratchPadSize
  ]

main :: IO ()
main = do
  xmproc0 <- spawnPipe "xmobar -x 0"
  xmproc1 <- spawnPipe "xmobar -x 1"
  xmonad $
    ewmh $
      docks $
        addDescrKeys
          ((mod4Mask, xK_F3), xMessage)
          myKeys
          def
            { modMask = mod4Mask,
              layoutHook = showWName' myShowWNameTheme myLayoutHook,
              terminal = "$TERMINAL",
              manageHook = myManageHook <+> manageDocks,
              workspaces = myWorkspaces,
              startupHook = myStartupHook,
              borderWidth = myBorderWidth,
              normalBorderColor = myNormColor,
              focusedBorderColor = myFocusColor,
              logHook =
                dynamicLogWithPP $
                  filterOutWsPP [scratchpadWorkspaceTag] $
                    xmobarPP
                      { ppOutput = \x ->
                          hPutStrLn xmproc0 x
                            >> hPutStrLn xmproc1 x,
                        ppCurrent =
                          xmobarColor color06 ""
                            . wrap
                              ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">")
                              "</box>",
                        ppVisible = xmobarColor color06 "" . clickable,
                        -- Hidden workspace
                        ppHidden =
                          xmobarColor color05 ""
                            . wrap
                              ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">")
                              "</box>"
                            . clickable,
                        -- Hidden workspaces (no windows)
                        ppHiddenNoWindows = xmobarColor color05 "" . clickable,
                        -- Title of active window
                        ppTitle = xmobarColor color16 "" . shorten 30,
                        -- Separator character
                        ppSep = "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>",
                        -- Urgent workspace
                        ppUrgent = xmobarColor color02 "" . wrap "!" "!",
                        -- order of things in xmobar
                        ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                      }
            }
