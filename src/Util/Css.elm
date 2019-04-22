module Util.Css exposing
    ( none
    , styleIf
    )

import Css exposing (Style)


none : Style
none =
    Css.batch []


styleIf : Bool -> Style -> Style
styleIf condition style =
    if condition then
        style

    else
        none
