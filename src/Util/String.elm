module Util.String exposing (quote)


quote : String -> String
quote str =
    "\"" ++ str ++ "\""
