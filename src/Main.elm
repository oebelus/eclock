module Main exposing (..)

import Browser
import Html exposing (..)
import Task
import Time
import Html.Attributes
import Svg exposing (circle)
import Svg.Attributes exposing (..)

-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

type alias Model =
    { zone : Time.Zone
    , time : Time.Posix    
    }

init : () -> (Model, Cmd Msg)
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )

-- UPDATE

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick

-- VIEW

view : Model -> Html Msg
view model =
    let
        hour = String.fromInt (Time.toHour model.zone model.time)
        minute = String.fromInt (Time.toMinute model.zone model.time)
        second = String.fromInt (Time.toSecond model.zone model.time)
    in
    div [ Html.Attributes.style "background-color" "black"
        , Html.Attributes.style "height" "100vh"
        , Html.Attributes.style "text-align" "center"
        , Html.Attributes.style "display" "flex"
        , Html.Attributes.style "flex-direction" "column"
        , Html.Attributes.style "justify-content" "center" 
        , Html.Attributes.style "align-items" "center"
        , Html.Attributes.style "font-family" "Roboto Mono, monospace"
        ]
    [ h1 [ Html.Attributes.style "margin" "0"
        , Html.Attributes.style "color" "rgb(0, 183, 235)"
        , Html.Attributes.style "font-size" "min(20vh, 15vw)"
        ] 
        [ text (hour ++ ":" ++ minute) ]
    , h2 [ Html.Attributes.style "margin" "0"
        , Html.Attributes.style "color" "rgb(0, 183, 235)"
        , Html.Attributes.style "font-size" "min(15vh, 12vw)"
        ] 
        [ text (second) ] 
    , Svg.svg
        [ Svg.Attributes.width "90vw"
        , Svg.Attributes.height "90vh"
        , viewBox "0 0 100 100" -- start viewing from point (0,0), area 100 units wide and tall
        , Html.Attributes.style "position" "absolute"
        ]
        [ circle 
            [ cx "50"
             , cy "50" 
            , r "50"
            , fill "rgba(0, 183, 235, 0.1)"
            , stroke "rgb(0, 183, 235)"
            , strokeDasharray "6"
            , strokeWidth "2" ]
            [] ]
    ]