module Persist (save, restore, encodeFeedings, decodeFeedings) where

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



-- Encode


encodeFeeding : Feeding -> Encode.Value
encodeFeeding ( time, lactation ) =
    Encode.object
        [ ( "lactation", Encode.string (toString lactation) )
        , ( "time", Encode.float time )
        ]


encodeFeedings : List Feeding -> String
encodeFeedings feedings =
    Encode.list (List.map encodeFeeding feedings)
        |> Encode.encode 0



-- Decode


decodeFeeding : Json.Decode.Decoder Feeding
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
                    Err "Lactation Decode Failed"
    in
        Json.Decode.customDecoder
            decodeTup
            decodeLactation


decodeFeedings : String -> Result String (List Feeding)
decodeFeedings =
    Json.Decode.list decodeFeeding
        |> Json.Decode.decodeString



-- Save Restore


save : List Feeding -> Effects Action
save feedings =
    LocalStorage.set key (encodeFeedings feedings)
        |> Task.map (always NoOp)
        |> Effects.task


restore : Effects Action
restore =
    Task.toResult (LocalStorage.get key)
        |> Task.map
            (\result ->
                case result `Result.andThen` decodeFeedings of
                    Ok feedings ->
                        Restore feedings

                    _ ->
                        NoOp
            )
        |> Effects.task
