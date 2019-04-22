module View.LogLines exposing
    ( bodyView
    , lineView
    , timestampView
    )

import Css exposing (..)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Style
import Time exposing (Posix)



-- VIEW --


timestampView : Posix -> Html msg
timestampView time =
    Grid.column
        [ flex none
        , width (px 100)
        , Style.rightBorder
        , marginRight (px 5)
        ]
        [ Html.p
            []
            [ time
                |> Time.posixToMillis
                |> String.fromInt
                |> Html.text
            ]
        ]


lineView : List Style -> List (Html msg) -> Html msg
lineView extraStyles =
    Grid.row
        [ cursor pointer
        , Style.bottomBorder
        , paddingLeft (px 5)
        , paddingRight (px 5)
        , overflowX hidden
        , Css.batch extraStyles
        ]


bodyView : List (Attribute msg) -> String -> Html msg
bodyView extraAttributes text =
    let
        attributes : List (Attribute msg)
        attributes =
            [ Attrs.css
                [ whiteSpace noWrap ]
            ]
                ++ extraAttributes
    in
    Grid.column
        []
        [ Html.p
            attributes
            [ Html.text text ]
        ]
