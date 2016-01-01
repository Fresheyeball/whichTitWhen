module Messanger (input, output) where

import Signal exposing (Mailbox, mailbox)
import Types exposing (Action, Feeding)
import Time
import Date


messanger : Mailbox (Maybe Action)
messanger =
    mailbox Nothing


input : Signal.Address Action
input =
    Signal.forwardTo (.address messanger) Just


output : Signal (Maybe Feeding)
output =
    let
        transform ( time, mfeeding ) =
            case mfeeding of
                Nothing ->
                    Nothing

                Just feeding ->
                    Just ( Date.fromTime time, feeding )
    in
        Time.timestamp (.signal messanger)
            |> Signal.map transform
