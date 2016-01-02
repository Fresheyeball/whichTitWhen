module LocalStorage (..) where

import Native.LocalStorage
import Task exposing (Task)


type alias Key =
    String


get : Key -> Task String String
get =
    Native.LocalStorage.get


set : Key -> String -> Task x ()
set =
    Native.LocalStorage.set
