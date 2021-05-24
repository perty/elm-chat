module Msg exposing (Msg(..))

import Model exposing (ChatMessage)
import RemoteData exposing (WebData)
import Time


type Msg
    = Tick Time.Posix
    | SelectChannel String
    | HandleChannelResponse (WebData (List String))
    | HandleChannelMessagesResponse (WebData (List ChatMessage))
    | ToggleSearching
    | UpdateCurrentInputMessage String
    | SendMessage
    | SendMessageResult (WebData String)
    | WebsocketIn String
