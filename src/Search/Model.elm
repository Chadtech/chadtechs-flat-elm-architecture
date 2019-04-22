module Search.Model exposing
    ( Context(..)
    , ContextModel
    , Model
    , closeDialog
    , init
    , mapLogLines
    , mapSession
    , openContext
    , search
    , setContext
    , setSearchText
    , toSession
    )

import Data.Event exposing (Event)
import Id exposing (Id)
import Session exposing (Session)
import View.LogLines as LogLines



-- TYPES --


type alias Model =
    { session : Session
    , searchText : String
    , search : Maybe String
    , logLines : LogLines.Model
    , context : Context
    }


type Context
    = Closed
    | Open ContextModel


type alias ContextModel =
    { eventId : Id Event
    , showDeleteConfirmation : Bool
    }



-- INIT --


init : Session -> Model
init session =
    { session = session
    , searchText = ""
    , search = Nothing
    , logLines = LogLines.init
    , context = Closed
    }



-- HELPERS --


openContext : Id Event -> Model -> Model
openContext id model =
    { model
        | context =
            Open
                { eventId = id
                , showDeleteConfirmation = False
                }
    }


closeDialog : Model -> Model
closeDialog model =
    { model | context = Closed }


setContext : ContextModel -> Model -> Model
setContext context model =
    { model | context = Open context }


mapSession : (Session -> Session) -> Model -> Model
mapSession mapFunction model =
    { model | session = mapFunction model.session }


mapLogLines : (LogLines.Model -> LogLines.Model) -> Model -> Model
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
