import Html exposing (Html, div, text, h2, img, button, br, input)
import Html.App exposing (program)
import Html.Attributes exposing (src, width, height, style, placeholder, defaultValue)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Json
import Task

main =
  program { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  , error : Maybe String
  }

init : (Model, Cmd Msg)
init =
  (Model "cats" "./img/wait.gif" Nothing, getRandomGif "cats")

-- UPDATE

type Msg
  = MorePlease
  | Topic String
  | FetchSucceed String
  | FetchFailed Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    Topic topic ->
      ({ model | topic = topic }, Cmd.none)

    FetchSucceed newUrl ->
      ({ model | gifUrl = newUrl, error = Nothing }, Cmd.none)

    FetchFailed httpError ->
      ({ model | error = Just (errorMsg httpError) }, Cmd.none)

errorMsg : Http.Error -> String
errorMsg httpError =
  case httpError of
    Http.Timeout ->
      "Timeout"

    Http.NetworkError ->
      "Connection error"

    Http.UnexpectedPayload _ ->
      "Invalid response"

    Http.BadResponse num _ ->
      "Bad response: " ++ toString num

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFailed FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "topic", defaultValue model.topic, onInput Topic ] []
    , errorFlash model.error
    , img [ src model.gifUrl, height 200 ] []
    , br [] []
    , button [ onClick MorePlease ] [ text "Moar!!111" ]
    ]

errorFlash : Maybe String -> Html msg
errorFlash error =
  case error of
    Nothing ->
      div [] []

    Just msg ->
      div [ style [("color", "red")] ] [ text msg ]

