module Search.Model exposing
    ( Model
    , init
    , search
    , setSearchText
    , toSession
    )

import Session exposing (Session)



-- TYPES --


type alias Model =
    { session : Session
    , searchText : String
    , search : Maybe String
    }



-- INIT --


init : Session -> Model
init session =
    { session = session
    , searchText = ""
    , search = Nothing
    }



-- HELPERS --


toSession : Model -> Session
toSession =
    .session


setSearchText : String -> Model -> Model
setSearchText newSearchText model =
    { model | searchText = newSearchText }


search : Model -> Model
search model =
    { model | search = Just model.searchText }
