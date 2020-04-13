module Main exposing (..)

-- MAIN

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import New as New
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
    | GotNewMsg New.Msg


type State
    = Pass Pass.Model
    | New New.Model


type alias Model =
    { active : State
    , pass : Pass.Model
    , new : New.Model
    }


init : Model
init =
    emptyModel


emptyModel : Model
emptyModel =
    { active = Pass Pass.emptyModel
    , pass = Pass.emptyModel
    , new = New.emptyModel
    }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case ( msg, model.active ) of
        ( GotPassMsg subMsg, Pass pass ) ->
            Pass.update subMsg pass
                |> updatePass model
                |> Debug.log "1.1"

        --- Navigating
        ( GotPassMsg subMsg, _ ) ->
            Pass.update subMsg model.pass
                |> updatePass model
                |> Debug.log "1.2"

        ( GotNewMsg subMsg, New new ) ->
            New.update subMsg new
                |> updateNew model
                |> Debug.log "2.1"

        --- Navigating
        ( GotNewMsg subMsg, _ ) ->
            New.update subMsg model.new
                |> updateNew model
                |> Debug.log "2.2"


updatePass : Model -> Pass.Model -> Model
updatePass model sub =
    { model | active = Pass sub, pass = sub }


updateNew : Model -> New.Model -> Model
updateNew model sub =
    { model | active = New sub, new = sub }



-- View


view : Model -> Html Msg
view model =
    let
        outlet =
            case model.active of
                Pass sub ->
                    Html.map GotPassMsg (Pass.view sub)

                New subModule ->
                    Html.map GotNewMsg (New.view subModule)
    in
    div [ class "main" ]
        [ div [ class "outlet" ] [ outlet ]

        -- Footer
        , div [ class "footer" ]
            [ div [ class "lnr lnr-list", onClick (GotPassMsg Pass.Nop) ] []
            , div [ class "lnr lnr-file-add", onClick (GotNewMsg New.Nop) ] []
            , div [ class "lnr lnr-cog" ] []
            , div [ class "lnr lnr-exit" ] []
            ]
        ]
