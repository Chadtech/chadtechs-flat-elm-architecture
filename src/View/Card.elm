module View.Card exposing
    ( body
    , header
    , view
    )

import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Style


view : List Style -> List (Html msg) -> Html msg
view styles =
    Html.div
        [ Attrs.css
            [ Css.batch styles
            , baseStyles
            ]
        ]


baseStyles : Style
baseStyles =
    [ Style.borders
    , minWidth (px 100)
    , minHeight (px 100)
    , position absolute
    , top (pct 50)
    , left (pct 50)
    , transform (translate2 (pct -50) (pct -50))
    , backgroundColor Style.darkGray
    , padding (px 10)
    ]
        |> Css.batch


body : List (Html msg) -> Html msg
body =
    Html.div
        [ Attrs.css
            [ Style.borders
            , minWidth (px 100)
            , minHeight (px 100)
            , backgroundColor Style.black
            ]
        ]


header : msg -> Html msg
header closeClickHandler =
    Html.div
        [ Attrs.css
            [ marginBottom (px 10)
            , displayFlex
            , justifyContent flexEnd
            ]
        ]
        [ Html.button
            [ Attrs.css
                [ backgroundColor Style.black
                , hover
                    [ Style.highlightedButton ]
                ]
            , HtmlEvents.onClick closeClickHandler
            ]
            [ Html.text "X" ]
        ]
