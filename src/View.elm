module View exposing (view)

import Browser
import Document exposing (Document)
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Search.Page as Search
import Style


view : Result Decode.Error Model -> Browser.Document Msg
view result =
    result
        |> viewDocument
        |> Document.consBody Style.globals
        |> Document.toBrowserDocument


viewDocument : Result Decode.Error Model -> Document Msg
viewDocument result =
    case result of
        Ok model ->
            { title = "Log Liner"
            , body = viewBody model
            }

        Err error ->
            { title = "Error"
            , body =
                [ Html.p
                    []
                    [ Html.text <| Decode.errorToString error ]
                ]
            }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model of
        Model.Blank _ ->
            []

        Model.Error _ ->
            []

        Model.Search searchModel ->
            Search.view searchModel
                |> List.map (Html.map SearchMsg)

        Model.Dashboard _ ->
            []
