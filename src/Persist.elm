module Persist (save, restore) where

import LocalStorage
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
                Encode.list (List.map encodeFeeding feedings)
                    |> Encode.encode 0
    in
        LocalStorage.set key feedings'
            |> Task.map (always NoOp)
            |> Effects.task


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

        decodeModel =
            Json.Decode.decodeString
                <| Json.Decode.list decodeFeeding
    in
        Task.toResult (LocalStorage.get key)
            |> Task.map
                (\result ->
                    case Debug.log "result" result `Result.andThen` decodeModel of
                        Ok feedings ->
                            Restore feedings

                        _ ->
                            NoOp
                )
            |> Effects.task
