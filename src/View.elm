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


meta : String -> String -> Html
meta name content =
    node
        "meta"
        [ Attr.name "viewport"
        , Attr.content "width=device-width, initial-scale=1"
        ]
        []


mobile : Html
mobile =
    div
        []
        [ meta "viewport" "width=device-width, initial-scale=1"
        , meta "apple-mobile-web-app-capable" "yes"
        , node "link" [ Attr.rel "apple-touch-icon", Attr.href "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Breastfeeding-icon-med.svg/2000px-Breastfeeding-icon-med.svg.png" ] []
        ]


renderFeeding : Address Action -> Feeding -> Html
renderFeeding address ( time, lactation ) =
    let
        ( message, icon ) =
            case lactation of
                LeftBreast ->
                    ( "Left", "caret left" )

                RightBreast ->
                    ( "Right", "caret right" )

                Bottle ->
                    ( "Bottle", "circle thin" )

                DoneFeeding ->
                    ( "Feed", "star" )

                Poo ->
                    ( "Poo", "sort descending" )

                Pee ->
                    ( "Pee", "sort ascending" )

                PooAndPee ->
                    ( "Poo & Pee", "sort" )
    in
        tr
            [ Attr.style [ ( "background", eventColor lactation ), ( "color", "white" ) ] ]
            [ td
                [ Attr.class "collapsing" ]
                [ i
                    [ Attr.class <| "icon " ++ icon ]
                    []
                , text message
                ]
            , td
                []
                [ text <| format "%d/%m/%Y %I:%M %P" <| Date.fromTime time ]
            , td
                [ Attr.class "collapsing" ]
                [ i
                    [ Attr.class <| "icon x"
                    , Attr.style [ ( "cursor", "pointer" ) ]
                    , Evt.onClick address (Delete ( time, lactation ))
                    ]
                    []
                ]
            ]


renderFeedings : Address Action -> List Feeding -> Html
renderFeedings address feedings =
    div
        [ Attr.class "ui main text container"
        , Attr.style [ ( "margin-top", "65px" ) ]
        ]
        [ table
            [ Attr.class "ui celled striped table unstackable" ]
            [ tbody
                []
                (List.map (renderFeeding address) feedings)
            ]
        ]


eventColor : Event -> String
eventColor lac =
    case lac of
        LeftBreast ->
            "#2185d0"

        RightBreast ->
            "#a333c8"

        Bottle ->
            "#f2711c"

        DoneFeeding ->
            "#767676"

        Pee ->
            "#DEA90B"

        Poo ->
            "#653800"

        PooAndPee ->
            "#7B7825"


toolBar : Address Action -> Html
toolBar address =
    let
        tool text' lactation =
            div
                [ Attr.class ("item inverted")
                , Attr.style [ ( "color", "white" ), ( "background", eventColor lactation ) ]
                , Evt.onClick address (Add lactation)
                ]
                [ text text' ]
    in
        div
            [ Attr.class "ui seven item fixed menu"
            , Attr.style [ ( "cursor", "pointer" ) ]
            ]
            [ tool "Left Breast" LeftBreast
            , tool "Right Breast" RightBreast
            , tool "Bottle" Bottle
            , tool "Feed" DoneFeeding
            , tool "Poo" Poo
            , tool "Pee" Pee
            , tool "Poo & Pee" PooAndPee
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
            , ( "background", "white" )
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
        lastDoneFeeding =
            let
                f ( date, action ) mdone =
                    case mdone of
                        Nothing ->
                            if action == DoneFeeding then
                                Just date
                            else
                                Nothing

                        _ ->
                            mdone
            in
                List.foldl f Nothing
    in
        now - Maybe.withDefault now (lastDoneFeeding feedings)


view : Address Action -> Model -> Html
view address { feedings, time } =
    div
        []
        [ mobile
        , css
        , toolBar address
        , renderFeedings address feedings
        , timer (since feedings time)
        ]
