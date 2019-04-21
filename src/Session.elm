module Session exposing
    ( Session
    , init
    , navigateTo
    )

import Browser.Navigation as Nav
import Data.Event as Event exposing (Event)
import Db exposing (Db)
import Flags exposing (Flags)
import Id
import Random
import Route exposing (Route)



-- TYPES --


type alias Session =
    { navKey : Nav.Key
    , events : Db Event
    }



-- INIT --


init : Nav.Key -> Flags -> Session
init navKey flags =
    let
        eventsGenerator : Random.Generator (Db Event)
        eventsGenerator =
            Random.map2 Tuple.pair
                Id.generator
                Event.generator
                |> Random.list 2000
                |> Random.map Db.fromList
    in
    { navKey = navKey
    , events =
        flags.seed
            |> Random.step eventsGenerator
            |> Tuple.first
    }



-- HELPERS --


navigateTo : Session -> Route -> Cmd msg
navigateTo session route =
    route
        |> Route.toUrlString
        |> Nav.pushUrl session.navKey
