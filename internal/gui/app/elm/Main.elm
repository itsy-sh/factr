module Main exposing (..)

-- MAIN

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, i, input, table, td, text, th, tr)
import Html.Attributes exposing (class, colspan, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Pass as Pass


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type Msg
    = GotPass Pass.Msg


type Model
    = Pass Pass.Model


init : Model
init =
    emptyModel


emptyModel : Model
emptyModel =
    Pass Pass.emptyModel



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case ( msg, model ) of
        ( GotPass subMsg, Pass pass ) ->
            Pass.update subMsg pass
                |> updateWith Pass GotPass model


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> subModel -> Model
updateWith toModel toMsg model subModel =
    toModel subModel



-- View


view : Model -> Html Msg
view model =
    let
        outlet =
            case model of
                Pass subModule ->
                    Pass.view subModule

                _ ->
                    text "nothing"
    in
    div [ class "main" ]
        [ div [ class "outlet" ] [ outlet ]

        -- Footer
        , div [ class "footer" ]
            [ div [ class "lnr lnr-list" ] []
            , div [ class "lnr lnr-file-add" ] []
            , div [ class "lnr lnr-cog" ] []
            , div [ class "lnr lnr-exit" ] []
            ]
        ]
