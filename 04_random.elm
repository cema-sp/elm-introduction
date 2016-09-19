import Html exposing (Html, div, h1, img, button, text)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random

main =
  App.program { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL

type alias Model =
  { dieFace1 : Int
  , dieFace2 : Int
  }

init : (Model, Cmd Msg)
init =
  (Model 1 1, generateFaces)

-- UPDATE

type Msg
  = Roll
  | NewFaces (Int, Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, generateFaces)

    NewFaces (newFace1, newFace2) ->
      (Model newFace1 newFace2, Cmd.none)


generateFaces : Cmd Msg
generateFaces =
  Random.generate NewFaces (Random.pair (Random.int 1 6) (Random.int 1 6))

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ dieFaceImg model.dieFace1
    , dieFaceImg model.dieFace2
    , button [ onClick Roll ] [ text "Roll" ]
    ]

dieFaceImg : Int -> Html msg
dieFaceImg n =
  img [ src ("./img/die_face_" ++ (toString n) ++ ".png"), height 30, width 30 ] []

