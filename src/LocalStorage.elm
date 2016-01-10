module LocalStorage (..) where

import Native.LocalStorage
import Task exposing (..)


type alias LocalStorage a =
    { key : String
    , decode : String -> Result String a
    , encode : a -> String
    }


get : LocalStorage a -> Task String a
get { key, decode } =
    let
        getRaw : String -> Task String String
        getRaw = Native.LocalStorage.get
    in
        getRaw key
            `andThen` (decode >> fromResult)


set : LocalStorage a -> a -> Task x ()
set { key, encode } =
    let
        setRaw : String -> String -> Task x ()
        setRaw = Native.LocalStorage.set
    in
        encode >> setRaw key


localStorage : String -> (String -> Result String a) -> (a -> String) -> LocalStorage a
localStorage key decode encode =
    { key = key
    , decode = decode
    , encode = encode
    }
