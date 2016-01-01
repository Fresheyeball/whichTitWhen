module Main (..) where

import Html exposing (Html)
import Date
import Signal exposing (..)
import View exposing (view)
import Types exposing (..)


initial : Model
initial =
    []


messanger : Mailbox (Maybe Action)
messanger =
    mailbox Nothing


update : Maybe Action -> Model -> Model
update maction feedings =
    [ ( Date.fromTime 1451604066913, LeftBreast ), ( Date.fromTime 1451604066913, RightBreast ) ]


main : Signal Html
main =
    Signal.foldp update initial (.signal messanger)
        |> Signal.map view
