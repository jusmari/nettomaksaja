module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Html.Keyed as Keyed



---- MODEL ----


type alias Model =
    { name : String, city : String, entries : List Entry }


type alias Entry =
    { name : String, city : String }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" [], Cmd.none )



---- UPDATE ----


type Msg
    = Name String
    | City String
    | Submit Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Name name ->
            ( { model | name = name }, Cmd.none )

        City city ->
            ( { model | city = city }, Cmd.none )

        Submit m ->
            let
                newEntries =
                    Entry model.name model.city :: model.entries
            in
            ( { model | entries = newEntries, name = "", city = "" }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Nettomaksaja" ]
        , Html.form [ class "formStyles", onSubmit (Submit model) ]
            [ viewInput "text" "Name" model.name Name
            , viewInput "text" "Asuinkunta" model.city City
            , button [ type_ "submit" ] [ text "Tallenna" ]
            ]
        , div
            [ class "entries" ]
            [ h4
                []
                [ text "Entries", entryList model.entries ]
            ]
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


entryList : List Entry -> Html msg
entryList entries =
    div [] (List.map entryElement entries)


entryElement : Entry -> Html msg
entryElement entry =
    div [] [ text (entry.name ++ ", " ++ entry.city) ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
