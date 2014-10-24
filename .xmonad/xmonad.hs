import XMonad
{-import XMonad.Actions.Volume-}
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import System.IO

myTerminal :: String
myTerminal = "urxvt"

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks  <+> manageHook defaultConfig
        , layoutHook = avoidStruts   $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 100
                        }
        , terminal = myTerminal
        , focusFollowsMouse = False
        } `additionalKeys`
        [ ((controlMask, xK_Print), spawn "scrot -d 2 -s")
        , ((0, xK_Print), spawn "scrot")
        {-, ((controlMask .|. shiftMask, xK_k), spawn myTerminal)-}
        {-, ((controlMask .|. shiftMask, xK_p), spawn "pcmanfm")-}
        {-, ((controlMask .|. shiftMask, xK_i), spawn "chromium")-}
        {-, ((0, xK_F6), void $ lowerVolume 4)-}
        {-, ((0, xK_F7), void $ raiseVolume 4)-}
        -- TODO: Toggle Mute
        ]
