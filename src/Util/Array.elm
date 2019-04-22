module Util.Array exposing (remove)

import Array exposing (Array)


remove : Int -> Array a -> Array a
remove index array =
    Array.append
        (Array.slice 0 index array)
        (Array.slice (index + 1) (Array.length array) array)
