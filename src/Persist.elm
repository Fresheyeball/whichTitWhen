module Persist (save, restore, storage) where

import LocalStorage exposing (..)
import Types exposing (..)
import Effects exposing (Effects)
import Task
import Json.Encode as Encode
import Json.Decode exposing ((:=))
import Result exposing (Result(..))


storage : LocalStorage (List Feeding)
storage =
    let
        encode string =
            let
                encodeFeeding ( time, lactation ) =
                    Encode.object
                        [ ( "lactation", Encode.string (toString lactation) )
                        , ( "time", Encode.float time )
                        ]
            in
                Encode.list (List.map encodeFeeding string)
                    |> Encode.encode 0

        decode =
            let
                tup =
                    Json.Decode.object2
                        (,)
                        ("time" := Json.Decode.float)
                        ("lactation" := Json.Decode.string)

                lactation ( time, lactationString ) =
                    case lactationString of
                        "LeftBreast" ->
                            Ok ( time, LeftBreast )

                        "RightBreast" ->
                            Ok ( time, RightBreast )

                        "Bottle" ->
                            Ok ( time, Bottle )

                        "DoneFeeding" ->
                            Ok ( time, DoneFeeding )

                        "Poo" ->
                            Ok ( time, Poo )

                        "Pee" ->
                            Ok ( time, Pee )

                        "PooAndPee" ->
                            Ok ( time, PooAndPee )

                        _ ->
                            Err "Event Decode Failed"

                feeding =
                    Json.Decode.customDecoder tup lactation
            in
                Json.Decode.list feeding
                    |> Json.Decode.decodeString
    in
        LocalStorage "whichTitWhen" decode encode


save : List Feeding -> Effects Action
save feedings =
    set storage feedings
        |> Task.map (always NoOp)
        |> Effects.task


restore : Effects Action
restore =
    Task.toResult (get storage)
        |> Task.map
            (Result.map Restore >> Result.withDefault NoOp)
        |> Effects.task
