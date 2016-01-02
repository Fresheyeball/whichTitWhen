module Main (..) where

import Html exposing (Html)
import Signal exposing (..)
import View exposing (view)
import Time
import List
import Types exposing (..)
import StartApp
import Persist
import Effects exposing (Effects)


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


update : Action -> Model -> ( Model, Effects Action )
update action { feedings, since } =
    let
        feedings' =
            case action of
                Add lactation ->
                    ( since, lactation ) :: feedings

                Clobber feedingsFromStorage ->
                    feedingsFromStorage

                _ ->
                    feedings

        since' =
            case action of
                Tick now ->
                    now - Maybe.withDefault now (lastDone feedings')

                _ ->
                    since

        model =
            { feedings = feedings'
            , since = since'
            }

        effects =
            case action of
                Add _ ->
                    Persist.save model

                _ ->
                    Effects.none
    in
        ( model, effects )


init : ( Model, Effects Action )
init =
    ( { feedings = [], since = 0 }, Persist.restore )


everySecond : Signal Action
everySecond =
    Time.every Time.second
        |> Signal.map Tick


app : StartApp.App Model
app =
    StartApp.start
        { init = init
        , view = view
        , update = update
        , inputs = [ everySecond ]
        }


main : Signal Html
main =
    app.html
