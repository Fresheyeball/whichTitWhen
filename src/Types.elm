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
    = Add Feeding
    | Delete Feeding
    | Clobber (List Feeding)
