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
    | Clobber (List Feeding)
    | NoOp

type alias Model =
    { feedings : List Feeding
    , since : Time.Time }
