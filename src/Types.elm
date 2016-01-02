module Types (..) where

import Time


type Lactation
    = LeftBreast
    | RightBreast
    | Bottle
    | Done


type alias Feeding =
    ( Time.Time, Lactation )


type Action
    = Add Lactation
    | Tick Time.Time
    | Restore (List Feeding)
    | Delete Feeding
    | NoOp


type alias Model =
    { feedings : List Feeding
    , time : Time.Time
    }
