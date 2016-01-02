module Messenger (input, output) where

import Signal exposing (Mailbox, mailbox)
import Signal.Extra exposing (fairMerge)
import Types exposing (Lactation, Feeding, Action(..))
import Persist exposing (storage)
import Maybe
import Time
import Debug


messenger : Mailbox (Maybe Lactation)
messenger =
    mailbox Nothing


input : Signal.Address Lactation
input =
    Signal.forwardTo (.address messenger) Just


output : Signal (Maybe Action)
output =
    let
        add =
            let
                transform ( time, mfeeding ) =
                    Maybe.map
                        (\feeding -> Add ( time, feeding ))
                        mfeeding
            in
                .signal messenger
                    |> Time.timestamp
                    |> Signal.map transform

        clobber =
            .signal storage
                |> Signal.map (Clobber >> Just >> Debug.log "Clobber")
    in
        Signal.map (Debug.log "Actions") <| fairMerge (\l r -> l) clobber add
