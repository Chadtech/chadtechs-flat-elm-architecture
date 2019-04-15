module Document exposing
    ( Document
    , consBody
    , toBrowserDocument
    )

import Browser
import Html.Styled as Html exposing (Html)



-- TYPES --


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }



-- HELPERS --


consBody : Html msg -> Document msg -> Document msg
consBody html document =
    { document | body = html :: document.body }


toBrowserDocument : Document msg -> Browser.Document msg
toBrowserDocument doc =
    { title = doc.title
    , body = List.map Html.toUnstyled doc.body
    }
