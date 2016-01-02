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
storageBox =
    Native.StorageBox.storageBox
