module Main (..) where

import Check exposing (..)
import Graphics.Element exposing (Element, show)
import Check.Investigator exposing (..)
import Types exposing (Lactation(..), Feeding)
import Random
import Shrink exposing (Shrinker)
import Lazy.List exposing (..)
import Persist exposing (..)


lactation : Investigator Lactation
lactation =
    let
        generator : Random.Generator Lactation
        generator =
            let
                fromInt i =
                    case i of
                        0 ->
                            LeftBreast

                        1 ->
                            RightBreast

                        2 ->
                            Bottle

                        _ ->
                            Done
            in
                Random.map
                    fromInt
                    (Random.int 0 3)

        shrinker : Shrinker Lactation
        shrinker lact =
            case lact of
                LeftBreast ->
                    empty

                RightBreast ->
                    LeftBreast ::: empty

                Bottle ->
                    RightBreast ::: empty

                Done ->
                    Bottle ::: empty
    in
        investigator generator shrinker


feeding : Investigator Feeding
feeding =
    tuple ( float, lactation )


feedingsParse : Claim
feedingsParse =
    let
        proof feedings =
            case encodeFeedings feedings |> decodeFeedings of
                Ok feedings' ->
                    feedings == feedings'

                _ ->
                    False
    in
        claim
            "feedings should parse to json and back reliably"
            `true` proof
            `for` list feeding


main : Element
main =
    show (quickCheck feedingsParse)
