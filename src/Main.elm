module Main (..) where

import Html exposing (Html)
import Signal exposing (..)
import Debug
import View exposing (view)
import Time
import List
import Types exposing (..)
import Messenger exposing (output)
import Persist exposing (storage)
import Task exposing (Task)


lastDone : List Feeding -> Maybe Time.Time
lastDone =
    let
        f ( date, action ) mdone =
            case mdone of
                Nothing ->
                    if action == Done then
                        Just date
                    else
                        Nothing

                _ ->
                    mdone
    in
        List.foldl f Nothing


update : Maybe Action -> List Feeding -> List Feeding
update mf feedings =
    Debug.log "Model"
        <| case mf of
            Just action ->
                case action of
                    Add feeding ->
                        feeding :: feedings

                    Delete feeding ->
                        List.filter ((/=) feeding) feedings

                    Clobber feedings' ->
                        feedings'

            _ ->
                feedings


munge : Time.Time -> List Feeding -> Html
munge now feedings =
    view
        (now - Maybe.withDefault now (lastDone feedings))
        feedings


port save : Signal (Task x ())
port save =
    Signal.foldp update [] output
        |> Signal.map (Signal.send (.address storage))


main : Signal Html
main =
    Signal.map2
        munge
        (Time.every Time.second)
        (.signal storage)
