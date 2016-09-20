import Html exposing (Html, div, text, input, button)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket

main =
  App.program { init = init
              , view = view
              , update = update
              , subscriptions = subscriptions
              }

-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }

init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)

-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      ({ model | input = newInput }, Cmd.none)

    Send ->
      ({ model | input = "" }, WebSocket.send "ws://echo.websocket.org" model.input)

    NewMessage newMessage ->
      ({ model | messages = (newMessage :: model.messages)}, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://echo.websocket.org" NewMessage

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map viewMessage model.messages)
    , input [ onInput Input ] []
    , button [ onClick Send ] [ text "Send" ]
    ]

viewMessage : String -> Html msg
viewMessage message =
  div [] [ text message ]

      
