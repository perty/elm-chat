module Main exposing (main)

import Browser
import Data exposing (Message, sampleActiveChannel)
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg(..))
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http
import Time
import View exposing (view)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, loadChannels )


initialModel : Model
initialModel =
    { channels = NotAsked
    , activeChannel = sampleActiveChannel
    }


loadChannels : Cmd Msg
loadChannels =
    RemoteData.Http.get "http://localhost:8080/api/v1/channels" HandleChannelResponse channelDecoder


channelDecoder : Json.Decode.Decoder (List String)
channelDecoder =
    Json.Decode.list Json.Decode.string



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( model, Cmd.none )

        SelectChannel channel ->
            ( { model | activeChannel = channel }, Cmd.none )

        HandleChannelResponse channelList ->
            ( { model | channels = channelList }, Cmd.none )



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every second Tick


second =
    60000
