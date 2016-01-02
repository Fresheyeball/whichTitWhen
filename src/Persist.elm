module Persist (save, restore) where

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


save : List Feeding -> Effects Action
save feedings =
    let
        (=>) = (,)

        feedings' =
            let
                encodeFeeding ( time, lactation ) =
                    Encode.object
                        [ "lactation" => Encode.string (toString lactation)
                        , "time" => Encode.float time
                        ]
            in
                Encode.object
                    [ "feedings" => Encode.list (List.map encodeFeeding feedings)
                    ]
                    |> Encode.encode 0
    in
        set key feedings'
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

        decodeModel : String -> Result String (List Feeding)
        decodeModel =
            Json.Decode.decodeString
                <| ("feedings" := Json.Decode.list decodeFeeding)
    in
        Task.toResult (get key)
            |> Task.map
                (\result ->
                    case result `Result.andThen` decodeModel of
                        Ok feedings ->
                            Clobber feedings

                        _ ->
                            NoOp
                )
            |> Effects.task
