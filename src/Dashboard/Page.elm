module Dashboard.Page exposing
    ( Msg
    , update
    , view
    )

import Dashboard.Model as Model exposing (Model)
import Header
import Html.Styled as Html exposing (Html)
import Route



-- TYPES --


type Msg
    = HeaderMsg Header.Msg



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Header.view Route.Dashboard
        |> Html.map HeaderMsg
    ]



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HeaderMsg subMsg ->
            ( model
            , Header.update (Model.toSession model) subMsg
                |> Cmd.map HeaderMsg
            )
