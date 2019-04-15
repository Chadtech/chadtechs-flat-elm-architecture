module Model exposing
    ( Model(..)
    , toSession
    )

import Search.Model as Search
import Session exposing (Session)



-- TYPES --


type Model
    = Blank Session
    | Error Session
    | Search Search.Model
    | Dashboard Session



-- HELPERS --


toSession : Model -> Session
toSession model =
    case model of
        Blank session ->
            session

        Error session ->
            session

        Search searchModel ->
            Search.toSession searchModel

        Dashboard session ->
            session
