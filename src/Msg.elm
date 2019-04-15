module Msg exposing
    ( Msg(..)
    , decode
    )

import Browser exposing (UrlRequest)
import Json.Decode as Decode exposing (Decoder)
import Search.Page as Search
import Url exposing (Url)



-- TYPES --


type Msg
    = UrlChanged Url
    | UrlRequested UrlRequest
    | SearchMsg Search.Msg
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
