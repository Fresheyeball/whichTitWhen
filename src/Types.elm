module Types (..) where

import Time


type Event
    = LeftBreast
    | RightBreast
    | Bottle
    | Poo
    | Pee
    | PooAndPee
    | DoneFeeding


type alias Feeding =
    ( Time.Time, Event )


type Action
    = Add Event
    | Tick Time.Time
    | Restore (List Feeding)
    | Delete Feeding
    | NoOp


type alias Model =
    { feedings : List Feeding
    , time : Time.Time
    }
