module Main (..) where

import Html exposing (Html)
import Signal exposing (..)
import Debug
import View exposing (view)
import Types exposing (..)
import Messanger exposing (output)


initial : Model
initial =
    []


update : Maybe Feeding -> Model -> Model
update mf model =
    case mf of
        Just feeding ->
            feeding :: model

        _ ->
            model


main : Signal Html
main =
    Signal.foldp update initial output
        |> Debug.watch "Model"
        |> Signal.map view
