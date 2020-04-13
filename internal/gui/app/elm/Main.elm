module Main exposing (..)

-- MAIN

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Pass as Pass


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type Msg
    = GotPassMsg Pass.Msg


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
        ( GotPassMsg subMsg, Pass pass ) ->
            Pass.update subMsg pass
                |> updateWith Pass GotPassMsg model


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
                    Html.map GotPassMsg (Pass.view subModule)
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
