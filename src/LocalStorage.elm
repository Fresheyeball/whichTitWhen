module LocalStorage (..) where

import Native.LocalStorage
import Task exposing (..)


type alias LocalStorage a =
    { key : String
    , decode : String -> Result String a
    , encode : a -> String
    }


getRaw : String -> Task String String
getRaw =
    Native.LocalStorage.get


get : LocalStorage a -> Task String a
get { key, decode } =
    getRaw key
        `andThen` (Debug.log "pre" >> decode >> Debug.log "post" >> fromResult)


setRaw : String -> String -> Task x ()
setRaw =
    Native.LocalStorage.set


set : LocalStorage a -> a -> Task x ()
set { key, encode } =
    encode >> setRaw key


localStorage : String -> (String -> Result String a) -> (a -> String) -> LocalStorage a
localStorage key decode encode =
    { key = key
    , decode = decode
    , encode = encode
    }
