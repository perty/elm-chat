module Model exposing (ChatMessage, Model, initialModel)

import RemoteData exposing (RemoteData(..), WebData)
import Time


type alias Model =
    { channels : WebData (List String)
    , activeChannel : String
    , channelMessages : WebData (List ChatMessage)
    , searching : Bool
    , currentInputMessage : String
    , sendMessageState : WebData String
    , lastMessageReceived : String
    }


type alias ChatMessage =
    { author : String
    , content : String
    , created : Time.Posix
    }


initialModel : Model
initialModel =
    { channels = NotAsked
    , activeChannel = "general"
    , channelMessages = NotAsked
    , searching = False
    , currentInputMessage = ""
    , sendMessageState = NotAsked
    , lastMessageReceived = ""
    }
