module Persist (..) where

import StorageBox exposing (..)
import Types exposing (..)


storage : StorageBox (List Feeding)
storage =
    storageBox "whichTitWhen" []
