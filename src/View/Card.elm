module View.Card exposing
    ( body
    , header
    , view
    )

import Css exposing (..)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Style


view : List Style -> List (Html msg) -> Html msg
view styles =
    Html.div
        [ Attrs.css
            [ baseStyles
            , Css.batch styles
            ]
        ]


baseStyles : Style
baseStyles =
    [ Style.borders
    , minWidth (px 100)
    , minHeight (px 100)
    , backgroundColor Style.darkGray
    , padding (px 10)
    ]
        |> Css.batch


body : List Style -> List (Html msg) -> Html msg
body styles =
    Html.div
        [ Attrs.css
            [ Style.borders
            , minWidth (px 100)
            , minHeight (px 100)
            , backgroundColor Style.black
            , Css.batch styles
            ]
        ]


header : List (Html msg) -> msg -> Html msg
header children closeClickHandler =
    Html.div
        [ Attrs.css
            [ marginBottom (px 10)
            , displayFlex
            , justifyContent flexEnd
            ]
        ]
        (Grid.column
            []
            children
            :: [ Grid.column
                    [ flex (int 0) ]
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
               ]
        )
