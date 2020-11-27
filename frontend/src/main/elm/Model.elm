module Model exposing (Message, Model, initialModel)

import RemoteData exposing (RemoteData(..), WebData)
import Time


type alias Model =
    { channels : WebData (List String)
    , activeChannel : String
    , channelMessages : WebData (List Message)
    }


type alias Message =
    { author : String
    , content : String
    , created : Time.Posix
    }


initialModel : Model
initialModel =
    { channels = NotAsked
    , activeChannel = "general"
    , channelMessages = NotAsked
    }
