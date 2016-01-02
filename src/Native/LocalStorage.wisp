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
    (foreign.sanitize localRuntime :Native :LocalStorage)
    (if localRuntime.Native.LocalStorage.values
        localRuntime.Native.LocalStorage.values
        (set! localRuntime.Native.LocalStorage.values {

  :get (fn [key]
    (.asyncFunction Task (fn [callback]
        (let [x (.getItem localStorage key)]
            (callback (if (== x null)
                (.fail Task "Key not found")
                (.succeed Task x)))))))

  :set (F2 (fn [key value]
    (.asyncFunction Task (fn [callback]
        (do
            (.setItem localStorage key value)
            (callback (.succeed Task Tuple0)))))))

  } )))))

(foreign.sanitize Elm :Native :LocalStorage)
(set! Elm.Native.LocalStorage.make make)
