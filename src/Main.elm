module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Flags
import Json.Decode as Decode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports
import Route exposing (Route)
import Search.Model
import Search.Page
import Session exposing (Session)
import Url exposing (Url)
import Util.Cmd as CmdUtil
import View exposing (view)



-- MAIN --


main : Program Decode.Value (Result Decode.Error Model) Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = UrlRequested
    }
        |> Browser.application


init : Decode.Value -> Url -> Nav.Key -> ( Result Decode.Error Model, Cmd Msg )
init json url navKey =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            { navKey = navKey }
                |> Model.Blank
                |> handleRoute (Route.fromUrl url)
                |> Tuple.mapFirst Ok

        Err err ->
            Err err
                |> CmdUtil.withNoCmd



-- SUBSCRIPTIONS --


subscriptions : Result Decode.Error Model -> Sub Msg
subscriptions result =
    case result of
        Ok _ ->
            Ports.fromJs Msg.decode

        Err _ ->
            Sub.none



-- UPDATE --


update : Msg -> Result Decode.Error Model -> ( Result Decode.Error Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            updateFromOk msg model
                |> Tuple.mapFirst Ok

        Err err ->
            Err err
                |> CmdUtil.withNoCmd


updateFromOk : Msg -> Model -> ( Model, Cmd Msg )
updateFromOk msg model =
    case msg of
        UrlChanged _ ->
            model
                |> CmdUtil.withNoCmd

        UrlRequested _ ->
            model
                |> CmdUtil.withNoCmd

        SearchMsg subMsg ->
            case model of
                Model.Search searchModel ->
                    Search.Page.update subMsg searchModel
                        |> Tuple.mapFirst Model.Search
                        |> CmdUtil.mapCmd SearchMsg

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        MsgDecodeFailed _ ->
            model
                |> CmdUtil.withNoCmd


handleRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
handleRoute maybeRoute model =
    let
        session : Session
        session =
            Model.toSession model
    in
    case Debug.log "MAYBE ROUTE" maybeRoute of
        Nothing ->
            Model.Error session
                |> CmdUtil.withNoCmd

        Just Route.Search ->
            Model.Search (Search.Model.init session)
                |> CmdUtil.withNoCmd

        Just Route.Dashboard ->
            Model.Dashboard session
                |> CmdUtil.withNoCmd