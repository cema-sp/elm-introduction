import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String
import Char exposing (isLower, isUpper, isDigit)

main = 
  App.beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model =
  { name : String
  , age : String
  , password : String
  , passwordAgain : String
  , error : Maybe String
  }

model : Model
model =
  Model "" "" "" "" Nothing

-- UPDATE

type Msg = Name String
         | Age String
         | Password String
         | PasswordAgain String
         | Submit

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = age }
    
    Password password ->
      { model | password = password }

    PasswordAgain passwordAgain ->
      { model | passwordAgain = passwordAgain }

    Submit ->
      { model | error = validate model }

validate : Model -> Maybe String
validate model =
      if model.password /= model.passwordAgain then
        Just "Password do not match!"
      else 
        if String.length model.password < 8 then
          Just "Password too short (8 chars min)!"
        else
          if not (validatePasswordDifficulty model.password) then
            Just "Password is not difficult enough"
          else
            if not (String.all isDigit model.age) then
              Just "Age is not a number!"
            else
              Nothing

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ labeledInput "Name" "text" "Name" Name
    , labeledInput "Age" "text" "18" Age
    , labeledInput "Password" "password" "Password" Password
    , labeledInput "Password again" "password" "Re-enter Password" PasswordAgain
    , viewValidation model
    , button [ onClick Submit ] [ text "Submit" ]
    ]

labeledInput : String -> String -> String -> (String -> Msg) -> Html Msg
labeledInput lbl typ plchldr msg =
  div []
   [ label [] [ text lbl ]
   , input [ type' typ, placeholder plchldr, onInput msg ] []
   ]

viewValidation : Model -> Html msg
viewValidation { error } =
  case error of
    Just message ->
      div [ style [("color", "red")] ] [ text message ]

    Nothing ->
      div [ style [("color", "green")] ] [ text "OK" ]

validatePasswordDifficulty : String -> Bool
validatePasswordDifficulty password =
  if String.any isUpper password
  && String.any isLower password
  && String.any isDigit password then
     True
  else
     False

