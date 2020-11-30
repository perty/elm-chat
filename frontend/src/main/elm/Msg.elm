module Msg exposing (Msg(..))

import Model exposing (Message)
import RemoteData exposing (WebData)
import Time


type Msg
    = Tick Time.Posix
    | SelectChannel String
    | HandleChannelResponse (WebData (List String))
    | HandleChannelMessagesResponse (WebData (List Message))
    | ToggleSearching
