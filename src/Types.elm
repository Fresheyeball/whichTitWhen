module Types (..) where

import Date


type Action
    = LeftBreast
    | RightBreast
    | Bottle
    | Done


type alias Feeding =
    ( Date.Date, Action )


type alias Model =
    List Feeding
