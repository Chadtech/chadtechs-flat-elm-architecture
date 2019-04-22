module Style exposing
    ( black
    , borders
    , bottomBorder
    , darkGray
    , globals
    , gray
    , highlightedButton
    , lightGray
    , red
    , rightBorder
    , white0
    , white1
    )

import Css exposing (..)
import Css.Global exposing (global)
import Html.Styled exposing (Html)


globals : Html msg
globals =
    [ Css.Global.everything
        [ boxSizing borderBox ]
    , Css.Global.p
        [ fontFamilies [ "monospace" ]
        , color lightGray
        , margin (px 0)
        , fontSize (px 15)
        ]
    , Css.Global.body
        [ backgroundColor black
        , margin (px 0)
        , displayFlex
        , flexDirection column
        , height (pct 100)
        ]
    , Css.Global.button
        [ fontFamilies [ "monospace" ]
        , border3 (px 1) solid lightGray
        , Css.property "background" "none"
        , color lightGray
        , cursor pointer
        , outline none
        , fontSize (px 15)
        , active []
        , height (px 22)
        ]
    , Css.Global.input
        [ fontFamilies [ "monospace" ]
        , color lightGray
        , fontSize (px 15)
        , backgroundColor darkGray
        , border3 (px 1) solid lightGray
        , outline none
        , width (px 500)
        ]
    ]
        |> global


highlightedButton : Style
highlightedButton =
    [ border3 (px 1) solid white1
    , color white1
    ]
        |> Css.batch



-- COLORS --


black : Color
black =
    hex "#090907"


white0 : Color
white0 =
    hex "#fcf7f9"


white1 : Color
white1 =
    hex "#f9fcfb"


lightGray : Color
lightGray =
    hex "#d0b5a9"


darkGray : Color
darkGray =
    hex "#36110d"


gray : Color
gray =
    hex "#7b421d"


red : Color
red =
    hex "#f21d23"



-- BORDERS --


bottomBorder : Style
bottomBorder =
    borderBottom3 (px 1) solid lightGray


rightBorder : Style
rightBorder =
    borderRight3 (px 1) solid lightGray


borders : Style
borders =
    border3 (px 1) solid lightGray
