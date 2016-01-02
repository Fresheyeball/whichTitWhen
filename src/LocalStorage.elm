module StorageBox (StorageKey, storageBox, StorageBox) where

import Native.StorageBox
import Signal


type alias StorageBox a =
    { address : Signal.Address a
    , signal : Signal.Signal a
    }


type alias StorageKey =
    String


storageBox : StorageKey -> a -> StorageBox a
storageBox key a =
    let
        box = Native.StorageBox.storageBox key a
    in
        { box
            | signal = Signal.dropRepeats (.signal box)
        }
