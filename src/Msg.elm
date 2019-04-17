module Msg exposing
    ( Msg(..)
    , decode
    )

import Browser exposing (UrlRequest)
import Dashboard.Page as Dashboard
import Json.Decode as Decode exposing (Decoder)
import Route exposing (Route)
import Search.Page as Search



-- TYPES --


type Msg
    = RouteChanged (Maybe Route)
    | UrlRequested UrlRequest
    | SearchMsg Search.Msg
    | DashboardMsg Dashboard.Msg
    | MsgDecodeFailed Decode.Error



-- DECODE --


decode : Decode.Value -> Msg
decode json =
    case Decode.decodeValue decoder json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed err


decoder : Decoder Msg
decoder =
    Decode.string
        |> Decode.field "type"
        |> Decode.andThen
            (Decode.field "payload" << payloadDecoder)


payloadDecoder : String -> Decoder Msg
payloadDecoder type_ =
    case type_ of
        _ ->
            Decode.fail ("Unrecognized Msg type -> " ++ type_)
