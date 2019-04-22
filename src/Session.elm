module Session exposing
    ( Session
    , init
    , navigateTo
    , searchEvents
    )

import Browser.Navigation as Nav
import Data.Event as Event exposing (Event)
import Db exposing (Db)
import Flags exposing (Flags)
import Id exposing (Id)
import Random
import Route exposing (Route)
import Time



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


searchEvents : Session -> String -> List ( Id Event, Event )
searchEvents session searchText =
    session.events
        |> Db.toList
        |> List.filter (Tuple.second >> Event.contains searchText)
        |> List.sortBy (Tuple.second >> Event.timestamp >> Time.posixToMillis)


navigateTo : Session -> Route -> Cmd msg
navigateTo session route =
    route
        |> Route.toUrlString
        |> Nav.pushUrl session.navKey
