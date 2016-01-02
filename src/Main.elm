module Main (..) where

import Html exposing (Html)
import Signal exposing (..)
import View exposing (view)
import Time
import List
import Types exposing (..)
import StartApp
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


update : Action -> Model -> (Model, Effects Action)
update _ _ = init

init : (Model, Effects Action)
init =
    ({ feedings = [], since = 0 }, Effects.none)

app : StartApp.App Model
app =
    StartApp.start
        { init = init
        , view = view
        , update = update
        , inputs = []
        }

main : Signal Html
main =
    app.html
