module Neckbearding where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Signal exposing (Signal, Address)
import String
import Window

type alias Model =
    { started: Bool
    }

update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model
        Start -> { model | started = True }

type Action =
    NoOp
    | Start

view : Address Action -> Model -> Html
view address model =
    div
      [
      ]
      [
          text (if model.started then "started" else "not started")
      ]

main : Signal Html
main =
    Signal.map (view actions.address) model

actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp

model : Signal Model
model =
    Signal.foldp update initialModel actions.signal

initialModel : Model
initialModel =
    { started = False }
