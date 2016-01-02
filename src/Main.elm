module Main (..) where

import Html exposing (Html)
import Signal exposing (..)
import View exposing (view)
import Time
import List
import Types exposing (..)
import StartApp
import Persist
import Task exposing (Task)
import Effects exposing (Effects, Never)


update : Action -> Model -> ( Model, Effects Action )
update action { feedings, time } =
    let
        feedings' =
            case action of
                Add lactation ->
                    ( time', lactation ) :: feedings

                Restore feedingsFromStorage ->
                    Debug.log "restored" feedingsFromStorage

                _ ->
                    feedings

        time' =
            case action of
                Tick now ->
                    now

                _ ->
                    time

        model' =
            { feedings = feedings'
            , time = time'
            }

        effects' =
            case action of
                Add _ ->
                    Persist.save (.feedings model')

                _ ->
                    Effects.none
    in
        ( model', effects' )


init : ( Model, Effects Action )
init =
    ( { feedings = [], time = 0 }, Persist.restore )


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


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks


main : Signal Html
main =
    app.html
