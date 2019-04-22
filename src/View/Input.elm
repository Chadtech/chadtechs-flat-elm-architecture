module View.Input exposing (view)

import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs


view : List (Attribute msg) -> Html msg
view attrs =
    Html.input (attrs ++ baseAttributes) []


baseAttributes : List (Attribute msg)
baseAttributes =
    [ Attrs.spellcheck False ]
