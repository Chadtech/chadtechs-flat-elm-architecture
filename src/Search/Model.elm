module Search.Model exposing
    ( Model
    , init
    , toSession
    )

import Session exposing (Session)



-- TYPES --


type alias Model =
    { session : Session }



-- INIT --


init : Session -> Model
init session =
    { session = session }



-- HELPERS --


toSession : Model -> Session
toSession =
    .session
