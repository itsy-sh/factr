module Main exposing (..)



-- MAIN

import Browser
import Dict exposing (Dict)
import Html exposing (Html, div, input, table, td, text, th, tr)
import Html.Attributes exposing (class, colspan, placeholder, type_)
import Html.Events exposing (onInput)

main =
    Browser.sandbox{
        init = init,
        update = update,
        view = view
    }


-- MODEL
type Msg
    = NoOp
    | Search String


type alias Model =
    { entries : List Entry
    , state : State

    }

type alias State =
    { query : String
    }


type alias Entry =
    { name : String
    , secret : String
    , metadata : Dict String String
    }

init : Model
init = emptyModel


emptyModel : Model
emptyModel =
    {
        entries = [
            {
                name = "/mf/gmail.com"
                , secret = "password"
                , metadata = Dict.fromList[
                    ("user", "rasmus.holm@modularfinance.se")
                ]
            },
            {
                name = "/mf/bitbucket.com"
                , secret = "Another password"
                , metadata = Dict.fromList[
                    ("user", "rasmus.holm@modularfinance.se")
                ]
            },
            {
                name = "/mf/MASTERCARD"
                , secret = "1234 5678 9012 3456"
                , metadata = Dict.fromList[
                    ("csv", "123"),
                    ("date", "11/21"),
                    ("Name", "Carl Rasmus Holm")
                ]
            }
        ],
        state = {
            query = ""
        }
    }



-- UPDATE

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model
        Search query ->
            let
                oldState = model.state
                newState = { oldState | query = String.toLower query}
            in
            { model | state = newState }

-- View
view : Model -> Html Msg
view model =
    div [ class "main" ]
      [
        div [ class "header"] [  -- Header
            input
              [ placeholder "Search"
              , type_ "text"
              , onInput (Search)
              ] []
        ]
        , div [ class "list "] [ -- content
            viewEntries model.state model.entries
        ]
        , div [ class "footer"] [  -- Footer

          ]
      ]



viewEntries : State -> List Entry -> Html Msg
viewEntries state list =
    div [class "entry-list"] (
        list
        |> List.filter (\n -> String.contains state.query (String.toLower n.name))
        |> List.sortBy  (\n -> String.toLower n.name)
        |> List.map viewEntry
    )

viewEntry : Entry -> Html Msg
viewEntry entry =
    div [ class "entry z2" ] [
        table [] ([
            tr [ ] [
               td [class "name", colspan 2 ] [text entry.name]
            ],
            tr [] [
               th [] [text "Secret"]
             , td [] [text entry.secret]
            ]
        ] ++ viewMetadata entry.metadata)
    ]


viewMetadata: Dict String String -> List (Html msg)
viewMetadata meta =
    Dict.toList meta
    |> List.sortBy (\(k) -> k)
    |> List.map (\(k,v) ->
        tr [] [
            th [] [text k],
            td [] [text v]
        ])


