module Search.Page exposing
    ( Msg
    , update
    , view
    )

import Css exposing (..)
import Data.Event as Event exposing (Event)
import Header
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Id exposing (Id)
import Route
import Search.Model as Model exposing (Model)
import Session
import Style
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import View.Input as Input
import View.LogLines as LogLines



-- TYPES --


type Msg
    = HeaderMsg Header.Msg
    | RunClicked
    | EnterPressed
    | SearchUpdated String



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Header.view Route.Search
        |> Html.map HeaderMsg
    , Html.div
        []
        (searchBar model.searchText)
    , searchResults model
    ]


searchResults : Model -> Html Msg
searchResults model =
    case model.search of
        Nothing ->
            Grid.row
                [ flex (int 1)
                , justifyContent center
                ]
                [ Grid.column
                    [ flexDirection column
                    , justifyContent center
                    , flex none
                    ]
                    [ Html.p
                        []
                        [ Html.text "no search" ]
                    ]
                ]

        Just searchText ->
            let
                eventView : ( Id Event, Event ) -> Html Msg
                eventView ( id, event ) =
                    LogLines.lineView
                        [ hover
                            [ backgroundColor Style.darkGray ]
                        ]
                        [ LogLines.timestampView <| Event.timestamp event
                        , LogLines.bodyView
                            []
                            event.body
                        ]
            in
            searchText
                |> Session.searchEvents (Model.toSession model)
                |> List.map eventView
                |> List.take 200
                |> Html.div
                    [ Attrs.css
                        [ overflow auto ]
                    ]


searchBar : String -> List (Html Msg)
searchBar searchText =
    [ Grid.row
        [ padding (px 10)
        , Style.bottomBorder
        ]
        [ Grid.column
            []
            [ Input.view
                [ Attrs.css
                    [ width (pct 100) ]
                , Attrs.value searchText
                , Attrs.placeholder "search text.."
                , HtmlEvents.onInput SearchUpdated
                , HtmlUtil.onEnter EnterPressed
                ]
            ]
        , Grid.column
            [ flex none
            , paddingLeft (px 10)
            ]
            [ Html.button
                [ Attrs.css
                    [ active [ Style.highlightedButton ]
                    , hover [ Style.highlightedButton ]
                    ]
                , HtmlEvents.onClick RunClicked
                ]
                [ Html.text "run" ]
            ]
        ]
    ]



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeaderMsg subMsg ->
            ( model
            , Header.update
                (Model.toSession model)
                subMsg
                |> Cmd.map HeaderMsg
            )

        RunClicked ->
            model
                |> Model.search
                |> CmdUtil.withNoCmd

        EnterPressed ->
            model
                |> Model.search
                |> CmdUtil.withNoCmd

        SearchUpdated newSearchText ->
            model
                |> Model.setSearchText newSearchText
                |> CmdUtil.withNoCmd
