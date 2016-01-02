module View (..) where

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Evt
import Date
import Date.Format exposing (format)
import Types exposing (..)
import Signal exposing (Address)
import String
import Time


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
                [ text <| format "%d/%m/%Y %I:%M %P" <| Date.fromTime date ]
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


toolBar : Address Action -> Html
toolBar address =
    let
        tool text' lactation =
            div
                [ Attr.class "item"
                , Evt.onClick address (Add lactation)
                ]
                [ text text' ]
    in
        div
            [ Attr.class "ui four item fixed menu"
            , Attr.style [ ( "cursor", "pointer" ) ]
            ]
            [ tool "Left Breast" LeftBreast
            , tool "Right Breast" RightBreast
            , tool "Bottle" Bottle
            , tool "Done" Done
            ]


timer : Time.Time -> Html
timer time =
    let
        showTime inUnits moder =
            time
                |> inUnits
                |> floor
                |> (\x -> x % moder)
                |> toString
                |> \i ->
                    if String.length i < 2 then
                        "0" ++ i
                    else
                        i

        formated =
            String.join
                ":"
                [ showTime Time.inHours 24
                , showTime Time.inMinutes 60
                , showTime Time.inSeconds 60
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


since : List Feeding -> Time.Time -> Time.Time
since feedings now =
    let
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
    in
        now - Maybe.withDefault now (lastDone feedings)


view : Address Action -> Model -> Html
view address { feedings, time } =
    div
        []
        [ css
        , toolBar address
        , renderFeedings feedings
        , timer (since feedings time)
        ]
