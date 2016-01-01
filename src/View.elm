module View (..) where

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Evt
import Date.Format exposing (format)
import Types exposing (..)
import String
import Time
import Messanger


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
    div
        [ Attr.class "ui main text container"
        , Attr.style [ ( "margin-top", "50px" ) ]
        ]
        [ table
            [ Attr.class "ui celled striped table" ]
            [ tbody
                []
                (List.map renderFeeding feedings)
            ]
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


timer : Time.Time -> Html
timer time =
    let
        showTime =
            floor
                >> clamp 0 100
                >> toString
                >> \i ->
                    if String.length i < 2 then
                        "0" ++ i
                    else
                        i

        formated =
            String.join
                ":"
                [ showTime
                    (Time.inHours time)
                , showTime
                    (Time.inMinutes time)
                , showTime
                    (Time.inSeconds time)
                ]

        style =
            [ ( "bottom", "0" )
            , ( "left", "0" )
            , ( "position", "fixed" )
            , ( "padding", "15px" )
            ]
    in
        div
            [ Attr.class "ui item header"
            , Attr.style style
            ]
            [ text formated ]


view : Time.Time -> List Feeding -> Html
view since feedings =
    div
        []
        [ css
        , toolBar
        , renderFeedings feedings
        , timer since
        ]
