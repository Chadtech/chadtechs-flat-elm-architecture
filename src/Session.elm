module Session exposing (Session)

import Browser.Navigation as Nav



-- TYPES --


type alias Session =
    { navKey : Nav.Key
    }
