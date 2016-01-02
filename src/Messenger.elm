module Messenger (input, output) where

import Signal exposing (Mailbox, mailbox)
import Types exposing (Action, Feeding)
import StorageBox exposing (..)
import Maybe
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
            Maybe.map
                (\feeding -> ( Date.fromTime time, feeding ))
                mfeeding
    in
        Signal.map
            transform
            (Time.timestamp (.signal messanger))
