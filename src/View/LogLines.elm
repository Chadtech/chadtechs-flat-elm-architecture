module View.LogLines exposing
    ( Model
    , bodyView
    ,  contextButton
       --    , contextDialog

    , init
    , lineView
    , setSelection
    ,  timestampView
       --    , updateContextDialog

    )

import Css exposing (..)
import Data.Event as Event exposing (Event)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as HtmlEvents
import Id exposing (Id)
import Style
import Time exposing (Posix)
import Util.Css as CssUtil



-- TYPES --


type alias Model =
    { selection : Maybe (Id Event) }



-- INIT --


init : Model
init =
    { selection = Nothing }



-- HELPERS --


setSelection : Id Event -> Model -> Model
setSelection id model =
    { model | selection = Just id }



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


timestampView : Event -> Html msg
timestampView event =
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
            [ event
                |> Event.timestamp
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


type alias BodyParams msg =
    { model : Model
    , attributes : List (Attribute msg)
    , text : String
    , eventId : Id Event
    }


bodyView : BodyParams msg -> Html msg
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
--
--type DialogMsg
--    = CloseClicked
--    | DeleteClicked
--
--updateContextDialog : DialogMsg -> Session -> ContextModel -> ( Session, Context )
--updateContextDialog msg session contextModel =
--    case msg of
--        CloseClicked ->
--            ( session, Closed )
--
--        DeleteClicked ->
--            if contextModel.showDeleteConfirmation then
--                ( Session.deleteEvent contextModel.eventId session
--                , Closed
--                )
--
--            else
--                ( session
--                , Open { contextModel | showDeleteConfirmation = True }
--                )
