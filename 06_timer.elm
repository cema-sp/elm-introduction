import Html exposing (Html, div, text)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)

main =
  App.program { init = init
              , view = view
              , update = update
              , subscriptions = subscriptions
              }

-- MODEL

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)

-- UPDATE

type Msg =
  Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)
      
-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick

-- VIEW

hands : Float -> Float -> (String, String)
hands angle len =
  let
    handX =
      toString (50 + len * cos angle)

    handY =
      toString (50 + len * sin angle)
  in
    (handX, handY)
    
view : Model -> Html Msg
view model =
  let
    secondAngle = 
      turns (Time.inMinutes model)

    minuteAngle = 
      turns (Time.inHours model)

    hourAngle = 
      turns ((Time.inHours model) / 12)

    (secondHandX, secondHandY) = hands secondAngle 40

    (minuteHandX, minuteHandY) = hands minuteAngle 30

    (hourHandX, hourHandY) = hands hourAngle 20
  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE", stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 secondHandX, y2 secondHandY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 minuteHandX, y2 minuteHandY, stroke "#023000" ] []
      , line [ x1 "50", y1 "50", x2 hourHandX, y2 hourHandY, stroke "#020000" ] []
      ]

