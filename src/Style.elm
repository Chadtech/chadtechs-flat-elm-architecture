module Style exposing
    ( bigFont
    , black
    , bottomBorder
    , globals
    , highlightedButton
    , lightGray
    , red
    , white0
    , white1
    )

import Css exposing (..)
import Css.Global exposing (global)
import Html.Styled exposing (Html)


globals : Html msg
globals =
    [ Css.Global.p
        [ fontFamilies [ "monospace" ]
        , color lightGray
        , margin (px 0)
        ]
    , Css.Global.body
        [ backgroundColor black
        , margin (px 0)
        ]
    , Css.Global.button
        [ fontFamilies [ "monospace" ]
        , border3 (px 1) solid lightGray
        , Css.property "background" "none"
        , color lightGray
        , cursor pointer
        , outline none
        ]
    , Css.Global.input
        [ fontFamilies [ "monospace" ]
        , color lightGray
        , fontSize (em 2)
        , backgroundColor white1
        , border3 (px 1) solid lightGray
        , outline none
        , width (px 500)
        ]
    ]
        |> global


highlightedButton : Style
highlightedButton =
    border3 (px 1) solid white1


bigFont : Style
bigFont =
    fontSize (em 2)



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


red : Color
red =
    hex "#f21d23"



-- BORDERS --


bottomBorder : Style
bottomBorder =
    borderBottom3 (px 3) solid lightGray
