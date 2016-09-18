import Html exposing (Html, Attribute, div, input, text)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String

main =
  App.beginnerProgram { model = model
                      , view = view
                      , update = update
                      }

-- MODEL

type alias Model = { content : String }

model : Model
model = { content = "" }

-- UPDATE

type Msg = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newString ->
      { model | content = newString }
      
-- VIEW

view : Model -> Html Msg
view { content } =
  div []
    [ input [ placeholder "Text to reverse", onInput Change ] []
    , div [] [ text (String.reverse content) ]
    ]
