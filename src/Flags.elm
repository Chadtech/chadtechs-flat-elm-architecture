module Flags exposing
    ( Flags
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Random



-- TYPES --


type alias Flags =
    { seed : Random.Seed
    }



-- DECODER --


decoder : Decoder Flags
decoder =
    Decode.map Flags
        (Decode.field "randomnessSeed" randomnessSeedDecoder)


randomnessSeedDecoder : Decoder Random.Seed
randomnessSeedDecoder =
    Decode.int
        |> Decode.map Random.initialSeed
