module Route exposing
    ( Route(..)
    , fromUrl
    , toLabel
    , toUrlString
    )

-- TYPES --

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, top)


type Route
    = Search
    | Dashboard



-- HELPERS --


toLabel : Route -> String
toLabel route =
    case route of
        Search ->
            "search"

        Dashboard ->
            "dashboard"


toUrlString : Route -> String
toUrlString route =
    case route of
        Search ->
            "search"

        Dashboard ->
            "dashboard"


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Search (top </> s "search")
        , Parser.map Search top
        , Parser.map Dashboard (top </> s "dashboard")
        ]
