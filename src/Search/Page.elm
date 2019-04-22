module Search.Page exposing
    ( Msg
    , init
    , update
    , view
    )

import Browser.Dom
import Css exposing (..)
import Data.Event exposing (Event)
import Header
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Id exposing (Id)
import Route
import Search.Model as Model exposing (Model)
import Session exposing (Session)
import Style
import Task
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import View.Card as Card
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
      --    | GotContextDialogMsg LogLines.DialogMsg
    | CloseContextDialogClicked
    | DeleteEventClicked



-- INIT --


init : Cmd Msg
init =
    Browser.Dom.focus searchBarInputId
        |> Task.attempt InputFocused



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ contextDialog
        (Model.toSession model)
        model.context
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


contextDialog : Session -> Model.Context -> Html Msg
contextDialog session context =
    case context of
        Model.Open contextModel ->
            case Session.getEvent contextModel.eventId session of
                Just event ->
                    Html.div
                        [ Attrs.css
                            [ position absolute
                            , top (px 0)
                            , left (px 0)
                            , width (pct 100)
                            , height (pct 100)
                            , backgroundColor (rgba 9 9 7 0.5)
                            ]
                        ]
                        [ openContextDialogView event contextModel ]

                Nothing ->
                    Html.text ""

        Model.Closed ->
            Html.text ""


openContextDialogView : Event -> Model.ContextModel -> Html Msg
openContextDialogView event contextModel =
    let
        buttonText : String
        buttonText =
            if contextModel.showDeleteConfirmation then
                "are you sure?"

            else
                "delete event"
    in
    Card.view
        [ position absolute
        , top (pct 50)
        , left (pct 50)
        , transform (translate2 (pct -50) (pct -50))
        ]
        [ Card.header
            [ Html.p
                []
                [ Html.text "event context" ]
            ]
            CloseContextDialogClicked
        , Card.body
            []
            [ Html.div
                [ Attrs.css
                    [ padding (px 10) ]
                ]
                [ Html.p
                    []
                    [ Html.text event.body ]
                ]
            ]
        , Html.div
            [ Attrs.css
                [ displayFlex
                , justifyContent flexEnd
                ]
            ]
            [ Html.button
                [ HtmlEvents.onClick DeleteEventClicked
                , Attrs.css
                    [ backgroundColor Style.black
                    , hover [ Style.highlightedButton ]
                    , marginTop (px 10)
                    ]
                ]
                [ Html.text buttonText ]
            ]
        ]



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
                |> Model.openContext eventId
                |> CmdUtil.withNoCmd

        CloseContextDialogClicked ->
            model
                |> Model.closeDialog
                |> CmdUtil.withNoCmd

        DeleteEventClicked ->
            case model.context of
                Model.Open contextModel ->
                    if contextModel.showDeleteConfirmation then
                        model
                            |> Model.mapSession
                                (Session.deleteEvent contextModel.eventId)
                            |> Model.closeDialog
                            |> CmdUtil.withNoCmd

                    else
                        model
                            |> Model.setContext { contextModel | showDeleteConfirmation = True }
                            |> CmdUtil.withNoCmd

                Model.Closed ->
                    model
                        |> CmdUtil.withNoCmd
