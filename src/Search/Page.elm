module Search.Page exposing
    ( Msg
    , update
    , view
    )

import Header
import Html.Styled as Html exposing (Html)
import Route
import Search.Model exposing (Model)



-- TYPES --


type Msg
    = HeaderMsg Header.Msg



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Header.view Route.Search
        |> Html.map HeaderMsg
    ]



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeaderMsg subMsg ->
            ( model
            , Header.update subMsg
                |> Cmd.map HeaderMsg
            )
