module Data.Event exposing
    ( Event
    , timestamp
    )

import Time exposing (Posix)



-- TYPES --


type alias Event =
    { timestamp : Posix
    , body : String
    }



-- HELPERS --


timestamp : Event -> Posix
timestamp =
    .timestamp
