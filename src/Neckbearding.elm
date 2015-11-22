module Neckbearding where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Signal exposing (Signal, Address)
import String
import Window

type alias Model =
    { players: List Player
    , numPlayers: Int
    }

type alias Player =
    { level: Int
    , avatarUrl: String
    , hand: List Card
    }

type alias Card =
    { cardType: CardType
    , value: Int
    , description: String
    }

type CardType =
    Grow
    | Shave
    | ProductManagement

defaultPlayer : Player
defaultPlayer =
    { level = 0
    , avatarUrl = "https://camo.githubusercontent.com/6e691de2070d0be92a90391b919dc0c0af2ab344/68747470733a2f2f696d67312e657473797374617469632e636f6d2f3031342f312f353534353239362f696c5f333430783237302e3434343731383636375f35397a702e6a7067"
    , hand = []
    }

getResultValue : Result String Int -> Int
getResultValue result =
    case result of
        Ok value -> value
        Err msg -> 0

update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model
        UpdateNumPlayers input -> { model | numPlayers = getResultValue (String.toInt input) }
        ChooseNumPlayers -> { model | players = List.repeat model.numPlayers defaultPlayer }

type Action =
    NoOp
    | ChooseNumPlayers
    | UpdateNumPlayers String

view : Address Action -> Model -> Html
view address model =
    div
      [
      ]
      [ if List.isEmpty model.players
        then input
        [ on "input" targetValue (Signal.message address << UpdateNumPlayers)
        , on "keydown" (Json.customDecoder keyCode isEnterKey) (\_ -> Signal.message address ChooseNumPlayers)
        , placeholder "Type in the number of players"
        ]
        [
        ]
        else div
        [
        ]
        [ text ("Game started with " ++ toString model.numPlayers ++ " players")
        , div
          [
          ]
          (List.indexedMap (
              \index player-> div
                []
                [ img [src player.avatarUrl] []
                , div [] [text ("Player " ++ toString index)]
                ]
          ) model.players)
        ]
      ]

isEnterKey : Int -> Result String ()
isEnterKey code =
    if code == 13 then Ok () else Err "not the enter key"

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
    { players = []
    , numPlayers = 0
    }
