module Msg exposing (Msg(..))

import RemoteData exposing (WebData)
import Time


type Msg
    = Tick Time.Posix
    | SelectChannel String
    | HandleChannelResponse (WebData (List String))
