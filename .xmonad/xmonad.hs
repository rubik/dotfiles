import XMonad
import System.IO
import Data.Bits ((.|.))
import Control.Monad (liftM2)
{-import XMonad.Actions.Volume-}
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)

myTerminal :: String
myTerminal = "urxvt"

myWorkspaces :: [String]
myWorkspaces = ["dev", "web"] ++ map show [3..9]

myManageHook = composeAll . concat $
    [ -- Applications that go to dev
      [ className =? c --> doShift w | (c, w) <- classShifts ]
    , [ manageDocks ]
    ]
    where classShifts = [ ("urxvt", "dev")
                        , ("Chromium", "web")
                        ]

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts   $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 100
                        }
        , terminal = myTerminal
        , workspaces = myWorkspaces
        , focusFollowsMouse = False
        } `additionalKeys`
        [ ((controlMask, xK_Print), spawn "scrot -d 2 -s")
        , ((0, xK_Print), spawn "scrot")
        , (((mod1Mask .|. shiftMask), xK_p), spawn "pcmanfm")
        , (((mod1Mask .|. shiftMask), xK_i), spawn "chromium")
        {-, ((controlMask .|. shiftMask, xK_k), spawn myTerminal)-}
        {-, ((controlMask .|. shiftMask, xK_p), spawn "pcmanfm")-}
        {-, ((controlMask .|. shiftMask, xK_i), spawn "chromium")-}
        {-, ((0, xK_F6), void $ lowerVolume 4)-}
        {-, ((0, xK_F7), void $ raiseVolume 4)-}
        -- TODO: Toggle Mute
        ]
