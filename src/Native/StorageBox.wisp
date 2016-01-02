(set! window.foreign {
  :sanitize (fn
    [record & spaces]
      (spaces.reduce (fn [r space] (do
        (if (aget r space) nil (set! (aget r space) {}))
        (aget r space)))
      record))
})

(defn- make
  [localRuntime] (let
  [Task   (Elm.Native.Task.make   localRuntime)
   Utils  (Elm.Native.Utils.make  localRuntime)
   Signal (Elm.Native.Signal.make localRuntime)
   Tuple0 (:Tuple0 Utils) ]
  (do
    (foreign.sanitize localRuntime :Native :StorageBox)
    (if localRuntime.Native.StorageBox.values
        localRuntime.Native.StorageBox.values
        (set! localRuntime.Native.StorageBox.values {

  :storageBox (F2 (fn [key defaultValue]
    (let [getItem (fn [] (let [x (.getItem localStorage key)]
            (if (== x null) defaultValue (.parse JSON x))))
          stream (.input Signal (+ "retrieve." key) (getItem))

          initial (getItem)
          send (fn [value]
            (.asyncFunction Task (fn [callback]
              (do
                (.setTimeout localRuntime
                  (fn []
                    (if (not (== value defaultValue))
                      (do
                        (.setItem localStorage key (.stringify JSON value))
                        (.notify localRuntime stream.id (getItem)))))
                  0)
                (callback (.succeed Task Tuple0))))))]
      (do
        (.addListener localRuntime [stream.id] window "storage" (fn []
          (.notify localRuntime stream.id (getItem))))
        { :address { :ctor "Address"
                   , :_0   send }
        , :signal stream }))))

  } )))))

(foreign.sanitize Elm :Native :StorageBox)
(set! Elm.Native.StorageBox.make make)
