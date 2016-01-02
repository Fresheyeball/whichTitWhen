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


update : Action -> Model -> ( Model, Effects Action )
update action { feedings, time } =
    let
        feedings' =
            case action of
                Add lactation ->
                    ( time', lactation ) :: feedings

                Clobber feedingsFromStorage ->
                    feedingsFromStorage

                _ ->
                    feedings

        time' =
            case action of
                Tick now ->
                    now

                _ ->
                    time

        model =
            { feedings = feedings'
            , time = time'
            }

        effects =
            case action of
                Add _ ->
                    Persist.save (.feedings model)

                _ ->
                    Effects.none
    in
        ( model, effects )


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


main : Signal Html
main =
    app.html
