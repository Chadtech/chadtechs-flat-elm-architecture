module Session exposing
    ( Session
    , navigateTo
    )

import Browser.Navigation as Nav
import Route exposing (Route)



-- TYPES --


type alias Session =
    { navKey : Nav.Key
    }



-- HELPERS --


navigateTo : Session -> Route -> Cmd msg
navigateTo session route =
    route
        |> Route.toUrlString
        |> Nav.pushUrl session.navKey
