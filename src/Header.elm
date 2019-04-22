module Header exposing
    ( Msg
    , update
    , view
    )

import Css exposing (..)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Route exposing (Route)
import Session exposing (Session)
import Style



-- TYPES --


type Msg
    = RouteClicked Route



-- VIEW --


view : Route -> Html Msg
view currentRoute =
    let
        routeButtonColumnStyle : Style
        routeButtonColumnStyle =
            [ flex (int 0)
            , flexDirection column
            , justifyContent center
            ]
                |> Css.batch
    in
    Grid.container
        [ width (pct 100) ]
        [ Grid.row
            [ Style.bottomBorder
            , padding (px 10)
            ]
            [ Grid.column [] [ title ]
            , Grid.column
                [ routeButtonColumnStyle ]
                [ navButton currentRoute Route.Search ]
            , Grid.column
                [ marginLeft (px 10)
                , routeButtonColumnStyle
                ]
                [ navButton currentRoute Route.Dashboard ]
            ]
        ]


navButton : Route -> Route -> Html Msg
navButton currentRoute thisRoute =
    let
        styles : List Style
        styles =
            if currentRoute == thisRoute then
                [ border3 (px 1) solid Style.white0
                , color Style.white0
                ]

            else
                [ active
                    [ Style.highlightedButton
                    , color Style.white1
                    ]
                ]
    in
    Html.button
        [ Attrs.css styles
        , Events.onClick (RouteClicked thisRoute)
        ]
        [ Html.text <| Route.toLabel thisRoute ]


title : Html Msg
title =
    Html.p
        [ Attrs.css [ lineHeight (px 22) ] ]
        [ Html.text "log liner" ]



-- UPDATE --


update : Session -> Msg -> Cmd msg
update session msg =
    case msg of
        RouteClicked route ->
            Session.navigateTo session route
