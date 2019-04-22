module Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Dashboard.Page as Dashboard
import Route exposing (Route)
import Search.Page as Search



-- TYPES --


type Msg
    = RouteChanged (Maybe Route)
    | UrlRequested UrlRequest
    | SearchMsg Search.Msg
    | DashboardMsg Dashboard.Msg
