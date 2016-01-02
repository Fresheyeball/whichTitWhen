module Main (..) where

import Html exposing (Html)
import Signal exposing (..)
import Debug
import View exposing (view)
import Time
import List
import Date
import Types exposing (..)
import Messenger exposing (output)


lastDone : List Feeding -> Maybe Time.Time
lastDone =
    let
        f ( date, action ) mdone =
            case mdone of
                Nothing ->
                    if action == Done then
                        Just (Date.toTime date)
                    else
                        Nothing

                _ ->
                    mdone
    in
        List.foldl f Nothing


update : Maybe Feeding -> List Feeding -> List Feeding
update mf feedings =
    Debug.watch "Model"
        <| case mf of
            Just feeding ->
                feeding :: feedings

            _ ->
                feedings


munge : Time.Time -> List Feeding -> Html
munge now feedings =
    view
        (now - Maybe.withDefault now (lastDone feedings))
        feedings


main : Signal Html
main =
    Signal.map2
        munge
        (Time.every Time.second)
        (Signal.foldp update [] output)
