module Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

-- TYPES --

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, top)


type Route
    = Search
    | Dashboard



-- HELPERS --


toString : Route -> String
toString route =
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
        , Parser.map Dashboard (top </> s "dashboard")
        ]
