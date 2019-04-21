module View.LogLines exposing
    ( container
    , viewLine
    )

import Data.Event exposing (Event)
import Html.Styled as Html exposing (Html)


container : List (Html msg) -> Html msg
container =
    Html.div []


viewLine : Event -> Html msg
viewLine event =
    Html.text ""
