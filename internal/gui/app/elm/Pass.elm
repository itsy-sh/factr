module Pass exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, button, div, i, input, table, td, text, th, tr)
import Html.Attributes exposing (class, colspan, placeholder, type_)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { query : String
    , showing : Dict String Bool
    , modal : Bool
    , toBeRemoved : String
    , entries : List Entry
    }


type alias Entry =
    { name : String
    , secret : String
    , metadata : Dict String String
    }


init : Model
init =
    emptyModel


type Msg
    = Nop
    | Search String
    | AskRemoveEntry String
    | RemoveEntry String
    | TogglePassword String
    | CloseModal


emptyModel : Model
emptyModel =
    { query = ""
    , showing = Dict.empty
    , modal = False
    , toBeRemoved = ""
    , entries =
        [ { name = "/mf/gmail.com"
          , secret = "password"
          , metadata =
                Dict.fromList
                    [ ( "user", "rasmus.holm@modularfinance.se" )
                    ]
          }
        , { name = "/mf/bitbucket.com"
          , secret = "Another password"
          , metadata =
                Dict.fromList
                    [ ( "user", "rasmus.holm@modularfinance.se" )
                    ]
          }
        , { name = "/mf/github.com"
          , secret = "Something Else"
          , metadata =
                Dict.fromList
                    [ ( "user", "c.r.holm@gmail.com" )
                    ]
          }
        , { name = "/mf/gitlabs.com"
          , secret = "Yet another password"
          , metadata =
                Dict.fromList
                    [ ( "user", "c.r.holm@gmail.com" )
                    ]
          }
        , { name = "/mf/MASTERCARD"
          , secret = "1234 5678 9012 3456"
          , metadata =
                Dict.fromList
                    [ ( "csv", "123" )
                    , ( "date", "11/21" )
                    , ( "Name", "Carl Rasmus Holm" )
                    ]
          }
        , { name = "/mf/VISA"
          , secret = "1234 5678 9012 3456"
          , metadata =
                Dict.fromList
                    [ ( "csv", "123" )
                    , ( "date", "11/21" )
                    , ( "Name", "Carl Rasmus Holm" )
                    ]
          }
        , { name = "/mf/AMEX"
          , secret = "1234 5678 9012 3456"
          , metadata =
                Dict.fromList
                    [ ( "csv", "123" )
                    , ( "date", "11/21" )
                    , ( "Name", "Carl Rasmus Holm" )
                    ]
          }
        ]
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model

        Search query ->
            { model | query = query }

        AskRemoveEntry name ->
            { model | modal = True, toBeRemoved = name }

        RemoveEntry name ->
            { model | modal = False, toBeRemoved = "", entries = model.entries |> List.filter (\i -> i.name /= name) }

        CloseModal ->
            { model | modal = False, toBeRemoved = "" }

        TogglePassword name ->
            togglePasswordFor name model


togglePasswordFor : String -> Model -> Model
togglePasswordFor name model =
    let
        show =
            case Dict.get name model.showing of
                Just True ->
                    False

                _ ->
                    True
    in
    { model | showing = Dict.insert name show model.showing }


view : Model -> Html Msg
view model =
    let
        modal =
            if model.modal then
                div [ class "modal" ]
                    [ div [ class "content z3" ]
                        [ div [ class "text" ] [ text "Are you sure you want to delete this item" ]
                        , div [ class "options" ]
                            [ button [ class "danger", onClick (RemoveEntry model.toBeRemoved) ] [ text "Yes" ]
                            , button [ onClick CloseModal ] [ text "No" ]
                            ]
                        ]
                    ]

            else
                div [] []
    in
    div [ class "pass " ]
        [ modal
        , div [ class "header" ]
            [ -- Header
              input
                [ placeholder "Search"
                , type_ "text"
                , onInput Search
                ]
                []
            ]
        , div [ class "entry-list" ]
            (model.entries
                |> List.filter (\n -> String.contains model.query (String.toLower n.name))
                |> List.sortBy (\n -> String.toLower n.name)
                |> List.map (viewEntry model.showing)
            )
        ]


viewEntry : Dict String Bool -> Entry -> Html Msg
viewEntry showing entry =
    --Dict.get entry.name
    let
        show =
            case Dict.get entry.name showing of
                Just True ->
                    True

                _ ->
                    False

        pwd =
            text
                (if show then
                    entry.secret

                 else
                    "********"
                )
    in
    div [ class "entry z2" ]
        [ i [ class "remove button lnr lnr-trash", onClick (AskRemoveEntry entry.name) ] []
        , table []
            ([ tr []
                [ td [ class "name", colspan 2 ] [ text entry.name ]
                ]
             , tr []
                [ th [] [ text "Secret" ]
                , td []
                    [ i [ class "button lnr lnr-lock", onClick (TogglePassword entry.name) ] []
                    , pwd
                    ]
                ]
             ]
                ++ viewMetadata entry.metadata
            )
        ]


viewMetadata : Dict String String -> List (Html msg)
viewMetadata meta =
    Dict.toList meta
        |> List.sortBy (\k -> k)
        |> List.map
            (\( k, v ) ->
                tr []
                    [ th [] [ text k ]
                    , td [] [ text v ]
                    ]
            )
