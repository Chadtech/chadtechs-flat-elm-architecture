module Search.Model exposing
    ( Model
    , init
    , mapLogLines
    , search
    , setSearchText
    , setSession
    , toSession
    )

import Session exposing (Session)
import View.LogLines as LogLines



-- TYPES --


type alias Model =
    { session : Session
    , searchText : String
    , search : Maybe String
    , logLines : LogLines
    }


type alias LogLines =
    LogLines.Model LogLines.Context



-- INIT --


init : Session -> Model
init session =
    { session = session
    , searchText = ""
    , search = Nothing
    , logLines = LogLines.init LogLines.Closed
    }



-- HELPERS --


setSession : Session -> Model -> Model
setSession session model =
    { model | session = session }


mapLogLines : (LogLines -> LogLines) -> Model -> Model
mapLogLines mapFunction model =
    { model | logLines = mapFunction model.logLines }


toSession : Model -> Session
toSession =
    .session


setSearchText : String -> Model -> Model
setSearchText newSearchText model =
    { model | searchText = newSearchText }


search : Model -> Model
search model =
    { model | search = Just model.searchText }
