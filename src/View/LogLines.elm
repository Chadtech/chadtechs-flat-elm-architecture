module View.LogLines exposing
    ( Context(..)
    , DialogMsg
    , Model
    , NoContext
    , bodyView
    , contextButton
    , contextDialog
    , init
    , lineView
    , openContext
    , setContext
    , setSelection
    , timestampView
    , updateContextDialog
    )

import Css exposing (..)
import Data.Event exposing (Event)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Id exposing (Id)
import Session exposing (Session)
import Style
import Time exposing (Posix)
import Util.Css as CssUtil
import View.Card as Card



-- TYPES --


type alias Model context =
    { selection : Maybe (Id Event)
    , contextModel : context
    }


type NoContext
    = NoContext


type Context
    = Closed
    | Open ContextModel


type alias ContextModel =
    { eventId : Id Event
    , showDeleteConfirmation : Bool
    }



-- INIT --


init : context -> Model context
init context =
    { selection = Nothing
    , contextModel = context
    }



-- HELPERS --


setSelection : Id Event -> Model context -> Model context
setSelection id model =
    { model | selection = Just id }


openContext : Id Event -> Model Context -> Model Context
openContext id model =
    { model
        | contextModel =
            Open
                { eventId = id
                , showDeleteConfirmation = False
                }
    }


setContext : Context -> Model Context -> Model Context
setContext context model =
    { model | contextModel = context }



-- VIEW --


contextButton : msg -> Html msg
contextButton clickHandler =
    Grid.column
        [ flex none
        , width (px 30)
        , Style.rightBorder
        , flexDirection column
        , justifyContent center
        , paddingLeft (px 10)
        ]
        [ Html.button
            [ Attrs.css
                [ height (px 10)
                , width (px 10)
                , padding (px 0)
                , backgroundColor Style.lightGray
                , hover [ backgroundColor Style.white0 ]
                ]
            , HtmlEvents.onClick clickHandler
            ]
            []
        ]


timestampView : Posix -> Html msg
timestampView time =
    Grid.column
        [ flex none
        , minWidth (px 100)
        , Style.rightBorder
        , paddingLeft (px 10)
        , paddingRight (px 10)
        ]
        [ Html.p
            [ Attrs.css
                [ cursor default ]
            ]
            [ time
                |> Time.posixToMillis
                |> String.fromInt
                |> Html.text
            ]
        ]


lineView : List (Html msg) -> Html msg
lineView =
    Grid.row
        [ Style.bottomBorder
        , overflowX hidden
        ]


type alias BodyParams context msg =
    { model : Model context
    , attributes : List (Attribute msg)
    , text : String
    , eventId : Id Event
    }


bodyView : BodyParams context msg -> Html msg
bodyView params =
    let
        selectedBackgroundColor : Style
        selectedBackgroundColor =
            CssUtil.styleIf
                (Just params.eventId == params.model.selection)
                (backgroundColor Style.gray)

        attributes : List (Attribute msg)
        attributes =
            Attrs.css
                [ whiteSpace noWrap
                , marginLeft (px 5)
                , width (pct 100)
                ]
                :: params.attributes
    in
    Grid.column
        [ hover
            [ backgroundColor Style.darkGray
            , selectedBackgroundColor
            ]
        , selectedBackgroundColor
        , cursor pointer
        ]
        [ Html.p
            attributes
            [ Html.text params.text ]
        ]



-- CONTEXT VIEW --


type DialogMsg
    = CloseClicked
    | DeleteClicked


contextDialog : Session -> Context -> Html DialogMsg
contextDialog session context =
    case context of
        Open contextModel ->
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

        Closed ->
            Html.text ""


openContextDialogView : Event -> ContextModel -> Html DialogMsg
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
        []
        [ Card.header CloseClicked
        , Card.body
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
                [ HtmlEvents.onClick DeleteClicked
                , Attrs.css
                    [ backgroundColor Style.black
                    , hover [ Style.highlightedButton ]
                    , marginTop (px 10)
                    ]
                ]
                [ Html.text buttonText ]
            ]
        ]


updateContextDialog : DialogMsg -> Session -> ContextModel -> ( Session, Context )
updateContextDialog msg session contextModel =
    case msg of
        CloseClicked ->
            ( session, Closed )

        DeleteClicked ->
            if contextModel.showDeleteConfirmation then
                ( Session.deleteEvent contextModel.eventId session
                , Closed
                )

            else
                ( session
                , Open { contextModel | showDeleteConfirmation = True }
                )
