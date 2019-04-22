module Search.Page exposing
    ( Msg
    , init
    , update
    , view
    )

import Browser.Dom
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
import Task
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import View.Input as Input
import View.LogLines as LogLines



-- TYPES --


type Msg
    = GotHeaderMsg Header.Msg
    | RunClicked
    | EnterPressed
    | SearchUpdated String
    | EventClicked (Id Event)
    | InputFocused (Result Browser.Dom.Error ())
    | ContextClicked (Id Event)
    | GotContextDialogMsg LogLines.DialogMsg



-- INIT --


init : Cmd Msg
init =
    Browser.Dom.focus searchBarInputId
        |> Task.attempt InputFocused



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ LogLines.contextDialog
        (Model.toSession model)
        model.logLines.contextModel
        |> Html.map GotContextDialogMsg
    , Header.view Route.Search
        |> Html.map GotHeaderMsg
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
                        [ LogLines.contextButton (ContextClicked id)
                        , LogLines.timestampView event
                        , LogLines.bodyView
                            { model = model.logLines
                            , attributes = [ HtmlEvents.onClick (EventClicked id) ]
                            , text = event.body
                            , eventId = id
                            }
                        ]

                events : List ( Id Event, Event )
                events =
                    searchText
                        |> Session.searchEvents (Model.toSession model)

                eventViews : List (Html Msg)
                eventViews =
                    events
                        |> List.take 200
                        |> List.map eventView
            in
            Html.div
                [ Attrs.css [ overflow auto ] ]
                (remainingEventsView events :: eventViews)


remainingEventsView : List ( Id Event, Event ) -> Html Msg
remainingEventsView events =
    let
        remainingEvents : Int
        remainingEvents =
            max 0 (List.length events - 200)
    in
    Grid.row
        []
        [ Grid.column
            [ Style.bottomBorder
            , padding (px 10)
            , justifyContent center
            ]
            [ Html.p
                []
                [ String.fromInt remainingEvents
                    ++ " events remaining"
                    |> Html.text
                ]
            ]
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
                [ Attrs.css [ width (pct 100) ]
                , Attrs.value searchText
                , Attrs.placeholder "search text.."
                , HtmlEvents.onInput SearchUpdated
                , HtmlUtil.onEnter EnterPressed
                , Attrs.id searchBarInputId
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


searchBarInputId : String
searchBarInputId =
    "search-bar-input"



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotHeaderMsg subMsg ->
            ( model
            , Header.update
                (Model.toSession model)
                subMsg
                |> Cmd.map GotHeaderMsg
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

        EventClicked eventId ->
            model
                |> Model.mapLogLines (LogLines.setSelection eventId)
                |> CmdUtil.withNoCmd

        InputFocused _ ->
            model
                |> CmdUtil.withNoCmd

        ContextClicked eventId ->
            model
                |> Model.mapLogLines (LogLines.openContext eventId)
                |> CmdUtil.withNoCmd

        GotContextDialogMsg subMsg ->
            case model.logLines.contextModel of
                LogLines.Open contextModel ->
                    let
                        ( newSession, newContext ) =
                            LogLines.updateContextDialog
                                subMsg
                                (Model.toSession model)
                                contextModel
                    in
                    model
                        |> Model.setSession newSession
                        |> Model.mapLogLines (LogLines.setContext newContext)
                        |> CmdUtil.withNoCmd

                LogLines.Closed ->
                    model
                        |> CmdUtil.withNoCmd
