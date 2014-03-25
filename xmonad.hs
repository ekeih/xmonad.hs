--------------------------------------------------
-- Max Rosin                                    --
-- xmonad:         0.11                         --
-- xmonad-contrib: 0.11.2                       --
--------------------------------------------------

--------------------------------------------------
-- XMonad ----------------------------------------
--------------------------------------------------
import XMonad
import XMonad.StackSet              (view, shift)
import XMonad.Util.EZConfig         (additionalKeysP, removeKeysP)

--------------------------------------------------
-- Hooks -----------------------------------------
--------------------------------------------------
import XMonad.Hooks.Place           (placeHook, smart)
import XMonad.Hooks.Script          (execScriptHook)

--------------------------------------------------
-- Actions ---------------------------------------
--------------------------------------------------
import XMonad.Actions.GridSelect    (goToSelected, defaultGSConfig)
import XMonad.Actions.Plane         (Lines(..), Limits(Circular), Direction(ToRight, ToLeft, ToUp, ToDown), planeMove, planeShift)
import XMonad.Actions.UpdatePointer (PointerPosition(Relative), updatePointer)

--------------------------------------------------
-- Layouts ---------------------------------------
--------------------------------------------------
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Grid           (Grid(..))
import XMonad.Layout.IM             (Property(Title), withIM)
import XMonad.Layout.NoBorders      (noBorders, smartBorders)
import XMonad.Layout.PerWorkspace   (onWorkspace)
import XMonad.Layout.ShowWName      (showWName', defaultSWNConfig, swn_font, swn_bgcolor, swn_color, swn_fade)
import XMonad.Layout.Tabbed         (simpleTabbed)
import XMonad.Layout.WorkspaceDir   (workspaceDir)

--------------------------------------------------
-- Haskell ---------------------------------------
--------------------------------------------------
import Control.Monad                (liftM2)
import Data.Ratio                   ((%))


--------------------------------------------------
-- Main ------------------------------------------
--------------------------------------------------
main = xmonad confMine
confMine = defaultConfig {
    borderWidth         = confBorderWidth,
    focusedBorderColor  = confColorBorderActive,
    focusFollowsMouse   = confFocusFollowsMouse,
    layoutHook          = showWName' confShowWName confLayout,
    logHook             = updatePointer (Relative 0.9 0.9),
    manageHook          = confManageHook,
    modMask             = confMod,
    normalBorderColor   = confColorBorder,
    startupHook         = execScriptHook "startup",
    terminal            = confTerminal,
    workspaces          = confWorkspaces
} `additionalKeysP` confKeys `removeKeysP` confRemoveKeys

--------------------------------------------------
-- Programs --------------------------------------
--------------------------------------------------
confBrowser         = "firefox"
confChat            = "pidgin"
confFilemanager     = "pcmanfm"
confGeditor         = "geany"
confLockscreen      = confBinDir ++ "lockscreen"
confMail            = "thunderbird"
confTerminal        = "terminator"
confTerminalTemp    = "urxvt -name tempTerm"

--------------------------------------------------
-- Settings --------------------------------------
--------------------------------------------------
confMod                 = mod4Mask
confFocusFollowsMouse   = False
confHomeDir             = "/home/ekeih/"
confXMonadDir           = confHomeDir ++ ".xmonad/"
confBinDir              = confXMonadDir ++ "data/bin/"

--------------------------------------------------
-- Theme -----------------------------------------
--------------------------------------------------
solarizedBase03  = "#002b36"
solarizedBase02  = "#073642"
solarizedBase01  = "#586e75"
solarizedBase00  = "#657b83"
solarizedBase0   = "#839496"
solarizedBase1   = "#93a1a1"
solarizedBase2   = "#eee8d5"
solarizedBase3   = "#fdf6e3"
solarizedYellow  = "#b58900"
solarizedOrange  = "#cb4b16"
solarizedRed     = "#dc322f"
solarizedMagenta = "#d33682"
solarizedViolet  = "#6c71c4"
solarizedBlue    = "#268bd2"
solarizedCyan    = "#2aa198"
solarizedGreen   = "#859900"

confBorderWidth         = 1
confColorText           = solarizedBase01
confColorBackground     = solarizedBase03
confColorBorder         = solarizedBase01
confColorBorderActive   = solarizedOrange

confShowWName = defaultSWNConfig {
    swn_font    = "-misc-fixed-*-*-*-*-14-*-*-*-*-*-*-*",
    swn_bgcolor = solarizedBase03,
    swn_color   = solarizedBase01,
    swn_fade    = 1/2
    }

--------------------------------------------------
-- Workspaces ------------------------------------
--------------------------------------------------
confWorkspaces              = confStandardWorkspaces ++ confAdditionalWorkspaces
confStandardWorkspaces      = ["Chat", "Mail", "Web", "Term", "Doc", "Notes", "Media", "Sandbox",    "Misc"             ]
confAdditionalWorkspaces    = ["1",    "2",    "3",   "4",    "Uni", "TheGI", "Prog2", "Stochastik", "Rechnersicherheit"]

--------------------------------------------------
-- Matching Rules --------------------------------
--------------------------------------------------
confManageHook = composeAll $ urxvt:tempTerm:concat [
    [ className =? c --> doShift   "Chat"   | c <- classChat    ],
    [ className =? c --> doShift   "Mail"   | c <- classMail    ],
    [ className =? c --> doShift   "Web"    | c <- classWeb     ],
    [ className =? c --> viewShift "Term"   | c <- classTerm    ],
    [ className =? c --> viewShift "Doc"    | c <- classDoc     ],
    [ className =? c --> viewShift "Notes"  | c <- classNotes   ],
    [ className =? c --> viewShift "Media"  | c <- classMedia   ],
    [ className =? c --> viewShift "Misc"   | c <- classMisc    ]
    ] where viewShift = doF . liftM2 (.) view shift
            classChat   = ["Pidgin", "Mumble", "Xchat", "Skype"]
            classMail   = ["Thunderbird"]
            classWeb    = ["Firefox", "Chromium"]
            classTerm   = ["Terminator"]
            classDoc    = ["Okular", "LibreOffice", "libreoffice-startcenter", "Anki"]
            classNotes  = ["Xournal"]
            classMedia  = ["Vlc"]
            classMisc   = ["Keepassx"]
            urxvt       = className =? "URxvt" <&&> resource =? "urxvt"     --> viewShift "Term"
            tempTerm    = className =? "URxvt" <&&> resource =? "tempTerm"  --> placeHook (smart (1,1)) <+> doFloat

--------------------------------------------------
-- Layouts ---------------------------------------
--------------------------------------------------
confLayout =
    onWorkspace "Chat"              confChatLayout              $
    onWorkspace "Mail"              confMailLayout              $
    onWorkspace "Doc"               confDocLayout               $
    onWorkspace "Uni"               confUniLayout               $
    onWorkspace "TheGI"             confTheGILayout             $
    onWorkspace "Prog2"             confProg2Layout             $
    onWorkspace "Stochastik"        confStochastikLayout        $
    onWorkspace "Rechnersicherheit" confRechnersicherheitLayout $
    workspaceDir confHomeDir (confDefaultLayout)
    where
        confChatLayout              = workspaceDir (confHomeDir ++ "Dokumente") (noBorders(withIM (1%6) (Title "Buddy List") (confTabbedLayout ||| Mirror(Tall 1 (3/100) (1/2)))))
        confMailLayout              = workspaceDir (confHomeDir ++ "Dokumente") ((centerMaster confTabbedLayout) ||| confTabbedLayout ||| Grid)
        confDocLayout               = workspaceDir (confHomeDir ++ "Dokumente")                             (confDefaultLayout)
        confUniLayout               = workspaceDir (confHomeDir ++ "Studium/6_Semester")                    (confDefaultLayout)
        confTheGILayout             = workspaceDir (confHomeDir ++ "Studium/6_Semester/TheGI2")             (confDefaultLayout)
        confProg2Layout             = workspaceDir (confHomeDir ++ "Studium/6_Semester/Prog2")              (confDefaultLayout)
        confStochastikLayout        = workspaceDir (confHomeDir ++ "Studium/6_Semester/Stochastik")         (confDefaultLayout)
        confRechnersicherheitLayout = workspaceDir (confHomeDir ++ "Studium/6_Semester/Rechnersicherheit")  (confDefaultLayout)
        confDefaultLayout           = smartBorders(confTabbedLayout ||| Tall 1 (3/100) (1/2) ||| Mirror(Tall 1 (3/100) (1/2)) ||| Grid ||| confCenterMasterGrid ||| Full)
        confTabbedLayout            = noBorders(simpleTabbed)
        confCenterMasterGrid        = smartBorders(centerMaster Grid)

--------------------------------------------------
-- Keybindings -----------------------------------
--------------------------------------------------
confKeys =
    [
        -- Window-Grid
        ("M-g", goToSelected defaultGSConfig),
        -- media keys
        ("<XF86AudioMute>",         spawn "amixer set Master toggle; notify-send -a amixer $(amixer get Master | tail -n 1 | sed 's/.*\\[\\(on\\|off\\)\\].*/Sound: \\1/')"),
        ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 2+; notify-send -a amixer $(amixer get Master | tail -n 1 | sed 's/.*\\[\\([0-9]\\{1,3\\}%\\)\\].*/Sound: \\1/')"),
        ("<XF86AudioLowerVolume>",  spawn "amixer set Master 2-; notify-send -a amixer $(amixer get Master | tail -n 1 | sed 's/.*\\[\\([0-9]\\{1,3\\}%\\)\\].*/Sound: \\1/')"),
        ("<XF86MonBrightnessUp>",   spawn "xbacklight -inc 5"),
        ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5"),
        -- start programs
        ("M-<Return>",  spawn confTerminal),
        ("M-S-<Return>",spawn confTerminalTemp),
        ("M-<F10>",     spawn "autorandr -c"),
        ("M-<F11>",     spawn confGeditor),
        ("M-<F12>",     spawn confLockscreen),
        ("M-b",         spawn confFilemanager),
        ("M-x",         spawn "dmenu_run"),
        ("M-s",         spawn $ confBinDir ++ "menu"),
        -- set random background
        ("<XF86Launch1>", execScriptHook "background"),
        -- Workspaces - Grid movement
        ("M-<Up>",      planeMove  (Lines 2) Circular ToUp),
        ("M-S-<Up>",    planeShift (Lines 2) Circular ToUp),
        ("M-<Down>",    planeMove  (Lines 2) Circular ToDown),
        ("M-S-<Down>",  planeShift (Lines 2) Circular ToDown),
        ("M-<Right>",   planeMove  (Lines 2) Circular ToRight),
        ("M-S-<Right>", planeShift (Lines 2) Circular ToRight),
        ("M-<Left>",    planeMove  (Lines 2) Circular ToLeft),
        ("M-S-<Left>",  planeShift (Lines 2) Circular ToLeft)
    ]  ++
    -- Workspaces M+(F)[1-9]
    [(("M-" ++ [k]), windows $ view i) | (i,k) <- zip confStandardWorkspaces ['1'..'9']] ++
    [(("M-<F" ++ [k] ++ ">"), windows $ view i) | (i,k) <- zip confAdditionalWorkspaces['1'..'9']]

-- remove some unnecessary default keybindings
confRemoveKeys =
    [
        "M-p"
    ]
