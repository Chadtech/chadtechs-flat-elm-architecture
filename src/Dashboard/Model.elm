module Dashboard.Model exposing
    ( LogLines
    , Model
    , init
    , newLogLinesView
    , removeViewIndex
    , setSearchText
    , toSession
    )

import Array exposing (Array)
import Session exposing (Session)
import Util.Array as ArrayUtil
import View.LogLines as LogLines



-- TYPES --


type alias Model =
    { session : Session
    , logLines : Array LogLines
    , newLogLinesSearchText : String
    }


{-| the String is the search
-}
type alias LogLines =
    ( String, LogLines.Model LogLines.NoContext )



-- INIT --


init : Session -> Model
init session =
    { session = session
    , logLines = Array.empty
    , newLogLinesSearchText = ""
    }



-- HELPERS --


removeViewIndex : Int -> Model -> Model
removeViewIndex viewIndex model =
    { model | logLines = ArrayUtil.remove viewIndex model.logLines }


setSearchText : String -> Model -> Model
setSearchText newLogLinesSearchText model =
    { model | newLogLinesSearchText = newLogLinesSearchText }


newLogLinesView : Model -> Model
newLogLinesView model =
    { model
        | newLogLinesSearchText = ""
        , logLines =
            Array.push
                ( model.newLogLinesSearchText
                , LogLines.init LogLines.NoContext
                )
                model.logLines
    }


toSession : Model -> Session
toSession =
    .session
