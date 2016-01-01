module Main (..) where

import Html exposing (..)
import Html.Attributes as Attr
import Date exposing (Date)
import Date.Format exposing (format)
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
        showDate date =
            format "%d/%m/%Y %I:%M %P" date

        ( message, date, icon ) =
            case feeding of
                LeftBreast date ->
                    ( "Left", date, "caret left" )

                RightBreast date ->
                    ( "Right", date, "caret right" )

                Done date ->
                    ( "Finished", date, "star" )
    in
        tr
            []
            [ td
                [ Attr.class "collapsing" ]
                [ i
                    [ Attr.class <| "icon " ++ icon ]
                    []
                , text message
                ]
            , td
                []
                [ text <| showDate date ]
            ]


renderFeedings : List Feeding -> Html
renderFeedings feedings =
    table
        [ Attr.class "ui celled striped table" ]
        [ tbody
            []
            (List.map renderFeeding feedings)
        ]


css : Html
css =
    let
        link' package =
            let
                url =
                    "http://oss.maxcdn.com/"
                        ++ "semantic-ui/2.1.7/"
                        ++ package
                        ++ ".min.css"
            in
                node
                    "link"
                    [ Attr.rel "stylesheet"
                    , Attr.type' "text/css"
                    , Attr.href url
                    ]
                    []
    in
        div
            []
            [ link' "semantic"
            , link' "components/table"
            , link' "components/icon"
            , link' "components/menu"
            ]


toolBar : Html
toolBar =
    let
        tool text' =
            div
                [ Attr.class "item" ]
                [ text text' ]
    in
        div
            [ Attr.class "ui four item fixed menu" ]
            [ tool "Left Breast"
            , tool "Right Breast"
            , tool "Bottle"
            , tool "Finished"
            ]


view : Model -> Html
view feedings =
    div
        []
        [ css
        , toolBar
        , div
            [ Attr.class "ui main text container"
            , Attr.style [ ( "margin-top", "50px" ) ]
            ]
            [ renderFeedings feedings ]
        ]


main : Html
main =
    view [ LeftBreast (Date.fromTime 1451604066913), RightBreast (Date.fromTime 1451604066913) ]
