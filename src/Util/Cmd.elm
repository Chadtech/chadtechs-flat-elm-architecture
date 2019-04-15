module Util.Cmd exposing
    ( mapCmd
    , withNoCmd
    )


withNoCmd : model -> ( model, Cmd msg )
withNoCmd model =
    ( model, Cmd.none )


mapCmd : (a -> b) -> ( model, Cmd a ) -> ( model, Cmd b )
mapCmd f =
    Tuple.mapSecond (Cmd.map f)
