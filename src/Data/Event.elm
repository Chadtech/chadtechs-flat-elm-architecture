module Data.Event exposing
    ( Event
    , generator
    , timestamp
    )

import Random
import Time exposing (Posix)
import Util.Duration as DurationUtil
import Util.String as StringUtil



-- TYPES --


type alias Event =
    { timestamp : Posix
    , body : String
    }



-- HELPERS --


timestamp : Event -> Posix
timestamp =
    .timestamp



-- GENERATOR --


generator : Random.Generator Event
generator =
    Random.map2 Event
        (Random.map Time.millisToPosix (Random.int 0 DurationUtil.oneYear))
        bodyGenerator


bodyGenerator : Random.Generator String
bodyGenerator =
    [ Random.constant "/////"
        |> List.repeat 8
    , Random.constant "%"
        |> List.repeat 12
    , Random.int 55 128
        |> Random.map (String.fromInt >> (++) "temp=")
        |> List.repeat 15
    , Random.float 0 100
        |> Random.map (String.fromFloat >> (++) "cpu = ")
        |> List.repeat 20
    , errorGenerator
        |> Random.map ((++) "error=")
        |> List.repeat 35
    , Random.constant "error"
        |> List.repeat 10
    , ipGenerator
        |> List.repeat 40
    ]
        |> List.concat
        |> Random.uniform (Random.constant "*")
        |> Random.andThen identity


ipGenerator : Random.Generator String
ipGenerator =
    let
        zeroTo255 : Random.Generator Int
        zeroTo255 =
            Random.int 0 255

        fromInts : Int -> Int -> Int -> Int -> String
        fromInts o t th f =
            [ o, t, th, f ]
                |> List.map String.fromInt
                |> String.join "."
                |> (++) "ip="
    in
    Random.map4 fromInts
        zeroTo255
        zeroTo255
        zeroTo255
        zeroTo255


errorGenerator : Random.Generator String
errorGenerator =
    [ "system gone"
    , "system gone"
    , "internet missing"
    , "??????"
    , "NaN is not a number"
    , "?????"
    , "undefined is not a function"
    , "function is not undefined"
    , "types could have prevented this"
    , "socks missing"
    , "no more disk space"
    , "404"
    , "404040"
    , "404"
    , "404"
    , "500"
    , "500"
    , "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
    ]
        |> Random.uniform "fish too big to fry"
        |> Random.map StringUtil.quote
