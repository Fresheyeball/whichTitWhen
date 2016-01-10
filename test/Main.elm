module Main (..) where

import Check exposing (..)
import Graphics.Element exposing (Element, show)
import Check.Investigator exposing (..)
import Types exposing (Event(..), Feeding)
import Random
import Shrink exposing (Shrinker)
import Lazy.List exposing (..)
import Persist exposing (..)


lactation : Investigator Event
lactation =
    let
        generator : Random.Generator Event
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

                        3 ->
                            DoneFeeding

                        4 ->
                            Poo

                        5 ->
                            Pee

                        _ ->
                            PooAndPee
            in
                Random.map
                    fromInt
                    (Random.int 0 3)

        shrinker : Shrinker Event
        shrinker lact =
            case lact of
                LeftBreast ->
                    empty

                RightBreast ->
                    LeftBreast ::: empty

                Bottle ->
                    RightBreast ::: empty

                DoneFeeding ->
                    Bottle ::: empty

                Pee ->
                    DoneFeeding ::: empty

                Poo ->
                    Pee ::: empty

                PooAndPee ->
                    Poo ::: empty
    in
        investigator generator shrinker


feeding : Investigator Feeding
feeding =
    tuple ( float, lactation )


feedingsParse : Claim
feedingsParse =
    let
        proof feedings =
            case storage.encode feedings |> storage.decode of
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
