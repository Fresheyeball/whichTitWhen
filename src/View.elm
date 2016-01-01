module View (..) where

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Evt
import Date.Format exposing (format)
import Types exposing (..)
import Messanger


renderFeeding : Feeding -> Html
renderFeeding ( date, action ) =
    let
        ( message, icon ) =
            case action of
                LeftBreast ->
                    ( "Left", "caret left" )

                RightBreast ->
                    ( "Right", "caret right" )

                Bottle ->
                    ( "Bottle", "caret up" )

                Done ->
                    ( "Finished", "star" )
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
                [ text <| format "%d/%m/%Y %I:%M %P" date ]
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
        tool text' action =
            div
                [ Attr.class "item"
                , Evt.onClick Messanger.input action
                ]
                [ text text' ]
    in
        div
            [ Attr.class "ui four item fixed menu" ]
            [ tool "Left Breast" LeftBreast
            , tool "Right Breast" RightBreast
            , tool "Bottle" Bottle
            , tool "Done" Done
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
