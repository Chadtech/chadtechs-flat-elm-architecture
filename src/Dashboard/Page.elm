module Dashboard.Page exposing
    ( Msg
    , update
    , view
    )

import Array exposing (Array)
import Css exposing (..)
import Dashboard.Model as Model exposing (Model)
import Data.Event as Event exposing (Event)
import Header
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Id exposing (Id)
import Route
import Session exposing (Session)
import Style
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import View.Card as Card
import View.Input as Input
import View.LogLines as LogLines



-- TYPES --


type Msg
    = HeaderMsg Header.Msg
    | EnterPressed
    | SearchUpdated String
    | NewLogLinesViewClicked
    | CloseViewClicked Int



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Header.view Route.Dashboard
        |> Html.map HeaderMsg
    , Html.div
        []
        (newLogLinesView model.newLogLinesSearchText)
    ]
        ++ logLinesViews (Model.toSession model) model.logLines


logLinesViews : Session -> Array Model.LogLines -> List (Html Msg)
logLinesViews session logLines =
    logLines
        |> Array.toList
        |> List.indexedMap (logLinesView session)


logLinesView : Session -> Int -> ( String, LogLines.Model LogLines.NoContext ) -> Html Msg
logLinesView session viewIndex ( searchText, logLines ) =
    let
        eventView : ( Id Event, Event ) -> Html Msg
        eventView ( id, event ) =
            LogLines.lineView
                [ LogLines.timestampView event
                , LogLines.bodyView
                    { model = logLines
                    , attributes = []
                    , text = event.body
                    , eventId = id
                    }
                ]

        eventViews : List (Html Msg)
        eventViews =
            searchText
                |> Session.searchEvents session
                |> List.take 200
                |> List.map eventView
    in
    Grid.row
        [ padding (px 10) ]
        [ Card.view
            [ width (pct 100)
            ]
            [ Card.header
                [ Html.p
                    []
                    [ Html.text searchText ]
                ]
                (CloseViewClicked viewIndex)
            , Card.body
                [ height (px 400)
                , overflow auto
                ]
                eventViews
            ]
        ]


newLogLinesView : String -> List (Html Msg)
newLogLinesView newLogLinesSearchText =
    [ Grid.row
        [ padding (px 10)
        , Style.bottomBorder
        ]
        [ Grid.column
            []
            [ Input.view
                [ Attrs.css [ width (pct 100) ]
                , Attrs.value newLogLinesSearchText
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
                , HtmlEvents.onClick NewLogLinesViewClicked
                ]
                [ Html.text "new view" ]
            ]
        ]
    ]



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeaderMsg subMsg ->
            ( model
            , Header.update (Model.toSession model) subMsg
                |> Cmd.map HeaderMsg
            )

        NewLogLinesViewClicked ->
            model
                |> Model.newLogLinesView
                |> CmdUtil.withNoCmd

        EnterPressed ->
            model
                |> Model.newLogLinesView
                |> CmdUtil.withNoCmd

        SearchUpdated newSearchText ->
            model
                |> Model.setSearchText newSearchText
                |> CmdUtil.withNoCmd

        CloseViewClicked viewIndex ->
            model
                |> Model.removeViewIndex viewIndex
                |> CmdUtil.withNoCmd
