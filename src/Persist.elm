module Persist (..) where

import LocalStorage exposing (..)
import Types exposing (..)
import Effects exposing (Effects)
import Task
import Json.Encode as Encode
import Json.Decode exposing ((:=))
import Result exposing (Result(..))


key : LocalStorage.Key
key =
    "whichTitWhen"


save : Model -> Effects Action
save { feedings, since } =
    let
        (=>) = (,)

        model =
            let
                encodeFeeding ( time, lactation ) =
                    Encode.object
                        [ "lactation" => Encode.string (toString lactation)
                        , "time" => Encode.float time
                        ]
            in
                Encode.object
                    [ "feedings" => Encode.list (List.map encodeFeeding feedings)
                    , "since" => Encode.float since
                    ]
                    |> Encode.encode 0
    in
        set key model
            |> Effects.task
            |> Effects.map (always NoOp)


restore : Effects Action
restore =
    let
        decodeFeeding =
            let
                decodeTup =
                    Json.Decode.object2
                        (,)
                        ("time" := Json.Decode.float)
                        ("lactation" := Json.Decode.string)

                decodeLactation ( time, lactationString ) =
                    case lactationString of
                        "LeftBreast" ->
                            Ok ( time, LeftBreast )

                        "RightBreast" ->
                            Ok ( time, RightBreast )

                        "Bottle" ->
                            Ok ( time, Bottle )

                        "Done" ->
                            Ok ( time, Done )

                        _ ->
                            Err "Laction Decode Failed"
            in
                Json.Decode.customDecoder
                    decodeTup
                    decodeLactation

        decodeModel : String -> Result String Model
        decodeModel =
            Json.Decode.decodeString
                <| Json.Decode.object2
                    Model
                    ("feedings" := Json.Decode.list decodeFeeding)
                    ("since" := Json.Decode.float)
    in
        Task.toResult (get key)
            |> Task.map
                (\result ->
                    case result `Result.andThen` decodeModel of
                        Ok model ->
                            Clobber (.feedings model)

                        _ ->
                            NoOp
                )
            |> Effects.task
