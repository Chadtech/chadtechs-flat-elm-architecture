module Model exposing
    ( Model(..)
    , toSession
    )

import Dashboard.Model as Dashboard
import Search.Model as Search
import Session exposing (Session)



-- TYPES --


type Model
    = Blank Session
    | Error Session
    | Search Search.Model
    | Dashboard Dashboard.Model



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

        Dashboard dashboardModel ->
            Dashboard.toSession dashboardModel
