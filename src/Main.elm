module Main (..) where

import Html exposing (..)
import Date exposing (Date)
import List


type Feeding
    = LeftBreast Date
    | RightBreast Date
    | Done Date


type alias Model =
    List Feeding


renderFeeding : Feeding -> Html
renderFeeding feeding =
    let
        showDate = Date.toTime >> toString

        message =
            case feeding of
                LeftBreast date ->
                    "Left at: " ++ showDate date

                RightBreast date ->
                    "Right at: " ++ showDate date

                Done date ->
                    "Finished at: " ++ showDate date
    in
        div [] [ text message ]


view : Model -> Html
view feedings =
    List.map renderFeeding feedings
        |> div
            []


main : Html
main =
    view [ LeftBreast (Date.fromTime 1451604066913) ]
