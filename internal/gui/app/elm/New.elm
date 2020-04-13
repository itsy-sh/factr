module New exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Pass


type alias Model =
    Pass.Entry


init : Model
init =
    emptyModel


type Msg
    = Nop
    | NewPass
    | SubmitPass


emptyModel : Model
emptyModel =
    { name = ""
    , secret = ""
    , metadata = Dict.empty
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model

        NewPass ->
            model

        SubmitPass ->
            model


view : Model -> Html Msg
view model =
    div [ class "new-pass " ]
        [ div [] [ text "new pass" ]
        ]
