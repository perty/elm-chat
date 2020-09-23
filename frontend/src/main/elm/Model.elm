module Model exposing (Model)

import RemoteData exposing (WebData)


type alias Model =
    { channels : WebData (List String)
    , activeChannel : String
    }
